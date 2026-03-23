# Use slim Python 3.11 base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies needed by sentence-transformers / torch
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (Docker layer caching — faster rebuilds)
COPY requirements.txt .

# Remove the local package install line before pip install
RUN grep -v '^\.$' requirements.txt > requirements_clean.txt \
    && pip install --no-cache-dir -r requirements_clean.txt

# Copy the rest of the project
COPY . .

# Install local package (setup.py)
RUN pip install --no-cache-dir -e .

# HuggingFace Spaces must expose port 8080
EXPOSE 8080
        
# Run with 1 worker (RAM constrained) on port 8080
CMD ["gunicorn", "app:app", "--workers", "1", "--threads", "2", "--timeout", "180", "--bind", "0.0.0.0:8080"]
