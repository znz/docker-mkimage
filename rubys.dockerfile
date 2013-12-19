# usage:
# docker build -t local/debian-ja:rubys - < rubys.dockerfile
# docker run -i -t local/debian-ja:rubys
FROM local/debian-ja:rbenv

RUN bash -c 'set -euo pipefail; \
 set -x; \
 . /etc/profile.d/rbenv.sh; \
 git clone https://github.com/znz/rbenv-plug /opt/rbenv/plugins/rbenv-plug; \
 rbenv plug each; \
 rbenv plug git; \
 rbenv git pull; \
 rbenv git gc; \
 export CONFIGURE_OPTS="--disable-install-rdoc --disable-install-doc"; \
 for v in \
 1.8.7-p374 \
 1.9.3-p484 \
 2.0.0-p353 \
 2.1.0-preview2 \
 ; do \
 rbenv install -v $v; \
 done \
 '

CMD ["/bin/bash", "-l"]
