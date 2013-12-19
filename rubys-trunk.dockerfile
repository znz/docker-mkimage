# usage:
# docker build -t local/debian-ja:rubys-trunk - < rubys-trunk.dockerfile
# docker run -i -t local/debian-ja:rubys-trunk
FROM local/debian-ja:rubys
MAINTAINER Kazuhiro NISHIYAMA

RUN apt-get install -y ruby bison
RUN bash -c 'set -eux; \
 . /etc/profile.d/rbenv.sh; \
 rbenv git pull; \
 rbenv git gc; \
 export CONFIGURE_OPTS="--disable-install-rdoc --disable-install-doc"; \
 rm -rf /opt/rbenv/versions/2.1.0-dev; \
 rbenv install -v 2.1.0-dev; \
 '

CMD ["/bin/bash", "-l"]
