import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('reminders')

def lambda_handler(event, context):
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
