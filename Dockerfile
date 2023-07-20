FROM ubuntu:22.04

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install --upgrade pip
# RUN pip3 install numpy
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python3", "-m", "uvicorn", "api.api:app", "--host", "0.0.0.0", "--port", "8000"]
