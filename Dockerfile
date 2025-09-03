# Use official Python slim image
FROM python:3.10-slim

# Environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    g++ \
    python3-dev \
    libxml2-dev \
    libxslt-dev \
    libldap2-dev \
    libsasl2-dev \
    libffi-dev \
    libjpeg-dev \
    libpq-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    curl \
    wget \
    node-less \
    npm \
    libssl-dev \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create Odoo user
RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo

# Set working directory
WORKDIR /opt/odoo

# Clean and clone latest default branch (no --branch needed)
RUN rm -rf ./* && git clone --depth 1 https://github.com/odoo/odoo.git .

# Install Python dependencies
RUN python3 -m pip install --upgrade pip setuptools wheel \
    && pip3 install -r requirements.txt

# Expose Odoo's default port
EXPOSE 8069

# Set permissions
USER odoo

# Start Odoo (expects DB env vars to be passed)
CMD ["python3", "odoo-bin", "--dev=reload"]
