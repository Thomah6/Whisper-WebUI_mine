FROM python:3.10-slim

# Instala dependencias essenciais do sistema (ffmpeg para audio/video e git)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    git \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia todos os arquivos do repositorio
COPY . .

# 1. Atualiza ferramentas de build
# 2. Instala PyTorch otimizado para CPU (economiza ~4GB de download)
# 3. Instala os pacotes do requirements.txt
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir -r requirements.txt

# Variaveis para escutar na porta correta
ENV PORT=7860
EXPOSE 7860

# Inicia o servidor Gradio apontando para 0.0.0.0
CMD ["sh", "-c", "python app.py --server_name 0.0.0.0 --server_port ${PORT:-7860}"]
