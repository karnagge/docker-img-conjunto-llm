#!/bin/bash

# Iniciar o serviço Ollama em segundo plano
ollama serve & 

cd /app/ollama-webui/backend
sh start.sh &

# Aguardar um pouco para garantir que o serviço esteja rodando
sleep 2

export OPENAI_API_KEY=Teste

# Executar o comando ollama run mistral
ollama pull openhermes
autogenstudio ui --host 0.0.0.0 --port 8081 &

litellm --model ollama/openhermes
# Manter o container rodando
tail -f /dev/null
