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
    
    GET  → Return current count without incrementing
    POST → Increment counter and return new count
    
    Parameters:
    - event: Contains info about the HTTP request (headers, body, etc.)
    - context: Contains info about the Lambda execution environment
    """
    
    # Get the HTTP method from the request
    # Default to POST for backwards compatibility
    http_method = event.get('httpMethod', 'POST')
    
    if http_method == 'GET':
        # GET request: Just retrieve the current count, no increment
        # Used when visitor was already counted (checked via localStorage)
        response = table.get_item(
            Key={'id': 'visitor_count'}
        )
        # Handle case where item doesn't exist yet
        # response.get('Item', {}) returns empty dict if no Item key
        # .get('view_count', 0) returns 0 if no view_count key
        count = int(response.get('Item', {}).get('view_count', 0))
    
    else:
        # POST request (or any other method): Increment the counter
        # Used for new visitors or returning visitors after 7 days
        
        # update_item performs an atomic update on a DynamoDB item
        # "Atomic" means it's safe even if multiple people visit simultaneously
        response = table.update_item(
            # Key identifies WHICH item to update
            Key={'id': 'visitor_count'},
            
            # UpdateExpression defines WHAT to change
            # if_not_exists handles the case where the counter doesn't exist yet
            UpdateExpression='SET view_count = if_not_exists(view_count, :start) + :increment',
            
            # ExpressionAttributeValues provides the actual values for placeholders
            ExpressionAttributeValues={
                ':start': 0,
                ':increment': 1
            },
            
            # ReturnValues='UPDATED_NEW' tells DynamoDB to send back the NEW value
            ReturnValues='UPDATED_NEW'
        )
        count = int(response['Attributes']['view_count'])
    
    # Return an HTTP response that API Gateway will send to the browser
    return {
        'statusCode': 200,
        
        # CORS headers - CRITICAL for browser security
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Content-Type': 'application/json'
        },
        
        # The actual response body - our visitor count as JSON
        'body': json.dumps({'count': count})
    }
