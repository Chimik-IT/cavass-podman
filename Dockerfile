FROM ubuntu:latest

ENV VIEWNIX_ENV=/cavass
WORKDIR /cavass
COPY cavass /cavass-src
COPY wxWidgets-3.2.2.1 /wxWidgets-src

RUN apt update && apt upgrade -y
RUN apt install libgtk2.0-dev openssh-server cmake -y

RUN mkdir /wxWidgets-build
RUN cd /wxWidgets-build
RUN ../wxWidgets-src/configure --with-gtk
RUN make -j $(nproc)
RUN make install
RUN /sbin/ldconfig
RUN rm -rf /wxWidgets

RUN cmake CMAKE_BUILD_TYPE=Release ../cavass-src
RUN make -j $(nproc)
RUN rm -rf /cavass-src

WORKDIR /annotations

CMD /cavass/cavass

