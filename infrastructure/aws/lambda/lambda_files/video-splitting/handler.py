import boto3
import os
import subprocess
import math
import json

#Set up the s3 client
s3_client = boto3.client(
    's3',
    region_name='us-east-1'
)

def invoke_lambda_async(target_function_name,payload):
    print("Calling the face recognition function")
    lambda_client = boto3.client('lambda')
    
    response = lambda_client.invoke(
        FunctionName=target_function_name,
        InvocationType='Event',  # Invoke asynchronously
        Payload=json.dumps(payload)
    )

def video_splitting_cmdline(video_filename,output_file_name):
    print('Inside video splitting')
    print('video filename : ', video_filename)
    
    split_cmd = '/opt/ffmpeglib/ffmpeg -i ' +video_filename+ ' -vframes 1 ' + '/tmp/' + f'{output_file_name}'
    try:
        print('calling subprocess')
        subprocess.check_call(split_cmd, shell=True)
    except subprocess.CalledProcessError as e:
        print(e.returncode)
        print(e.output)

def handler(event, context):	
  for record in event['Records']:
      bucket_name = record['s3']['bucket']['name']
      print('bucket name : ',bucket_name)
      
      object_key = record['s3']['object']['key']
      print('object key : ', object_key)
      
      input_video_filename = f'/tmp/{object_key}'
      print('input video filename : ', input_video_filename)
      
      output_file_name = os.path.splitext(os.path.basename(object_key))[0] + ".jpg"
      print('output file name : ', output_file_name)

      # Download the input video file from S3
      s3_client.download_file(bucket_name, object_key, input_video_filename)
      
      # Get file meta data from the S3 file
      metadata = s3_client.head_object(Bucket=bucket_name, Key=object_key)
      
      if metadata['Metadata'] :
          firebaseuid = metadata['Metadata']['firebaseuid']
          useremail = metadata['Metadata']['useremail']


      # Split the video into frames
      video_splitting_cmdline(input_video_filename,output_file_name)

      # Upload frames to the output folder in "<ASU ID>-stage-1" bucket
      print("Upload frames to the output bucket")
      s3_client.upload_file(os.path.join('/tmp', output_file_name), f'1229539066-stage-1', output_file_name)

      # Clean up temporary files
      os.remove(input_video_filename)
      os.remove(os.path.join('/tmp', output_file_name))
      
      target_function_name = 'face-recognition'
      payload = {
        'bucket_name': '1229539066-stage-1',
        'image_file_name': f'{output_file_name}',
        'firebaseuid': f'{firebaseuid}',
        'useremail': f'{useremail}'
      }
      invoke_lambda_async(target_function_name, payload)