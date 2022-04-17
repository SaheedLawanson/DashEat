import os, boto3, jsonschema, re, json
import hmac, hashlib
from secrets import token_hex

cognito_client_IDs = {
    'dasher': os.environ["DASHER_CLIENT_ID"],
    'user': os.environ["USER_CLIENT_ID"],
    'vendor': os.environ["VENDOR_CLIENT_ID"]
}

usage_plan_IDs = {
    'dasher': os.environ["DASHER_USAGE_PLAN"],
    'user': os.environ["USER_USAGE_PLAN"],
    'vendor': os.environ["VENDOR_USAGE_PLAN"]
}

# Auxiliary functions
# generates response object for return conditions
def response_object(error_status, message=None, data=None, error_code=None):
    return {
                "statusCode": error_code if error_status else 200,
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": json.dumps({
                    "error": error_status,
                    "message": message,
                    "data": data
                })
            }

# Creates API Key for signed up users
def create_api_key(user_ID, usage_plan_id):
    apigateway_client = boto3.client('apigateway')

    try:
        api_key = apigateway_client.create_api_key(
            name=user_ID,
            enabled=True,
            generateDistinctId=True,
        )

        usage_plan_key = apigateway_client.create_usage_plan_key(
            usagePlanId = usage_plan_id,
            keyId = api_key["id"],
            keyType='API_KEY'
        )

        data = {
            "api_key_id": api_key["id"],
            "api_key": api_key["value"],
            "usage_plan_key_id": usage_plan_key["id"],
            "usage_plan_key": usage_plan_key["value"]
        }
        return data

    except Exception as err:
        return response_object(True, err.__str__(), error_code = 400)

# signs up users
def signup(form, required_schema, client_ID, user_attributes, table_name, user_type, ID="email"):

    # Create resource clients
    cognito_client = boto3.client('cognito-idp')
    dynamodb_client = boto3.resource('dynamodb')

    # Table
    table = dynamodb_client.Table(table_name)

    # Make sure form is not empty
    if not form:
        message = "All required fields are missing"
        return response_object(True, message)

    # Check if all required fields are supplied
    try:
        jsonschema.validate(
            instance = form,
            schema = required_schema
        )
    except jsonschema.exceptions.ValidationError as e:
        return response_object(True, message = e.message, error_code = 406)
    except Exception as e:
        return response_object(True, message = e, error_code = 400)

    # Extract attributes that are not required
    other_attrs = {attr: form.pop(attr) for attr in list(
        filter(lambda attr: attr not in required_schema['properties'], form)
        )
    }

    # Make sure the email is in the right format
    if "email" in form:
        email_regex = re.compile('[a-zA-Z][a-zA-Z_\-0-9]+@[a-zA-Z]{2,}\.[a-zA-Z]{2,}')
        if not re.match(email_regex, form['email']):
            message = "Invalid email format"
            return response_object(True, message, error_code=412)

    # Make sure a user with the same ID doesn't exist in our table already
    response = table.get_item(
        Key = {ID: form[ID]}
    )
    if "Item" in response:
        message = "User already exists"
        return response_object(True, message, error_code=409)

    # Sign up user
    password = form.pop('password')
    try:
        response = cognito_client.sign_up(
            ClientId = client_ID,
            # SecretHash = ,
            Username = form[ID],
            Password = password,
            UserAttributes = user_attributes,
            ValidationData = [{"Name": ID, "Value": form[ID]}]
        )
    except cognito_client.exceptions.InvalidPasswordException as e:
        message = "Invalid password"
        return response_object(True, message, error_code = 401)
    except cognito_client.exceptions.UsernameExistsException as e:
        message = "User already exists, please login"
        return response_object(True, message, error_code = 409)

    # Create API key and attach to a usage plan
    api_key_info = create_api_key(
        user_ID = form['email'],
        usage_plan_id = usage_plan_IDs[user_type]
    )

    # Add user details to database
    storage_form = {**form, **other_attrs, "api_key": api_key_info["api_key"]}
    table.put_item(
        Item = {attr: storage_form[attr] for attr in storage_form}
    )

    data = api_key_info

    message = f"OTP has been sent to {response['CodeDeliveryDetails']['Destination']}"
    return response_object(False, message, data)



# Main function
def lambda_handler(event, context):
    # Arguments
    form = json.loads(event["body"])
    user_type = event["pathParameters"]["user_type"]

    schemas = {
        "dasher": {
            "type": "object",
            "properties":{
                "email": {"type": "string"},
                "first_name": {"type": "string"},
                "password": {"type": "string"}
            },
            "required": ["email", "first_name", "password"]
        },
        "user": {
            "type": "object",
            "properties":{
                "email": {"type": "string"},
                "first_name": {"type": "string"},
                "password": {"type": "string"}
            },
            "required": ["email", "first_name", "password"]
        },
        "vendor": {
            "type": "object",
            "properties":{
                "email": {"type": "string"},
                "vendor_name": {"type": "string"},
                "password": {"type": "string"}
            },
            "required": ["email", "vendor_name", "password"]
        }
    }

    attributes = {
        "dasher": [
            {"Name": "given_name", "Value": form["first_name"]},
            {"Name": "email", "Value": form['email']}
        ],
        "user": [
            {"Name": "given_name", "Value": form["first_name"]},
            {"Name": "email", "Value": form['email']}
        ],
        "vendor": [
            {"Name": "vendor_name", "Value": form["first_name"]},
            {"Name": "email", "Value": form['email']}
        ],
    }

    # Sign up
    response = signup(
        form = form,
        required_schema = schemas[user_type],
        client_ID = cognito_client_IDs[user_type],
        user_attributes = attributes[user_type],
        user_type = user_type,
        table_name = os.environ[user_type.upper()+"_TABLE_NAME"]
    )


    return response


# test_event = {
#     "body": json.dumps({
#         "email": "saheedlawanson47@gmail.com",
#         "password": "Seedboy13",
#         "first_name": "saheed",
#         "user_type": "dasher"
#     }),
#     "pathParameters": {
#       "user_type": "dasher"
#   }
# }

# print(lambda_handler(test_event, None))


# export "DASHER_CLIENT_ID"="4mg4h9m7kjjkni2gi1r217fqc9"
# export "DASHER_TABLE_NAME"="dev_dasher_table"
# export "DASHER_USAGE_PLAN"=" 00rfux"
# export "USER_CLIENT_ID"="4gdl9r9ob3rpgstbcskimltlmg"
# export "USER_TABLE_NAME"="dev_user_table"
# export "USER_USAGE_PLAN"=" mac0kr"
# export "VENDOR_CLIENT_ID"="72fm3cusi5u4atu29r6svktli6"
# export "VENDOR_TABLE_NAME"="dev_vendor_table"
# export "VENDOR_USAGE_PLAN"="2tky39"
# export "DASHER_CLIENT_ID"="4mg4h9m7kjjkni2gi1r217fqc9"
# export "DASHER_TABLE_NAME"="dev_dasher_table"
# export "DASHER_USAGE_PLAN"=" 00rfux"
# export "USER_CLIENT_ID"="4gdl9r9ob3rpgstbcskimltlmg"
# export "USER_TABLE_NAME"="dev_user_table"
# export "USER_USAGE_PLAN"=" mac0kr"
# export "VENDOR_CLIENT_ID"="72fm3cusi5u4atu29r6svktli6"
# export "VENDOR_TABLE_NAME"="dev_vendor_table"
# export "VENDOR_USAGE_PLAN"=" 2tky39"