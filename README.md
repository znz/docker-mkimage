# docker-mkimage

make docker custom base image

## Usage

### docker-buildd-images.sh

Make buildd variant of debian and ubuntu:

    editor ./docker-buildd-images.sh
    bash ./docker-buildd-images.sh

For detail:

- http://blog.n-z.jp/blog/2013-12-13-docker-custom-base-image.html (My Japanese blog)

### rbenv

build:

    docker build -t local/debian-ja:rbenv - < rbenv.dockerfile

usage:

    docker run -i -t local/debian-ja:rbenv

or

    docker run -i -t local/debian-ja:rbenv /bin/bash -l
