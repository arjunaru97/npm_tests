FROM ubuntu:trusty
MAINTAINER Yuji Watanabe <muew@jp.ibm.com>
ARG SAS_CONF="src/sas-conf.json"

WORKDIR /root


# Install node and npm
RUN \
  apt-get install -y nodejs npm && \
  npm cache clean && \
  npm update -g npm && \
  npm config set strict-ssl false && \
  npm install -g n && \
  npm config set strict-ssl true && \
  n 10.9.0 && \
  ln -sf /usr/local/bin/node /usr/bin/node && \
  apt-get purge -y nodejs
  
  
COPY /src/package*.json ./
RUN npm install 

EXPOSE 6100

COPY ${SAS_CONF} /cloudsight/sas/src/sas-conf.json
COPY start-frontend-api.sh /opt/start-frontend-api.sh
COPY logrotate_sas.conf /etc/logrotate.d/sas

RUN chmod a+x /opt/start-frontend-api.sh
ENTRYPOINT [ "/opt/start-frontend-api.sh" ]
