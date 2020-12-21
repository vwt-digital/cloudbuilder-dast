FROM gcr.io/google.com/cloudsdktool/cloud-sdk:latest

ARG TARGET_BRANCH
ENV TARGET_BRANCH ${TARGET_BRANCH:-master}

COPY dast.py /usr/local/bin

RUN git clone --depth 1 --single-branch --branch OpenSSL_1_1_1-stable https://github.com/openssl/openssl.git \
    && cd openssl \
    && ./config --openssldir=/usr/lib/ssl enable-ssl2 enable-ssl3 enable-ssl3-method enable-weak-ssl-ciphers no-shared no-tests \
    && make depend && make && make install_sw \
    && cp /openssl/apps/openssl /usr/bin/openssl \
    && cd - && rm -Rf openssl \
    && sed -i 's/CipherString = DEFAULT@SECLEVEL=2/CipherString = ALL@SECLEVEL=1/g' /etc/ssl/openssl.cnf

RUN if [ "$TARGET_BRANCH" = "develop" ] ; then pip3 install -i https://test.pypi.org/simple/ sec-helpers ; else pip3 install sec-helpers; fi

ENTRYPOINT ["python3", "/usr/local/bin/dast.py"]
