import json
import boto3
import uuid

#Configure the s3 client
s3 = boto3.client('s3')

def lambda_handler(event, context):
    try:
        body = event.get('body')
        if body:
            body = json.loads(body)
            bucket_name = body.get('bucketName')
            key = body.get('key')
            content_type = body.get('contentType')
            firebaseUid = body.get('uid')
            useremail = body.get('useremail')
        else:
            raise KeyError('body')
            
        metadata = {
            'firebaseUid' : firebaseUid,
            'useremail' : useremail
        }
            
        # Generate pre-signed URL
        presigned_url = s3.generate_presigned_url(
            ClientMethod='put_object',
            Params={
                'Bucket': bucket_name,
                'Key': key,
                'ContentType': content_type,
                'Metadata' : metadata,
            },
            ExpiresIn=3600,
            HttpMethod='PUT'
        )
        
        response = {
            'statusCode' : 200,
            'body': json.dumps({
                'presignedUrl': presigned_url,
                'key': key
            })
        }
        
        return response
        
    except KeyError as e:
        response = {
            'statusCode' : 400,
            'body' : json.dumps({
                'errorMessage' : f"Error generating pre-signed URL: {e}"
            })
        }
        
    except Exception as e:
        print(f"Error generating pre-signed URL: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': f"Error generating pre-signed URL: {e}"
            })
        }

