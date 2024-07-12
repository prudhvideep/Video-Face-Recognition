import warnings

# Suppress specific UserWarning from torch.nn.functional
warnings.filterwarnings("ignore", message=".*Named tensors.*")

import boto3
import os
import subprocess
import math
import cv2
import json
from PIL import Image, ImageDraw, ImageFont
from facenet_pytorch import MTCNN, InceptionResnetV1
from shutil import rmtree
import numpy as np
import torch
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

os.environ["TORCH_HOME"] = "/tmp/torch"

mtcnn = MTCNN(image_size=240, margin=0, min_face_size=20) # initializing mtcnn for face detection
resnet = InceptionResnetV1(pretrained='vggface2').eval() # initializing resnet for face img to embeding 

#Set up the S3 client
s3_client = boto3.client(
    's3',
    region_name='us-east-1'
)

# Define the face recognition function
def face_recognition_function(key_path):
    # Face extraction
    img = cv2.imread(key_path, cv2.IMREAD_COLOR)
    boxes, _ = mtcnn.detect(img)

    # Face recognition
    key = os.path.splitext(os.path.basename(key_path))[0].split(".")[0]
    img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    face, prob = mtcnn(img, return_prob=True, save_path=None)
    
    s3_client.download_file('pmutyal-layer-bucket', 'data.pt', '/tmp/data.pt')
    
    saved_data = torch.load('/tmp/data.pt')  # loading data.pt file
    if face is not None:
        emb = resnet(face.unsqueeze(0)).detach()  # detech is to make required gradient false
        embedding_list = saved_data[0]  # getting embedding data
        name_list = saved_data[1]  # getting list of names
        dist_list = []  # list of matched distances, minimum distance is used to identify the person
        for idx, emb_db in enumerate(embedding_list):
            dist = torch.dist(emb, emb_db).item()
            dist_list.append(dist)
        idx_min = dist_list.index(min(dist_list))
        
        return name_list[idx_min]
    else:
        return "No face is detected"
    
def send_email(useremail):
    # Email server configuration
    smtp_server = 'smtp.gmail.com'
    smtp_port = 587
    smtp_username = 'neilyoung.discography@gmail.com'
    smtp_password = 'zidhwfimphonhxuv'
    sender_email = 'neilyoung.discography@gmail.com'
    receiver_email = useremail
    
    #email subject
    subject = 'Face Recognition Task Complete!!!'
    
    #email body
    body = """Dear User,

    The face recognition task you requested has been completed successfully.

    Best regards,
    Prudhvi.
    """

    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))
    print("Message --->",msg)
    
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(smtp_username, smtp_password)
        server.sendmail(sender_email, receiver_email, msg.as_string())

# Define the AWS Lambda handler function
def handler(event, context):    
    bucket_name = event['bucket_name']
    print('bucket_name', bucket_name)
  
    image_name = event['image_file_name']
    print('image', image_name)
    
    firebaseuid = event['firebaseuid']
    print('firebaseuid',firebaseuid)
    
    useremail = event['useremail']
    print('useremail',useremail)
  
    input_image_filename = os.path.join('/tmp/', image_name)
    
    # Download the input image file from S3
    s3_client.download_file(bucket_name, image_name, input_image_filename)
      
    # Call the face recognition function
    response = face_recognition_function(input_image_filename)
    print('Response from face recognition function', response)
    
    #call the email function here
    send_email(useremail)
        
    output_bucket = f'1229539066-output'
    
    s3_client.upload_file(
    input_image_filename, output_bucket, firebaseuid + '/' + image_name,
    ExtraArgs={'Metadata': {'faceResult': f'{response}'}}
    )
    
    # Clean up temporary files
    os.remove(input_image_filename)