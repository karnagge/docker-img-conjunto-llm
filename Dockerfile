# Escolher a imagem base
FROM karnagge/ollamawebui:latest

# Definir um ambiente de trabalho
WORKDIR /app

# Atualizar a lista de pacotes e instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    unzip && apt-get autoclean


# Instalar o litellm
RUN pip3 install litellm pyautogen autogenstudio litellm[proxy]

RUN chmod +x /app/backend/start.sh

# Instalar o Ollama
RUN curl https://ollama.ai/install.sh | sh

# Copiar o script para a imagem e torná-lo executável
COPY start_all.sh /start_all.sh

RUN chmod +x /start_all.sh

# Expor a porta 8080 8081 8000
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODEL=openhermes
ENV OLLAMA_API_BASE_URL=http://127.0.0.1:11434/api
ENV OPENAI_API_KEY=Teste
EXPOSE 8080 8081 8000 11434

# Iniciar o serviço Ollama em segundo plano e executar o script de inicialização do backend
ENTRYPOINT ["/start_all.sh"]
