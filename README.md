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
    sed -e 's/debian/ubuntu/g' rbenv.dockerfile | docker build -t local/ubuntu-ja:rbenv -

run:

    docker run -i -t local/debian-ja:rbenv

or

    docker run -i -t local/ubuntu-ja:rbenv

### rubys

build:

    docker build -t local/debian-ja:rubys - < rubys.dockerfile
    sed -e 's/debian/ubuntu/g' rubys.dockerfile | docker build -t local/ubuntu-ja:rubys -

run:

    docker run -i -t local/debian-ja:rubys

or

    docker run -i -t local/debian-ja:rubys

and run in docker:

    rbenv each ruby -v

### rubys with trunk

build:

    docker build -t local/debian-ja:rubys-trunk - < rubys-trunk.dockerfile
    sed -e 's/debian/ubuntu/g' rubys-trunk.dockerfile | docker build -t local/ubuntu-ja:rubys-trunk -

run:

    docker run -i -t local/debian-ja:rubys-trunk

or

    docker run -i -t local/debian-ja:rubys-trunk

and run in docker:

    rbenv each ruby -v
