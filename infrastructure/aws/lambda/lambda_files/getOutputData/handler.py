import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):

        # Ensure the event body is correctly parsed
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            raise ValueError("Missing 'body' in event")
        
        
        #Extracting the bucket name and key from the payload
        bucket_name = body['bucketname']
        print('bucket name',bucket_name)
        
        firebaseuid = body['firebaseuid']
        print('firebaseuid',firebaseuid)
        
        #Query the s3 bucket for the objects
        response = s3.list_objects_v2(Bucket=bucket_name, Prefix=firebaseuid)
        
        print("response ----> ",response)
        
        file_urls = []
        
        if 'Contents' not in response:
            return {
                'statusCode': 200,
                'body': json.dumps(file_urls.append({}))
            }
        
        for content in response['Contents']:
            key = content['Key']
            modified_date = content['LastModified'].isoformat()
            file_url = f'https://{bucket_name}.s3.amazonaws.com/{key}'
            
            metadata = s3.head_object(Bucket=bucket_name, Key=key)
            faceresult = ''
            
            if metadata['Metadata']:
                faceresult = metadata['Metadata']['faceresult']
            
            file_urls.append({
                'file_url' : file_url,
                'key' : key,
                'modified_date' : modified_date,
                'faceresult' : faceresult
            });
            
            file_urls = sorted(file_urls,key = lambda x : x['modified_date'],reverse=True)
        
        # TODO implement
        return {
            'statusCode': 200,
            'body': json.dumps(file_urls)
        }