docker run -it -p 8080:8080 \
  --device=/dev/kfd \
  --device=/dev/dri/renderD129 \
  --group-add=video \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  -v ./models:/models \
  llama-rocm-rdna2 \
  -m /models/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf \
  --n-cpu-moe 35 \
  --no-mmap \
  --mlock \
  --alias "hermes-local" \
  --chat-template chatml \
  -c 128000 \
  --cache-type-k turbo4 \
  --cache-type-v turbo3 \
  --host 0.0.0.0 \
  --port 8080
