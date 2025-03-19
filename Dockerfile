FROM nvcr.io/nvidia/pytorch:25.02-py3

ENV TORCH_CUDA_ARCH_LIST="8.0;8.6"


# Install Python 3.11 and dependencies
# RUN apt-get update && apt-get install -y \
#     software-properties-common && \
#     add-apt-repository ppa:deadsnakes/ppa -y && \
#     apt-get update && \
#     apt-get install -y python3.11 python3.11-venv python3.11-dev && \
#     apt-get clean

# # Set Python 3.11 as default
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
#     update-alternatives --config python3

# # Upgrade pip and reinstall dependencies
# RUN python3 -m ensurepip && python3 -m pip install --upgrade pip

RUN apt-get update --fix-missing && \
    apt-get install -y wget git&& \
    apt-get clean
RUN apt-get install -y libaio-dev


RUN pip install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt && rm requirements.txt
RUN pip uninstall -y transformer-engine

RUN git clone https://github.com/allenai/olmocr.git
RUN cd olmocr && pip install -e .[gpu] --find-links https://flashinfer.ai/whl/cu124/torch2.4/flashinfer/