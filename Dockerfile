FROM debian:buster
MAINTAINER John Stucklen <stuckj@gmail.com>

RUN apt-get update \
    && apt-get install --force-yes -y \
      git \
      clang \
      cmake \
      make \
      gcc \
      g++ \
      libmariadbclient-dev \
      libssl-dev \
      libbz2-dev \
      libreadline-dev \
      libncurses-dev \
      libboost-all-dev \
      default-mysql-client \
      p7zip \
      default-libmysqlclient-dev \
    && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

RUN mkdir -p /home/trinitycore

RUN useradd -ms /bin/bash trinitycore

WORKDIR /home/trinitycore

RUN git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git

RUN cd TrinityCore \
  && mkdir build \
  && cd build \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=/home/trinitycore -DCONF_DIR=/home/trinitycore/
etc -DLIBSDIR=/home/trinitycore/lib \
  && make -j $(nproc) install

RUN chown -R trinitycore:trinitycore /home/trinitycore

USER trinitycore

CMD [ "/home/trinitycore/bin/worldserver" ]
