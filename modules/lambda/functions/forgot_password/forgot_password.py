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


def lambda_handler(event, context):
    # Create clients
    cognito_client = boto3.client("cognito-idp")

    # Arguments
    user_type = event["pathParameters"]["user_type"]
    email = event['queryStringParameters']["email"]

    try:
        # Send code to email
        response = cognito_client.forgot_password(
            ClientId = cognito_client_IDs[user_type],
            Username = email
        )
        response.pop("ResponseMetadata")
        return response_object(False, data = response)

    except cognito_client.exceptions.UserNotFoundException:
        message = "This user does not exist"
        return response_object(True, message, error_code = 404)
    except Exception as err:
        return response_object(True, err, error_code = 400)


# test_event = {
#     "body": {
#         "user_type": "dasher",
#         "email": "saheedlawanson47@gmail.com"
#     }
# }

# print(lambda_handler(test_event, None))