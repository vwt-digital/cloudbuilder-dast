FROM python:3.7-slim
ARG TARGET_BRANCH
ENV TARGET_BRANCH ${TARGET_BRANCH:-master}
WORKDIR /workspace
RUN apt-get -y update && \
    apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
    apt-get update && \
    apt install wget && \
    apt-get install build-essential -y && \
    wget https://openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz && \
    tar -xvf openssl-1.0.2k.tar.gz && \
    cd openssl-1.0.2k/ && \
    ./config --prefix=`pwd`/local --openssldir=/usr/lib/ssl enable-ssl2 enable-ssl3 no-shared && \
    make depend && \
    make && \
    make -i install && \
    cp local/bin/openssl /usr/local/bin/
RUN cd / && \
    git clone --single-branch --branch $TARGET_BRANCH https://github.com/vwt-digital/sec-helpers.git && \
    cd /sec-helpers && \
    pip install --no-cache-dir -r requirements.txt
RUN pip install virtualenv
COPY docker-dast.sh /usr/local/bin/
ENTRYPOINT ["docker-dast.sh"]
