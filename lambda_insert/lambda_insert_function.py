import json
import os
import boto3
from datetime import datetime

EXPECTED_API_KEY = os.environ.get("EXPECTED_API_KEY")

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('reminders')

def lambda_handler(event, context):
    headers = event.get("headers") or {}
    provided_key = headers.get("x-api-key")
    if provided_key != EXPECTED_API_KEY:
        return {
            "statusCode": 403,
            "body": json.dumps("Forbidden: Invalid API Key")
        }
    item = {
        'Record_Number': 1,
        'Name': 'Warren',
        'Email': 'test@example.com',
        'Date': datetime.now().strftime('%d/%m/%Y')
    }

    table.put_item(Item=item)

    return {
        'statusCode': 200,
        'body': json.dumps('Record inserted successfully!')
    }
