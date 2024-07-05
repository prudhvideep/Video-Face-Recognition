# Video Face Recognition
In this project, I built an elastic application that can scale out and in on-demand to process and detect faces in a video. I achieved this using the PaaS offerings from AWS - specifically AWS Lambda and other supporting services from AWS.

**Try it -->** https://main.d2g4ycz7ogc8gz.amplifyapp.com/

## Description
 Our app will be a video analysis application that uses four Lambda functions to implement a multi-stage pipeline to process videos sent by users.

 -  The pipeline starts with a user uploading a video to the input bucket.
 -  Stage 1: The video-splitting function splits the video into frames and chunks them into the group-of-pictures (GoP) using FFmpeg. It stores this group of pictures in an intermediate stage-1 bucket.
 - Stage 2: The face-recognition function extracts the faces in the pictures using a Single Shot MultiBox Detector (SSD) algorithm and uses only the frames that have faces in them for face recognition. It uses a pre-trained CNN model (ResNet-34) for face recognition and outputs the name of the extracted face. The final output is stored in the output bucket.
