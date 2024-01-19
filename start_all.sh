#!/bin/bash

# Iniciar o serviço Ollama em segundo plano
ollama serve & 

# Aguardar um pouco para garantir que o serviço esteja rodando
sleep 2

export OPENAI_API_KEY=$OPENAI_API_KEY

# Executar o comando ollama run mistral
ollama pull $OLLAMA_MODEL
autogenstudio ui --host 0.0.0.0 --port 8081 &

litellm --model ollama/$OLLAMA_MODEL &

cd /app/backend
sh start.sh