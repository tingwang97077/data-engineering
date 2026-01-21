# syntax=docker/dockerfile:1.7

FROM python:3.13-slim AS base

WORKDIR /code
ENV PATH="/code/.venv/bin:$PATH" 

# ---- Installer uv (deux options)
# Option 1 (propre) : depuis GHCR (attention: ghcr.io, pas ghrc.io)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# ---- Dépendances système minimales (souvent nécessaires pour pyarrow / wheels)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---- Copier uniquement les fichiers de résolution pour maximiser le cache
COPY pyproject.toml uv.lock .python-version ./

# ---- Copier le code après (cache stable)
COPY ingest_data.py ./

ENTRYPOINT ["uv", "run", "python", "ingest_data.py"]
