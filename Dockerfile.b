# Escolher a imagem base
FROM ubuntu:latest

# Definir um ambiente de trabalho
WORKDIR /app

# Atualizar a lista de pacotes e instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    unzip

# Instalar o litellm
RUN pip3 install litellm pyautogen autogenstudio litellm[proxy]

# Instalar o Bun
RUN curl -fsSL https://bun.sh/install | bash

# Alternativamente, para usar Bun ao invés do npm
# RUN curl https://bun.sh/install | bash
# Adicionar o binário do Bun ao PATH
ENV PATH="/root/.bun/bin:${PATH}"

# Instalar o Ollama
RUN curl https://ollama.ai/install.sh | sh

# Clonar o repositório ollama-webui
RUN git clone https://github.com/ollama-webui/ollama-webui.git

# Navegar para o diretório clonado
WORKDIR /app/ollama-webui

# Copiar o arquivo .env
RUN cp -RPp example.env .env

# Instalar dependências do frontend e construir
RUN bun install
RUN bun run build

# Alternativamente, para usar Bun ao invés do npm
# RUN bun install
# RUN bun run build

# Navegar para o diretório backend e instalar dependências
WORKDIR /app/ollama-webui/backend
RUN pip3 install -r requirements.txt -U

RUN chmod +x /app/ollama-webui/backend/start.sh


# Copiar o script para a imagem e torná-lo executável
COPY start_all.sh /start_all.sh
RUN chmod +x /start_all.sh

# Expor a porta 8080 8081 8000
ENV OLLAMA_HOST 0.0.0.0
ENV OLLAMA_MODEL openhermes
EXPOSE 8080 8081 8000 11434

# Iniciar o serviço Ollama em segundo plano e executar o script de inicialização do backend
ENTRYPOINT ["/start_all.sh"]
