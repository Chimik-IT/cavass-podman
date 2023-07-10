FROM debian:bookworm-slim

ENV VIEWNIX_ENV=/cavass
WORKDIR /cavass

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends --no-install-suggests  wget bzip2 libgtk2.0-dev make gcc g++ cmake -y

# install wxWidgets

RUN wget --no-check-certificate https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.2.1/wxWidgets-3.2.2.1.tar.bz2 -P /cavass
RUN tar xfj /cavass/wxWidgets-3.2.2.1.tar.bz2 && rm /cavass/wxWidgets-3.2.2.1.tar.bz2
RUN mkdir wxWidgets-build
RUN cd wxWidgets-build && ../wxWidgets-3.2.2.1/configure --with-gtk
RUN cd wxWidgets-build && make -j $(nproc) && make install && /sbin/ldconfig
RUN rm -rf wxWidgets-3.2.2.1 wxWidgets-build
# prepare cavass

RUN wget --no-check-certificate http://www.mipg.upenn.edu/cavass/cavass-src-1_0_30.tgz -P /cavass
RUN cmake CMAKE_BUILD_TYPE=Release cavass && make -j $(nproc)

WORKDIR /annotations

CMD /cavass/cavass

