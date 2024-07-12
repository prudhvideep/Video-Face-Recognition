
# Define global args
ARG RUNTIME_VERSION="3.10-slim"  # Use the slim version

FROM python:${RUNTIME_VERSION} AS base

# Update pip
RUN python -m pip install --upgrade pip

# Set the working directory
WORKDIR /home/app

# Install Lambda Runtime Interface Client for Python
RUN pip install awslambdaric

# Install PyTorch, Torchvision without CUDA
RUN pip install torch==2.2.0+cpu torchvision==0.17.0+cpu --no-cache-dir \
    --find-links https://download.pytorch.org/whl/torch_stable.html \
    facenet-pytorch

# Optional: Install other required Python packages, ensure requirements.txt is trimmed down as needed
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy your Lambda function code
COPY handler.py .

# (Optional) Add Lambda Runtime Interface Emulator and use a script in the ENTRYPOINT for simpler local runs
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie
COPY entry.sh /
RUN chmod 777 /entry.sh

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
ENTRYPOINT [ "/entry.sh" ]
CMD [ "handler.handler" ]

