import os, boto3, json


cognito_pool_IDs = {
    "dasher": os.environ["DASHER_POOL_ID"],
    "user": os.environ["USER_POOL_ID"],
    "vendor": os.environ["VENDOR_POOL_ID"]
}

# Auxiliary functions
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

def lambda_handler(event, context):
    # Create clients
    cognito_client = boto3.client("cognito-idp")
    dynamodb_client = boto3.resource("dynamodb")
    apigateway_client = boto3.client("apigateway")

    try:
        auth_context = event["requestContext"]

        # Arguments
        user_type = event["stageVariables"]["user_type"]
        username = auth_context["authorizer"]["principalId"]

        table_name = os.environ[f"{user_type.upper()}_TABLE_NAME"]
        table = dynamodb_client.Table(table_name)

        # Delete user from appropriate userpool
        cognito_client.delete_user(
            AccessToken = event["headers"]["authorizationToken"]
        )

        # Delete all API keys attached to user
        response = apigateway_client.get_api_keys(
            nameQuery = username,
            includeValues = True
        )
        api_keys = response["items"]

        for api_key in api_keys:
            apigateway_client.delete_api_key( apiKey = api_key["id"] )

        # Delete user from database
        response = table.delete_item(
            Key = {"email": username}
        )
        response.pop("ResponseMetadata")

        return response_object(False, data=response)

    except cognito_client.exceptions.UserNotFoundException:
        message = "This user does not exist"
        return response_object(True, message, error_code = 401)

    except apigateway_client.exceptions.NotFoundException:
        message = "API key with this ID not found"
        return response_object(True, message, error_code = 501)

    except Exception as err:
        message = err.__str__()
        return response_object(True, message, error_code = 400)




# test_event = {
#     "queryStringParameters": {
#         "user_type": "dasher"
#     },
#     "pathParameters": {
#         "email": "saheedlawanson47@gmail.com"
#     }
# }

# print(lambda_handler(test_event, None))