  
FROM ubuntu:latest
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV ACCEPT_EULA N
ENV MSSQL_PID standard
ENV MSSQL_SA_PASSWORD sasa
ENV MSSQL_TCP_PORT 1433


RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone


WORKDIR /data
ADD . /data
RUN chmod 755 /data/*
RUN /data/mssql.sh
RUN /data/flask.sh
RUN pip install --no-cache-dir -r requirements.txt
RUN rm -r /data

RUN apt-get install -y supervisor
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*    

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

RUN echo "[program:python-flask]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'command=python3 app.py' >> /etc/supervisor/conf.d/supervisord.conf

RUN echo '#!/bin/sh' >> /startup.sh
RUN echo '/opt/mssql/bin/sqlservr' >> /startup.sh
python app.py
RUN echo 'exec supervisord -c /etc/supervisor/supervisord.conf' >> /startup.sh

RUN chmod +x /startup.sh

EXPOSE  8000
CMD ["/startup.sh"]
