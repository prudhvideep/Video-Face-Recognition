# Video Face Recognition

In this project, I built an elastic application that can scale out and in on-demand to process and detect faces in a video. I achieved this using the PaaS offerings from AWS - specifically AWS Lambda and other supporting services from AWS.

**Demo ---->** https://main.d2g4ycz7ogc8gz.amplifyapp.com/

## Description

In this section, I'll describe the main components in this application.

### Frontend

The frontend is built using **React.js** and styled with **TailwindCss**. The application is secured with **Firebase Authentication**.
<p align="center">
  <img src="./public/images/Login.jpeg" alt="Dashboard" width="50%" height="auto" style="max-height: 300px; object-fit: contain;"/>
</p>

<p align="center">
  <img src="./public/images/Dashboard.jpeg" alt="Dashboard" width="50%" height="auto" style="max-height: 300px; object-fit: contain;"/>
</p>

### Backend

Our app is a video analysis application that uses four Lambda functions to implement a multi-stage pipeline to process videos sent by users.

- The pipeline starts with a user uploading a video to the input bucket.
- ***video-splitting function*** splits the video into frames and chunks them into the group-of-pictures (GoP) using FFmpeg. It stores this group of pictures in an intermediate stage-1 bucket.
- ***face-recognition function*** extracts the faces in the pictures using a Single Shot MultiBox Detector (SSD) algorithm and uses only the frames that have faces in them for face recognition. It uses a pre-trained CNN model (ResNet-34) for face recognition and outputs the name of the extracted face. The final output is stored in the output bucket.

The structure of the application is shown in the figure below. I used AWS Lambda for serverless computation and S3 for storing the data required for the functions.

<p align="center">
  <img src="./public/images/architecture-diagram.png" alt="architecture-diagram" width="auto" height="auto" style="max-height: 300px; object-fit: contain;"/>
</p>

## Setup

### Clone the repository

```
git clone git@github.com:prudhvideep/Video-Face-Recognition.git
```

### First, navigate to the repository

```
cd Video-Face-Recognition/
```

### Initialize the backend cloud infrastructure using terraform

**Prerequisites**

- Terraform CLI (1.2.0+)
- Aws CLI installed.
- AWS account and associated credentials.

Set the environment variables

```
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
```
```
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
```

Change the working directory 
```
cd infrastrcture/dev/
```

Initialize Terraform to set up the backend and download necessary plugins

```
terraform init
```

Apply the Terraform plan to create the infrastructure

```
terraform apply
```