# visitor_counter.py
# Lambda function to track and return visitor count

import json      # For converting Python dictionaries to JSON strings
import boto3     # AWS SDK for Python - lets us talk to AWS services
import os        # For accessing environment variables

# Create a DynamoDB resource object
# This establishes the connection to DynamoDB service
dynamodb = boto3.resource('dynamodb')

# Connect to our specific table
# The table name is passed in as an environment variable (set in Terraform)
table = dynamodb.Table(os.environ['TABLE_NAME'])


def lambda_handler(event, context):
    """
    This function runs every time someone hits our API endpoint.
    
    Parameters:
    - event: Contains info about the HTTP request (headers, body, etc.)
    - context: Contains info about the Lambda execution environment
    """
    
    # update_item performs an atomic update on a DynamoDB item
    # "Atomic" means it's safe even if multiple people visit simultaneously
    response = table.update_item(
        # Key identifies WHICH item to update
        # 'id' is our partition key, 'visitor_count' is the item we're tracking
        Key={
            'id': 'visitor_count'
        },
        
        # UpdateExpression defines WHAT to change
        # SET view_count = view_count + :increment
        # The :increment is a placeholder for the value below
        # if_not_exists handles the case where the counter doesn't exist yet
        UpdateExpression='SET view_count = if_not_exists(view_count, :start) + :increment',
        
        # ExpressionAttributeValues provides the actual values for placeholders
        # :start = 0 (starting value if counter doesn't exist yet)
        # :increment = 1 (add 1 each visit)
        ExpressionAttributeValues={
            ':start': 0,
            ':increment': 1
        },
        
        # ReturnValues='UPDATED_NEW' tells DynamoDB to send back the NEW value
        # after the update (so we can return it to the frontend)
        ReturnValues='UPDATED_NEW'
    )
    
    # Extract the actual count number from DynamoDB's response
    # response['Attributes'] contains {'view_count': Decimal('42')}
    # int() converts the Decimal to a regular integer
    count = int(response['Attributes']['view_count'])
    
    # Return an HTTP response that API Gateway will send to the browser
    return {
        # 200 = HTTP "OK" status code
        'statusCode': 200,
        
        # CORS headers - CRITICAL for browser security
        # Without these, browsers block the response
        'headers': {
            # Allows your specific domain to receive the response
            'Access-Control-Allow-Origin': '*',
            
            # Allows these HTTP methods
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            
            # Allows these headers in requests
            'Access-Control-Allow-Headers': 'Content-Type',
            
            # Tells browser this is JSON data
            'Content-Type': 'application/json'
        },
        
        # The actual response body - our visitor count as JSON
        # json.dumps converts Python dict {'count': 42} to string '{"count": 42}'
        'body': json.dumps({'count': count})
    }
