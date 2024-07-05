# Video Face Recognition
In this project, I built an elastic application that can scale out and in on-demand to process and detect faces in a video. I achieved this using the PaaS offerings from AWS - specifically AWS Lambda and other supporting services from AWS.

**Try it -->** https://main.d2g4ycz7ogc8gz.amplifyapp.com/

## Description
In this section, I'll describe the main components in this application. 
### Frontend
The frontend is built using **React.js** and styled with **TailwindCss**.  The application is secured with **Firebase Authentication**.


### Backend
 Our app will be a video analysis application that uses four Lambda functions to implement a multi-stage pipeline to process videos sent by users.

 -  The pipeline starts with a user uploading a video to the input bucket.
 -  **video-splitting function** splits the video into frames and chunks them into the group-of-pictures (GoP) using FFmpeg. It stores this group of pictures in an intermediate stage-1 bucket.
 - **face-recognition function** extracts the faces in the pictures using a Single Shot MultiBox Detector (SSD) algorithm and uses only the frames that have faces in them for face recognition. It uses a pre-trained CNN model (ResNet-34) for face recognition and outputs the name of the extracted face. The final output is stored in the output bucket.
 
The structure of the application is shown in the figure below. I used AWS Lambda for serverless computation and S3 for storing the data required for the functions.

![Architecture Diagram](images/architecture-diagram.png)


