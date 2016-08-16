FROM jenkins:latest

MAINTAINER "RadiaSoft <docker@radiasoft.net>"

USER root

ADD . /rs-conf

RUN /rs-conf/as_root.sh 

USER jenkins 
