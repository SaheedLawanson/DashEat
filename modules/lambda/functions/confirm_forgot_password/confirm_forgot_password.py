import boto3, os, json

cognito_client_IDs = {
    'dasher': os.environ["DASHER_CLIENT_ID"],
    'user': os.environ["USER_CLIENT_ID"],
    'vendor': os.environ["VENDOR_CLIENT_ID"]
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


# Main function
def lambda_handler(event, context):
    # Clients
    cognito_client = boto3.client("cognito-idp")

    try:
        # Arguments
        body = json.loads(event["body"])
        user_type = event["pathParameters"]['user_type']

        # confirm forgotten password
        cognito_client.confirm_forgot_password(
            ClientId = cognito_client_IDs[user_type],
            Username = body["email"],
            ConfirmationCode = body["code"],
            Password = body["new_password"]
        )

        message = "Password successfully reset"
        return response_object(False, message)

    except cognito_client.exceptions.CodeMismatchException:
        message = "Invalid code, try again"
        return response_object(True, message, error_code = 401)

    except cognito_client.exceptions.InvalidPasswordException:
        message = "Invalid password, try again"
        return response_object(True, message, error_code = 403)

    except cognito_client.exceptions.ExpiredCodeException:
        message = "This code has expired, make sure you input the most recent code"
        return response_object(True, message, 406)

    except Exception as err:
        return response_object(True, err.__str__(), 400)


# test_event = {
#     "body": json.dumps({
#         "email": "saheedlawanson47@gmail.com",
#         "code": '611952',
#         "new_password": "Teedboy13",
#         "user_type": "dasher"
#     })
# }

# print(lambda_handler(test_event, None))