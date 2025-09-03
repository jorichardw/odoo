FROM python:3.10-slim

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

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
    node-less \
    wget \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo

USER odoo
WORKDIR /opt/odoo

RUN git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo.git .

RUN python3 -m pip install --upgrade pip setuptools wheel
RUN pip3 install -r requirements.txt

EXPOSE 8069

CMD ["python3", "-m", "odoo", "--dev=reload"]
