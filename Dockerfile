FROM python:3.7-slim
ARG TARGET_BRANCH
ENV TARGET_BRANCH ${TARGET_BRANCH:-master}
WORKDIR /workspace
RUN apt-get -y update && \
    apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*
COPY requirements.txt /workspace
COPY test.py /workspace
RUN cd /tmp && \
    apt-get update && \
    apt install wget && \
    apt-get install build-essential -y && \
    wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz && \
    tar -xvf openssl-1.0.2k.tar.gz && \
    cd openssl-1.0.2k/ && \
    ./config --prefix=`pwd`/local --openssldir=/usr/lib/ssl enable-ssl2 enable-ssl3 no-shared && \
    make depend && \
    make && \
    make -i install && \
    cp local/bin/openssl /usr/local/bin/
RUN pip install -r requirements.txt
RUN if [ "$TARGET_BRANCH" = "develop" ] ; then pip install -i https://test.pypi.org/simple/ sec-helpers ; else pip install sec-helpers; fi
ENTRYPOINT ["python", "/workspace/test.py"]
