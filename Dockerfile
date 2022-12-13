FROM ubuntu:22.04
RUN apt-get update

RUN apt-get install -y openssh-server sudo
RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt install --no-install-recommends -y curl git libffi-dev libjpeg-dev libwebp-dev python3-lxml python3-psycopg2 libpq-dev libcurl4-openssl-dev libxml2-dev libxslt1-dev python3-pip python3-sqlalchemy openssl wget python3 python3-dev libreadline-dev libyaml-dev gcc zlib1g ffmpeg libssl-dev libgconf-2-4 libxi6 unzip libopus0 libopus-dev python3-venv libmagickwand-dev pv tree mediainfo nano screen nodejs

RUN git clone https://github.com/TgCatUB/catuserbot /root/catuserbot
RUN pip3 install git+https://github.com/jisan09/Telethon

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd
RUN passwd --expire root

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /root/catuserbot
RUN mv exampleconfig.py config.py
RUN screen -S catuserbot
RUN virtualenv venv
RUN source venv/bin/activate
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
