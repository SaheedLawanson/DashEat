import os, boto3, json

cognito_client_IDs = {
    'dasher': os.environ["DASHER_CLIENT_ID"],
    'user': os.environ["USER_CLIENT_ID"],
    'vendor': os.environ["VENDOR_CLIENT_ID"]
}


# Auxiliary functions
# generates response object
def response_object(error_status, message=None, data=None, error_code = None):
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

# Main function
def lambda_handler(event, context):
    # Create resource clients
    cognito_client = boto3.client('cognito-idp')

    # Arguments
    body = json.loads(event["body"])
    user_type = event["pathParameters"]["user_type"]

    # Confirm signup
    try:
        response = cognito_client.confirm_sign_up (
            ClientId = 	cognito_client_IDs[user_type],
            Username = body["email"],
            ConfirmationCode = body["code"]
        )
        message = "Your account has been successfully activated"
        return response_object(False, message)

    except cognito_client.exceptions.CodeMismatchException:
        message = "Invalid code, try again"
        return response_object(True, message, error_code = 401)

    except cognito_client.exceptions.TooManyFailedAttemptsException:
        message = "Invalid code, too many failed attempts"
        return response_object(True, message, error_code = 403)

    except cognito_client.exceptions.ExpiredCodeException:
        message = "This code has expired, please generate a new confirmation code"
        return response_object(True, message, error_code = 406)

    except Exception as err:
        return response_object(True, err.__str__(), error_code = 400)


# ------ test ---------------
# test_event = {
#   "body": json.dumps({
#     "email": "saheedlawanson47@gmail.com",
#     "code": "718986",
#     "user_type": "dasher"
#   })
# }

# print(lambda_handler(test_event, None))