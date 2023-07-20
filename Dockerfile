FROM ubuntu:22.04 as base

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y python3 python3-pip curl git wget unzip

RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN pip3 install torch torchvision wget

RUN curl -L $(yadisk-direct https://disk.yandex.ru/d/ouP6l8VJ0HpMZg) -o big-lama.zip
RUN unzip -o big-lama.zip
RUN rm -rf big-lama.zip

ENTRYPOINT ["python3", "-m", "uvicorn", "api.api:app", "--host", "0.0.0.0", "--port", "8000"]
