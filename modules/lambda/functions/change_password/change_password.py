import boto3, os, json

# Auxiliary functions
# generates response object
def response_object(error_status, message=None, data=None, error_code=400):
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


# Main function
def lambda_handler(event, context):
    # Create clients
    cognito_client = boto3.client("cognito-idp")

    # Arguments
    body = json.loads(event["body"])
    try:
        # Change password
        cognito_client.change_password(
            PreviousPassword= body["previous_password"],
            ProposedPassword= body["new_password"],
            AccessToken = event["headers"]["authorizationToken"]
        )
        message = "Password changed successfully"
        return response_object(False, message)

    except Exception as err:
        return response_object(True, err.__str__())


# test_event = {
#     "body": {
#         "previous_password": "Seedboy13",
#         "new_password": "Teedboy13",
#         "access_token": "eyJraWQiOiI3aFNpSlY0cVRyZ1dFOVoxYTlSeVYwczNoYVUraEJQQU5tTVhHb0ZNXC9cL0k9IiwiYWxnIjoiUlMyNTYifQ.eyJvcmlnaW5fanRpIjoiY2FhNDU4ZWYtZDM3ZS00MTAxLTk3M2ItNTExODk1MzJiOTIwIiwic3ViIjoiZjE5OTJmZjYtZjIzYy00MGY5LTk2MTEtYjA0YjU2ZjQ5ZGQ1IiwiZXZlbnRfaWQiOiJhYTZmOGIyMi0xNDJkLTRhZTMtYTZiOS1jZGYzMmM4NTk1ZTIiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNjQ3OTY5MDg3LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0yLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMl9iczB1QmRNNlciLCJleHAiOjE2NDc5NzI2ODcsImlhdCI6MTY0Nzk2OTA4NywianRpIjoiYWIwNGIzMTItMjcyYS00YzIyLWJmNDMtMDQ3NTJlNzI3MTQwIiwiY2xpZW50X2lkIjoiM3ZrcWExODVzamdtOTdoNnVrYXFsOTlmcWwiLCJ1c2VybmFtZSI6InNhaGVlZGxhd2Fuc29uNDdAZ21haWwuY29tIn0.drEFtFiDHXM5cLDsBJ2eDNAPJEZJ8Bfw_H1BAqOJHQRoxjtc8-2J0dKJeE8__x4lSiCrRkDH25br-jOxA03li5uWmIW38GcjPrJEqcYsdIi54xvw8GBxjn_jpqc44cl-gadzMTfTUdeqsngGwfW4kkKRf-fNMVWGaAALZ1qvt4WGG1qs5_od0SOkju8-qdPQuGgfk78Q3lLjuCe3i-OtgaxPyqNC02mDdFF5CH2NXA1QMSruH9ivzY1WYoUcGB8dDesJqmXhxmcojjNiYKUKCg5LbYxE-xUzha7eDeNscSB-Sidvp3sIb5xJjHI0Qt7YlSm6aCHUioo_SAwIvDWFmg"
#     }
# }

# print(lambda_handler(test_event, None))