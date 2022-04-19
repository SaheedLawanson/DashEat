import boto3, json, os
from jsonschema import validate, exceptions

# EXCEPTIONS
class ImmutableAttributeException(Exception):
    def __init__(self, immutable_attr):
        self.immutable_attr = immutable_attr

    def __str__(self):
        return repr(self.immutable_attr)

# AUXILIARY FUNCTIONS
# generates response object
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

# Dynamically generates an update expression for dynamo db
def generate_update_exp(form, immutable_fields):
    attr_values = {}
    attr_keys = {}
    def immutable_exp (attr, val):
        attr_values[f":{attr}"] = val
        attr_keys[f"#{attr}"] = attr
        return f"#{attr} = if_not_exists(#{attr}, :{attr})"

    def mutable_exp(attr, val):
        attr_values[f":{attr}"] = val
        attr_keys[f"#{attr}"] = attr
        return f"#{attr} = :{attr}"

    exp = []
    for attr, value in form.items():
        if attr in immutable_fields:
            exp.append(immutable_exp(attr, value))
        else:
            exp.append(mutable_exp(attr, value))

    return {
        "update_exp": f"SET {', '.join(exp)}",
        "exp_attr_vals": attr_values,
        "exp_attr_keys": attr_keys
    }


# MAIN FUNCTION
def lambda_handler(event, context):
    # CLIENTS
    dynamodb_client = boto3.resource('dynamodb')

    # Define the accepted schema
    schemas = {
        "dasher": {
            "type": "object",
            "properties": {
                # "first_name": "string", # Should be immutable
                "last_name": {"type": "string"}, # Should be immutable
                "gender": {"type": "string"}, # Should be immutable
                "birth_date": {"type": "string"}, # Should be immutable
                "address": {"type": "string"},
                "contact_no": {
                    "type": "number",
                    "pattern": "^\d{11}$"
                },
                # "email": "string", # Should be immutable
                # "wallet": "string", # Should be immutable
                "profile_img":  {"type": "string"},
                # "registration_date": "string", # Should be immutable
                "status":  {"type": "string"}, # Should be immutable
                # "rating": "number"
            },
            "additionalProperties": False
        },
        "user": {
            "type": "object",
            "properties": {
                # "first_name": "string", # Should be immutable
                "last_name":  {"type": "string"}, # Should be immutable
                "gender":  {"type": "string"}, # Should be immutable
                "birth_date":  {"type": "string"}, # Should be immutable
                "address":  {"type": "string"},
                "contact_no": {
                    "type": "string",
                    "pattern": "^\d{11}$"
                },
                "profile_img":  {"type": "string"},
                "lat":  {"type": "number"},
                "long":  {"type": "number"},
            },
            "additionalProperties": False
        },
        "vendor": {
            "type": "object",
            "properties": {
                "vendor_name":  {"type": "string"},
                "category":  {"type": "string"},
                "contact": {"type": "string"},
                "schedule_ID":  {"type": "string"},
                "menu":  {"type": "array"},
                "email":  {"type": "string"},
                # "rating": "number" # Should be immutable
            },
            "additionalProperties": False
        }
    }

    immutable_values = {
        "dasher": ["last_name", "gender", "birth_date"],
        "user": ["last_name", "gender", "birth_date"],
        "vendor": []
    }

    try:
        form = json.loads(event["body"])

        current_user = event["requestContext"]["authorizer"]["principalId"]
        user_type = event["stageVariables"]["user_type"]

        # Get table of current_user
        table_name = os.environ[f"{user_type.upper()}_TABLE_NAME"]
        table = dynamodb_client.Table(table_name)

        # Eliminate null values and validate
        form = { field: val for field, val in form.items() if val }
        validate(form, schemas[user_type]) # jsonschema ~> imports

        # Check if there's an attempt to update immutable attributes
        response = table.get_item(
            Key = { "email": current_user }
        )
        user_attrs = response["Item"]
        for attr in user_attrs:
            if attr in form:
                raise ImmutableAttributeException(attr)

        # Updates table with profile
        # Makes sure immutable attributes can only be added but not updated
        update_exp,  exp_attr_vals, exp_attr_keys = generate_update_exp(form, immutable_values[user_type]).values() # generate_update_exp ~> custom function
        response = table.update_item(
            Key = { "email": current_user },
            UpdateExpression = update_exp,
            ExpressionAttributeValues = exp_attr_vals,
            ExpressionAttributeNames = exp_attr_keys
        )
        response.pop("ResponseMetadata")

        return response_object(False, message = "Profile successfully updated")

    except exceptions.ValidationError:  # jsonschema ~> imports
        message = "Incorrect parameters supplied"
        return response_object(True, message, error_code = 401)

    except ImmutableAttributeException as err:
        message = f"The {err.__str__()} field cannot be updated"
        return response_object(True, message, error_code = 402)

    except Exception as err:
        return response_object(True, err.__str__(), error_code = 400)

