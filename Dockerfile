FROM ubuntu:latest

ENV VIEWNIX_ENV=/cavass

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends --no-install-suggests  wget bzip2 libgtk2.0-dev make gcc g++ cmake -y

# install wxWidgets

RUN wget --no-check-certificate https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.2.1/wxWidgets-3.2.2.1.tar.bz2 -P /
RUN tar xfj /wxWidgets-3.2.2.1.tar.bz2 && rm /wxWidgets-3.2.2.1.tar.bz2
RUN mkdir /wxWidgets-build
RUN cd /wxWidgets-build && ../wxWidgets-3.2.2.1/configure --with-gtk &&  make -j $(nproc) && make install && /sbin/ldconfig

# install InsitghtToolKit
RUN wget --no-check.certificate https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.3.0/InsightToolkit-5.3.0.tar.gz -P /
RUN tar xfz /InsightToolkit-5.3.0.tar.gz && rm /InsightToolkit-5.3.0.tar.gz
RUN mkdir /ITK-build
RUN cd /ITK-build && cmake -DBUILD_TESTING=ON ../InsightToolkit-5.3.0 && make -j $(nproc) && make install && /sbin/ldconfig
RUN rm -r /InsightToolkit-5.3.0 /ITK-build

# prepare cavass

RUN mkdir /cavass-build
RUN wget --no-check-certificate http://www.mipg.upenn.edu/cavass/cavass-src-1_0_30.tgz -P /
RUN tar xfz cavass-src-1_0_30.tgz -C /
RUN cd cavass-build && cmake -DCMAKE_BUILD_TYPE=Release ../cavass/ && make -j $(nproc)

WORKDIR /annotations

CMD /cavass-build/cavass

