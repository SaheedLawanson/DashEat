import os, boto3, json


cognito_pool_IDs = {
    "dasher": os.environ["DASHER_POOL_ID"],
    "user": os.environ["USER_POOL_ID"],
    "vendor": os.environ["VENDOR_POOL_ID"]
}

# Auxiliary functions
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

def lambda_handler(event, context):
    # Create clients
    cognito_client = boto3.client("cognito-idp")
    dynamodb_client = boto3.resource("dynamodb")
    apigateway_client = boto3.client("apigateway")

    # Arguments
    user_type = event["stageVariables"]["user_type"]
    username = event["requestContext"]["authorizer"]["principalId"]
    api_key_id = event["requestContext"]["identity"]["apiKeyId"]

    table_name = os.environ[f"{user_type.upper()}_TABLE_NAME"]
    table = dynamodb_client.Table(table_name)

    try:
        # Delete API key
        apigateway_client.delete_api_key(
            apiKey = api_key_id
        )

        # Delete user from userpool
        cognito_client.delete_user(
            AccessToken = event["headers"]["authorizationToken"]
        )

        # Delete user from database
        response = table.delete_item(
            Key = {"email": username}
        )
        response.pop("ResponseMetadata")
        return response_object(False, data=response)

    except cognito_client.exceptions.UserNotFoundException:
        message = "This user does not exist"
        return response_object(True, message)
    except Exception as err:
        return response_object(True, err.__str__())




# test_event = {
#     "queryStringParameters": {
#         "user_type": "dasher"
#     },
#     "pathParameters": {
#         "email": "saheedlawanson47@gmail.com"
#     }
# }

# print(lambda_handler(test_event, None))