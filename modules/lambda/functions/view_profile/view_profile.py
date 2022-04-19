import boto3, json, os

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


# Auxiliary functions
def view_profile(current_user, table, schema):

    # Get current user
    result = table.get_item(
        Key = { "email": current_user }
    )
    item = result["Item"]

    user_profile = {}
    for attr in schema["properties"]:
        if attr in item:
            user_profile[attr] = item[attr]
        else:
            user_profile[attr] = ""

    return user_profile



# Main function
def lambda_handler(event, context):
    schemas = {
        "dasher": {
            "type": "object",
            "properties": {
                "first_name": "string", # Should be immutable
                "last_name": "string", # Should be immutable
                "gender": "string", # Should be immutable
                "birth_date": "string", # Should be immutable
                "address": "string",
                "contact_no": {
                    "type": "number",
                    "pattern": "^\d{11}$"
                },
                "email": "string", # Should be immutable
                "wallet": "string", # Should be immutable
                "profile_img": "string",
                # "registration_date": "string", # Should be immutable
                "status": "string", # Should be immutable
                "rating": "number"
            },
            "additionalProperties": False
        },
        "user": {
            "type": "object",
            "properties": {
                "first_name": "string", # Should be immutable
                "last_name": "string", # Should be immutable
                "gender": "string", # Should be immutable
                "birth_date": "string", # Should be immutable
                "address": "string",
                "contact_no": {
                    "type": "string",
                    "pattern": "^\d{11}$"
                },
                "profile_img": "string",
                "lat": "number",
                "long": "number",
            },
            "additionalProperties": False
        },
        "vendor": {
            "type": "object",
            "properties": {
                "vendor_name": "string",
                "category": "string",
                "contact": "string",
                "schedule_ID": "string",
                "menu": "list",
                "email": "string",
                "rating": "number" # Should be immutable
            },
            "additionalProperties": False
        }
    }

    # RESOURCE HANDLES
    # Clients
    dynamodb_client = boto3.resource("dynamodb")
    exceptions = boto3.client("dynamodb").exceptions

    try:
        # Event variables
        email = event["requestContext"]["authorizer"]["principalId"]
        user_type = event["stageVariables"]["user_type"]

        table_name = os.environ[user_type.upper()+"_TABLE_NAME"]
        table = dynamodb_client.Table(table_name)

        user_profile = view_profile(
            current_user = email,
            table = table,
            schema = schemas[user_type]
        )

        message = "Profile successfully fetched"
        return response_object(False, message, data = user_profile)

    except exceptions.ResourceNotFoundException:
        message = "This user does not exist"
        return response_object(True, message, error_code = 401)

    except Exception as err:
        return response_object(True, err.__str__(), error_code = 400)

# event = {
#     "queryStringParameters": {
#         "user_type": "user"
#     },
#     "requestContext": {
#         "username": "saheedlawanson47@gmail.com",
#     }
# }

# print(lambda_handler(event, None))