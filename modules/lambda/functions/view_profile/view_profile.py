import boto3, json, os

# generates response object
def response_object(error_status, message=None, data=None):
    return {
                "statusCode": 400 if error_status == True else 200,
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": json.dumps({
                    "error": error_status,
                    "message": message,
                    "data": data
                })
            }

# Auxiliary functions
def view_profile(user_type, current_user):
    # Create clients
    dynamodb_client = boto3.resource("dynamodb")

    # Define the accepted schema
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
            }
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
            }
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
            }
        }
    }

    try:
        # Get current user
        table_name = os.environ[user_type.upper()+"_TABLE_NAME"]
        table = dynamodb_client.Table(table_name)
        result = table.get_item(
            Key = {"email": current_user}
        )

        data = result["Item"]
        data.pop("api_key")
        user_profile = {}

        for attr in schemas[user_type]["properties"]:
            if attr in data:
                user_profile[attr] = data[attr]
            else:
                user_profile[attr] = ""

        message = "Profile successfully fetched"
        return response_object(False, message, data = user_profile)

    except Exception as err:
        return response_object(True, err.__str__())

# Main function
def lambda_handler(event, context):
    # Event variables
    email = event["requestContext"]["authorizer"]["principalId"]

    return view_profile(
        user_type = event["stageVariables"]["user_type"],
        current_user = email
    )

# event = {
#     "queryStringParameters": {
#         "user_type": "user"
#     },
#     "requestContext": {
#         "username": "saheedlawanson47@gmail.com",
#     }
# }

# print(lambda_handler(event, None))