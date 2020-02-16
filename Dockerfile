FROM ubuntu:18.04
RUN apt-get update -y \
&& apt-get upgrade -y \
&& apt-get install wget pkg-config git autoconf automake libtool curl make g++ unzip -y
RUN git clone https://github.com/protocolbuffers/protobuf.git
WORKDIR /protobuf
RUN git checkout v3.11.4
RUN git submodule update --init --recursive
RUN ./autogen.sh \
&& ./configure \
&& make -j4 \
&& make check -j4 \
&& make install -j4
RUN ldconfig
WORKDIR /
RUN git clone https://github.com/protobuf-c/protobuf-c.git
WORKDIR /protobuf-c
RUN git checkout v1.3.3
RUN ./autogen.sh \
&& ./configure \
&& make -j4 \
&& make install -j4
WORKDIR /tmp
RUN ldconfig
RUN wget https://dl.google.com/go/go1.13.8.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.13.8.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV PATH=$PATH:/root/go/bin
RUN go get -u github.com/golang/protobuf/protoc-gen-go

ENTRYPOINT [ "protoc" ]