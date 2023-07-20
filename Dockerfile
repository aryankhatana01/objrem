FROM ubuntu:22.04 as base

# Copying everything to the app directory
WORKDIR /app
COPY . /app

# Installing ubuntu dependencies
RUN apt-get update && apt-get install -y python3 python3-pip curl git wget unzip

# Installing python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN pip3 install torch torchvision wget
RUN pip3 install git+https://github.com/facebookresearch/segment-anything.git
RUN pip3 install opencv-python pycocotools matplotlib onnxruntime onnx

# Changing working directory to lama and downloading model weights
WORKDIR /app/lama/
RUN curl -L $(yadisk-direct https://disk.yandex.ru/d/ouP6l8VJ0HpMZg) -o big-lama.zip
RUN unzip -o big-lama.zip
RUN rm -rf big-lama.zip

# Changing working directory to sam and downloading sam model weights
WORKDIR /app/sam/
RUN wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth

# Changing working directory to app
WORKDIR /app

# Starting the fastapi server on port 8000
ENTRYPOINT ["python3", "-m", "uvicorn", "api.api:app", "--host", "0.0.0.0", "--port", "8000"]