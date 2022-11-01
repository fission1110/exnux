#!/bin/bash
apt-get update -y \
    && apt-get install -y \
      `# john` \
        build-essential \
        libssl-dev \
        git \
        zlib1g-dev \
        yasm \
        libgmp-dev \
        libpcap-dev \
        pkg-config \
        libbz2-dev \
        nvidia-opencl-dev \
        ocl-icd-opencl-dev \
        opencl-headers \
        ocl-icd-opencl-dev \
        opencl-headers \
        pocl-opencl-icd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
