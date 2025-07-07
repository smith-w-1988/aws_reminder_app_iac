import boto3
import os
from datetime import datetime
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('reminders')

region = os.environ.get("AWS_REGION")
sender_mail = os.environ.get("sender_mail")

ses = boto3.client('ses', region_name=region)

def send_email(to_address, subject, Name):
    try:
        response = ses.send_email(
            Source=sender_mail,
            Destination={
                'ToAddresses': [to_address]
            },
            Message={
                'Subject': {
                    'Data': f"{subject} reminder email from AWS email app"
                },
                'Body': {
                    'Text': {
                        'Data': f"Hello {Name},\n\nThis is your reminder: {subject}\n\nThanks,\nReminder App"  
                    }
                }
            }
        )
        print(f"Email sent to {to_address}. Message ID: {response['MessageId']}")
        print("SES response:")
        print(json.dumps(response, indent=2))
    except Exception as e:
        print(f"Error sending email to {to_address}: {str(e)}")

def lambda_handler(event, context):
    today = datetime.now().strftime('%d/%m/%Y')

    response = table.scan()
    items = response.get('Items', [])

    todays_items = [item for item in items if item.get('Date') == today]

    for item in todays_items:
        Name = item.get("Name")
        email = item.get('Email')
        subject = item.get('Subject', 'No Subject')
        if email:
            send_email(email, subject, Name)
        else:
            print(f"No email address for record {item.get('PK')}")

    return {
        "statusCode": 200,
        "body": f"Processed {len(todays_items)} reminders for {today}."
    }
