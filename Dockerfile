# docker build -t spiritwithourwalls/pwn-box:baseimage-amd64 .
# docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name pwn-box -i pwn-box:baseimage-amd64
# docker exec -it spiritwithourwalls/pwn-box /bin/bash

FROM phusion/baseimage:master-amd64
LABEL MAINTAINER Erebuszz 

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    libncurses5:i386 \
    libstdc++6:i386 \
    lib32stdc++6 \
    libffi-dev \
    libssl-dev \
    gcc \
    gcc-multilib \
    g++ \
    g++-multilib \
    cmake \
    nasm \
    ipython \
    python-dev \
    python3 \
    python-dev \
    python3-dev \
    python3-distutils \
    ruby \
    ruby-dev \
    vim \
    tmux \
    bsdmainutils \
    dnsutils \
    file \
    net-tools \
    iputils-ping \
    procps \
    strace \
    ltrace \
    curl \
    wget \
    git \
    netcat \
    socat \
    gdb \
    gdb-multiarch \
    radare2 && \
    apt-get autoclean && apt-get clean && apt-get autoremove && \
    rm -rf /var/lib/apt/list/*

RUN git clone https://github.com/niklasb/libc-database.git /libc-database && \
    cd /libc-database && ./get

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip install --upgrade setuptools && \
    pip install --no-cache-dir \
    capstone \
    r2pipe \
    requests \
    ropgadget \
    pwntools && \
    pip install --upgrade pwntools

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    capstone \
    ropper \
    unicorn \
    keystone-engine \
    pwntools && \
    python3 -m pip install --upgrade pwntools

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone https://github.com/longld/peda.git /root/peda && \
    sed -i 's/"autosave"  : ("on", "auto saving peda session, e.g: on|off"),/"autosave"  : ("off", "auto saving peda session, e.g: on|off"),/g' /root/peda/lib/config.py

RUN git clone https://github.com/pwndbg/pwndbg.git /root/pwndbg && \
    cd /root/pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone https://github.com/hugsy/gef.git /root/gef

RUN echo 'exec gdb -q -ex init-pwndbg -ex global "$@"' > /usr/bin/gdb-pwndbg && \
    echo 'exec gdb -q -ex init-peda -ex global "$@"' > /usr/bin/gdb-peda && \
    echo 'exec gdb -q -ex init-gef -ex global "$@"' > /usr/bin/gdb-gef && \
    chmod +x /usr/bin/gdb-*

COPY .bashrc /root/.bashrc
COPY .gdbinit /root/.gdbinit

WORKDIR /workdir/

ENTRYPOINT ["/bin/bash"]
