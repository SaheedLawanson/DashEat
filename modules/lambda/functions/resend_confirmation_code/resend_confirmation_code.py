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
    print(cognito_client_IDs['dasher'])
    # Create client
    cognito_client = boto3.client('cognito-idp')

    # Arguments
    user_type = event["pathParameters"]["user_type"]

    try:
        response = cognito_client.resend_confirmation_code(
            ClientId = cognito_client_IDs[user_type],
            Username = event["queryStringParameters"]["email"]
        )

        return response_object(False, data=response)
    except Exception as err:
        return response_object(True, err, 400)


# test_event = {
#     "queryStringParameters": {
#         "email": "saheedlawanson47@gmail.com",
#         "user_type": "dasher"
#     }
# }

# print(lambda_handler(test_event, None))