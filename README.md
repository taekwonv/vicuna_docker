<p align="center">
<a href="https://vicuna.lmsys.org"><img src="https://github.com/lm-sys/FastChat/blob/main/assets/vicuna_logo.jpeg" width="20%"></a>
</p>
The original source of vicuna is here: https://github.com/lm-sys/FastChat
The Dockerfile introduced here is based on a Vicuna fork https://github.com/thisserand/FastChat.git whose writer is Martin Thissen.
Here are the instructions to run the Vicuna-13B model with GPTQ-quantized mode in a docker container.
You should now be able to run the Vicuna-13B model with GPTQ-quantized model on a single consumer GPU. Thanks to Martin Thissen for <a href="https://medium.com/@martin-thissen/vicuna-13b-best-free-chatgpt-alternative-according-to-gpt-4-tutorial-gpu-ec6eb513a717">his posting</a> on using GPTQ-quantized model with Vicuna.

# Requirement
- You need a host machine which has at least one GPU (>=10G VRAM)
- Docker installed
- roughly 10GB free space

# vicuna_docker
A dockerfile for vicuna

# How to run
Run the following command
```
git clone https://github.com/taekwonv/vicuna_docker.git
cd vicuna_docker
```
Open the `Dockerfile` with a text editor of your choice.
Look for the line of code that contains the variable TORCH_CUDA_ARCH_LIST.
Replace 7.5 with your architecture version(s). You can find your architecture version in the section 'CUDA-Enabled NVIDIA Quadro and NVIDIA RTX' of the following link: https://developer.nvidia.com/cuda-gpus
Save the file.
Run the following command to build the Docker image:
```
docker build -t vicuna_docker .
```
Wait for the build process to finish. This may take some time, depending on your internet connection speed and the size of the Docker image.
Once the build is done, run the following command to launch the service:
```
docker run --gpus all -p 7860:7860 vicuna_docker
```
Open your web browser and navigate http://localhost:7860

#
