# Usar uma imagem base mais leve
FROM python:3.10.13-slim-bullseye

# Definir um ambiente de trabalho
WORKDIR /app

# Instalar dependências necessárias em uma única camada para redu'zir o tamanho
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
 && curl -fsSL https://bun.sh/install | bash \
 && curl https://ollama.ai/install.sh | sh \
 && rm -rf /var/lib/apt/lists/*

# Adicionar o binário do Bun ao PATH
ENV PATH="/root/.bun/bin:${PATH}"

# Instalar o litellm e dependências do Python
RUN pip3 install --no-cache-dir litellm pyautogen autogenstudio litellm[proxy]

# Clonar o repositório ollama-webui e instalar dependências do frontend
RUN git clone https://github.com/ollama-webui/ollama-webui.git \
 && cd ollama-webui \
 && cp -RPp example.env .env \
 && bun install \
 && bun run build

# Instalar dependências do backend
WORKDIR /app/ollama-webui/backend
RUN pip3 install --no-cache-dir -r requirements.txt -U

# Copiar o script de inicialização e torná-lo executável
COPY start_all.sh /start_all.sh
RUN chmod +x /start_all.sh

# Expor as portas
EXPOSE 8080 8081 8000

# Iniciar o serviço Ollama em segundo plano e executar o script de inicialização do backend
ENTRYPOINT ["/start_all.sh"]
