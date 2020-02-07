FROM python:3.7-slim
WORKDIR /workspace
RUN apt-get -y update && \
    apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*
RUN cd / && \
    git clone https://github.com/vwt-digital/sec-helpers.git && \
    cd /sec-helpers && \
    pip install --no-cache-dir -r requirements.txt 
RUN pip install virtualenv
COPY docker-dast.sh /usr/local/bin/
ENTRYPOINT ["docker-dast.sh"]
