import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('reminders')

def lambda_handler(event, context):
    today = datetime.now().strftime('%d/%m/%Y')

    response = table.scan()
    items = response.get('Items', [])

    todays_items = [item for item in items if item.get('Date') == today]

    print(f"Found {len(todays_items)} reminders for today:")
    for item in todays_items:
        print(item)

    return {
        "statusCode": 200,
        "body": f"Found {len(todays_items)} reminders for {today}."
    }
