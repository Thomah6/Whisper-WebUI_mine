FROM python:3.10-slim

# Instala dependências de sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    git \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia os arquivos do projeto
COPY . .

# 1. Instala setuptools versão estável com suporte a pkg_resources
# 2. Instala PyTorch CPU
# 3. Instala o pacote do git sem isolamento de build
# 4. Instala os demais requisitos
RUN pip install --no-cache-dir --upgrade pip "setuptools<80.0.0" wheel && \
    pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir --no-build-isolation git+https://github.com/jhj0517/jhj0517-whisper.git && \
    pip install --no-cache-dir --no-build-isolation -r requirements.txt

ENV PORT=7860
EXPOSE 7860

CMD ["sh", "-c", "python app.py --server_name 0.0.0.0 --server_port ${PORT:-7860}"]
