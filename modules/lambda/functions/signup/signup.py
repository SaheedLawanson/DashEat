import os, boto3, jsonschema, re, json

# Keys
# DF = Defined function
# DM = Destructured module

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

# CUSTOM EXCEPTIONS
class UserExistsException(Exception):
    pass
class MissingFieldException(Exception):
    pass
class IncorrectInputFormatException(Exception):
    pass

# AUXILIARY FUNCTIONS
# generates response object for return conditions
def response_object(error_status, message=None, data=None, error_code=400):
    code = error_code if error_status else 200
    return {
                "statusCode": code,
                "body": json.dumps({
                    "error": error_status,
                    "status_code": code,
                    "message": message,
                    "data": data
                })
            }

# Creates API Key for signed up users and link to appropriate usage plan
def create_api_key(user_ID, usage_plan_ID):
    apigateway_client = boto3.client('apigateway')

    api_key = apigateway_client.create_api_key(
        name=user_ID,
        enabled=True,
        generateDistinctId=True,
    )

    usage_plan_key = apigateway_client.create_usage_plan_key(
        usagePlanId = usage_plan_ID,
        keyId = api_key["id"],
        keyType='API_KEY'
    )

    response = {
        "api_key_id": api_key["id"],
        "api_key": api_key["value"],
        "usage_plan_key_id": usage_plan_key["id"],
        "usage_plan_key": usage_plan_key["value"]
    }
    return response

# Form validation
def form_validator(form, required_schema, table, ID):
    # Make sure form is not empty
    if not form: raise MissingFieldException

    # Ensures submitted form conforms to given schema
    jsonschema.validate(
            instance = form,
            schema = required_schema
        )

    # Makes sure the email is in the right format
    if "email" in form:
        email_regex = re.compile('[a-zA-Z][a-zA-Z_\-0-9]+@[a-zA-Z]{2,}\.[a-zA-Z]{2,}')
        if not re.match(email_regex, form['email']):
            raise IncorrectInputFormatException

    # Makes sure a user with the same ID doesn't exist in our table already
    response = table.get_item(
        Key = {ID: form[ID]}
    )
    if "Item" in response:
        message = "User already exists"
        raise UserExistsException

    return

# signs up users
def signup(form, required_schema, client_ID, user_attributes, table_name, user_type, ID="email"):

    # RESOURCE HANDLES
    # Resource clients
    cognito_client = boto3.client('cognito-idp')

    dynamodb_client = boto3.resource('dynamodb')
    table = dynamodb_client.Table(table_name)

    # Validates the submitted form
    form_validator(form, required_schema, table, ID) # DF ~> Ln 66

    # Configure API key and usage plan
    create_api_key(form[ID], usage_plan_IDs[user_type]) # DF ~> Ln 42

    # Sign up user
    try:
        password = form.pop('password')
        response = cognito_client.sign_up(
            ClientId = client_ID,
            Username = form[ID],
            Password = password,
            UserAttributes = user_attributes,
            ValidationData = [{ "Name": ID, "Value": form[ID] }]
        )
    except cognito_client.exceptions.UsernameExistsException:
        raise UserExistsException

    # Add user details to database
    table.put_item(Item = form)

    return response


# MAIN FUNCTION
def lambda_handler(event, context):
    schemas = {
            "dasher": {
                "type": "object",
                "properties":{
                    "email": {"type": "string"},
                    "first_name": {"type": "string"},
                    "password": {"type": "string"}
                },
                "required": ["email", "first_name", "password"],
                "additionalProperties": False
            },
            "user": {
                "type": "object",
                "properties":{
                    "email": {"type": "string"},
                    "first_name": {"type": "string"},
                    "password": {"type": "string"}
                },
                "required": ["email", "first_name", "password"],
                "additionalProperties": False
            },
            "vendor": {
                "type": "object",
                "properties":{
                    "email": {"type": "string"},
                    "vendor_name": {"type": "string"},
                    "password": {"type": "string"}
                },
                "required": ["email", "vendor_name", "password"],
                "additionalProperties": False
            }
        }

    attributes = lambda form: {
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

    try:
        # Arguments
        form = json.loads(event["body"])
        user_type = event["pathParameters"]["user_type"]

        table_name = os.environ[user_type.upper()+"_TABLE_NAME"]

        # Sign up
        response = signup(      # DF ~> Ln 93
            form = form,
            required_schema = schemas[user_type],
            client_ID = cognito_client_IDs[user_type],
            user_attributes = attributes(form)[user_type],
            user_type = user_type,
            table_name = table_name
        )

        message = f"OTP has been sent to {response['CodeDeliveryDetails']['Destination']}"
        return response_object(False, message)

    except MissingFieldException:
        message = "Required fields are missing"
        return response_object(True, message, error_code = 401)

    except IncorrectInputFormatException:
        message = "Invalid email format"
        return response_object(True, message, error_code = 402)

    except UserExistsException:
        message = "User already exists"
        return response_object(True, message, error_code = 403)

    except jsonschema.exceptions.ValidationError:
        message = "Form doesn't match the required schema"
        return response_object(True, message, error_code = 405)

    except Exception as err:
        message = "Services Error" # err.__str__()
        return response_object(True, message, error_code = 400)



# test_event = {
#     "body": json.dumps({
#         "email": "saheedlawanson47@gmail.com",
#         "password": "Seedboy13",
#         "first_name": "saheed",
#     }),
#     "pathParameters": {
#       "user_type": "dasher"
#   }
# }

# print(lambda_handler(test_event, None))

