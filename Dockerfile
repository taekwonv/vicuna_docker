FROM nvidia/cuda:11.7.0-devel-ubuntu20.04

# Install git and other required packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \    
    apt-get install -y software-properties-common git curl wget && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.9 python3.9-dev python3-pip

# Set the default version of Python to use
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py --force-reinstall

# Set root directory
RUN mkdir /app
WORKDIR /app

# Install vicuna
RUN git clone https://github.com/thisserand/FastChat.git
WORKDIR /app/FastChat
RUN pip3 install -e .
RUN mkdir repositories
WORKDIR /app/FastChat/repositories
RUN git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git -b cuda
WORKDIR /app/FastChat/repositories/GPTQ-for-LLaMa
ARG TORCH_CUDA_ARCH_LIST="7.5"
RUN python3 setup_cuda.py install

# Download vicuna 13b model
WORKDIR /app/FastChat
RUN python3 download-model.py anon8231489123/vicuna-13b-GPTQ-4bit-128g

# Write a launch shell script
RUN echo "#!/bin/bash \
    \nnohup python3 -m fastchat.serve.controller --host \"127.0.0.1\" > /dev/null 2>&1 & \
    \nnohup python3 -m fastchat.serve.model_worker --model-path anon8231489123/vicuna-13b-GPTQ-4bit-128g --model-name vicuna-gptq --wbits 4 --groupsize 128 --host \"127.0.0.1\" --worker-address \"http://127.0.0.1:21002\" --controller-address \"http://127.0.0.1:21001\" > /dev/null 2>&1 & \
	\nsleep 10 \
    \npython3 -m fastchat.serve.gradio_web_server --controller-url \"http://127.0.0.1:21001\" --share" > run.sh
RUN chmod +x run.sh

# Launch app
CMD ["./run.sh"]
