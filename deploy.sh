#!/usr/bin/env bash

set -e

echo "=== AE4 - Despliegue de la aplicación ==="

echo "[1/3] Construyendo las imágenes..."
docker compose build

echo "[2/3] Levantando los servicios..."
docker compose up -d

echo "[3/3] Esperando a que la aplicación esté disponible..."

intentos=0
max_intentos=30

until curl -sf http://localhost:8000/healthz > /dev/null; do
    intentos=$((intentos + 1))

    if [ "$intentos" -ge "$max_intentos" ]; then
        echo "ERROR: la aplicación no respondió correctamente en /healthz"
        docker compose ps
        exit 1
    fi

    sleep 2
done

echo "Aplicación desplegada correctamente."
echo "Web:     http://localhost:8000"
echo "pgAdmin: http://localhost:5050"
echo "Health:  http://localhost:8000/healthz"
