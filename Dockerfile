FROM ubuntu:latest

MAINTAINER gfwbrker

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    nginx \
    supervisor \
    libmysqlclient-dev \
    sqlite3 && \
    pip3 install -U pip setuptools && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install uwsgi

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY ./deployment/nginx_vhost.conf /etc/nginx/sites-available/default
COPY ./deployment/supervisor-app.conf /etc/supervisor/conf.d/
COPY ./deployment/uwsgi.ini /home/docker/code/

COPY ./deployment/requirements.txt /home/docker/code/
RUN pip3 install -r /home/docker/code/requirements.txt

COPY ./app /home/docker/code/

EXPOSE 80

CMD ["supervisord", "-n"]
