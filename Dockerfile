FROM debian:bookworm-slim

ENV VIEWNIX_ENV=/cavass

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends --no-install-suggests  wget bzip2 libgtk2.0-dev make gcc g++ cmake -y

# install wxWidgets

RUN wget --no-check-certificate https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.2.1/wxWidgets-3.2.2.1.tar.bz2 -P /
RUN tar xfj /wxWidgets-3.2.2.1.tar.bz2 && rm /wxWidgets-3.2.2.1.tar.bz2
RUN mkdir /wxWidgets-build
RUN cd /wxWidgets-build && ../wxWidgets-3.2.2.1/configure --with-gtk &&  make -j $(nproc) && make install && /sbin/ldconfig

# prepare cavass

RUN mkdir /cavass-build
RUN wget --no-check-certificate http://www.mipg.upenn.edu/cavass/cavass-src-1_0_30.tgz -P /
RUN tar xfz cavass-src-1_0_30.tgz -C /
RUN cd cavass-build && cmake CMAKE_BUILD_TYPE=Release ../cavass/ && make -j $(nproc)

WORKDIR /annotations

CMD /cavass-build/cavass

