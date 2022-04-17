import boto3, os, json

cognito_client_IDs = {
    'dasher': os.environ["DASHER_CLIENT_ID"],
    'user': os.environ["USER_CLIENT_ID"],
    'vendor': os.environ["VENDOR_CLIENT_ID"]
}

# Auxiliary functions
# generates response object
def response_object(error_status, message=None, data=None, error_code=None):
    return {
                "statusCode": error_code if error_status == True else 200,
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": json.dumps({
                    "error": error_status,
                    "message": message,
                    "data": data
                })
            }

# Signs in users
def signin(username, password, client_ID, user_type):
    # Create clients
    cognito_client = boto3.client("cognito-idp")
    dynamodb_client = boto3.resource("dynamodb")

    table_name = os.environ[user_type.upper()+"_TABLE_NAME"]
    table = dynamodb_client.Table(table_name)

    try:
        # Get API key
        user_data = table.get_item(
            Key = {"email": username},
        )

        # Get token
        response = cognito_client.initiate_auth(
            AuthFlow = "USER_PASSWORD_AUTH",
            AuthParameters = {
                "USERNAME": username,
                "PASSWORD": password,
            },
            ClientId = client_ID
        )

        val = {
            "user_access_token": response["AuthenticationResult"]["AccessToken"],
            "user_api_key": user_data["Item"]["api_key"]
        }
        return response_object(False, data = val)

    except cognito_client.exceptions.UserNotFoundException:
        message = "Invalid username or password"
        return response_object(True, message, error_code=404)
    except cognito_client.exceptions.UserNotConfirmedException:
        message = "Please activate your account before sign in"
        return response_object(True, message, error_code = 407)
    except Exception as err:
        return response_object(True, err.__str__(), error_code = 400)


# Main function
def lambda_handler(event, context):
    # Arguments
    body = json.loads(event["body"])
    user_type = event["pathParameters"]["user_type"]

    return signin(
        username = body["email"],
        password = body["password"],
        client_ID = cognito_client_IDs[user_type],
        user_type = user_type
    )

# test_event = {
#     "body": json.dumps({
#         "user_type": "dasher",
#         "email": "saheedlawanson47@gmail.com",
#         "password": "Seedboy13"
#     })
# }

# print(lambda_handler(test_event, None))