FROM docker.io/rocm/dev-ubuntu-24.04:7.2.3-complete

# Hardware spoofing remains mandatory for unlisted RDNA 2
ENV HSA_OVERRIDE_GFX_VERSION=10.3.0
ENV HIP_VISIBLE_DEVICES=0
ENV ROCR_VISIBLE_DEVICES=0

RUN apt-get update && apt-get install -y \
    git build-essential cmake curl libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Clone the specific branch implementing TurboQuant
RUN git clone -b feature/turboquant-kv-cache https://github.com/TheTom/llama-cpp-turboquant.git .

# Compile with HIP acceleration targeted for RDNA 2
RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
    cmake -B build \
    -DGGML_HIP=ON \
    -DAMDGPU_TARGETS=gfx1030 \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLAMA_CURL=ON

RUN cmake --build build --config Release -j$(nproc)

EXPOSE 8080

ENTRYPOINT ["/workspace/build/bin/llama-server"]
