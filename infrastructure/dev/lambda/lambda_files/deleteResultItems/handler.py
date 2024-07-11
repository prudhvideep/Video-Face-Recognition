import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    try:
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            raise ValueError("Missing 'body' in event")
        
        print("Body ----> ",body)
    
        bucketname = body['bucketname']
        key = body['key']
    
        result = s3.delete_object(Bucket = bucketname, Key = key);
    
        print("Result ---->",result)
        
        return {
            'statusCode': 200,
            'body': json.dumps('Record Sucessfuly Deleted!!!')
        }
    except Exception as error:
        errorMsg = 'Error while deleting the record!!!' + type(error).__name__ + '-'  + error
        return {
            'statusCode': 400,
            'body': json.dumps(errorMsg)
        }
    
    
