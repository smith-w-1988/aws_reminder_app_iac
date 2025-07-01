import json
import os
import boto3
import re
from datetime import datetime

EXPECTED_API_KEY = os.environ.get("EXPECTED_API_KEY")

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('reminders')

EMAIL_REGEX = re.compile(r"[^@]+@[^@]+\.[^@]+")

def validate_input(data):
    errors = []
    
    name = data.get('name')
    email = data.get('email')
    date = data.get('date')

    if not isinstance(name, str) or not name.strip():
        errors.append("Invalid or missing 'name'.")

    if not isinstance(email, str) or not EMAIL_REGEX.match(email):
        errors.append("Invalid or missing 'email'.")

    try:
        datetime.strptime(date, "%d/%m/%Y")
    except (ValueError, TypeError):
        errors.append("Invalid or missing 'date'. Format should be DD/MM/YYYY.")

    return errors

def lambda_handler(event, context):
    headers = event.get("headers") or {}
    provided_key = headers.get("x-api-key")

    if provided_key != EXPECTED_API_KEY:
        return {
            "statusCode": 403,
            "body": json.dumps("Forbidden: Invalid API Key")
        }

    try:
        body = json.loads(event.get("body") or "{}")
    except json.JSONDecodeError:
        return {
            "statusCode": 400,
            "body": json.dumps("Invalid JSON in request body.")
        }

    errors = validate_input(body)
    if errors:
        return {
            "statusCode": 400,
            "body": json.dumps({"errors": errors})
        }

    response = table.update_item(
        Key={'PK': 'COUNTER'},
        UpdateExpression='ADD Record_Number :inc',
        ExpressionAttributeValues={':inc': 1},
        ReturnValues='UPDATED_NEW'
    )

    record_number = int(response['Attributes']['Record_Number'])

    item = {
        'PK': f'RECORD#{record_number}',
        'Record_Number': record_number,
        'Name': body['name'],
        'Email': body['email'],
        'Date': body['date']
    }

    table.put_item(Item=item)

    return {
        'statusCode': 200,
        'body': json.dumps(f"Record #{record_number} inserted successfully!")
    }
