FROM debian:jessie-slim

RUN apt-get update && apt-get install -y cron python-pip
RUN pip install awscli

ADD entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT /entrypoint.sh