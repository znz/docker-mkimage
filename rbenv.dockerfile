# build:
#  docker build -t local/debian-ja:rbenv - < rbenv.dockerfile
# usage:
#  docker run -i -t local/debian-ja:rbenv
# or
#  docker run -i -t local/debian-ja:rbenv /bin/bash -l

FROM local/debian-ja:latest
MAINTAINER Kazuhiro NISHIYAMA

RUN apt-get install -y git-core wget build-essential autoconf libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev
RUN apt-get install -y bash-completion vim
RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv
RUN git clone https://github.com/sstephenson/ruby-build /opt/rbenv/plugins/ruby-build
RUN {\
 echo 'export RBENV_ROOT=/opt/rbenv';\
 echo 'export PATH="$RBENV_ROOT/bin:$PATH"';\
 echo 'eval "$(rbenv init -)"';\
} > /etc/profile.d/rbenv.sh

CMD ["/bin/bash", "-l"]
