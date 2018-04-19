# PIPSM
# Ubuntu 14.04 + XFCE + ISIS3 + AMES_Stereo_Pipeline etc. - Dockerfile
# Get Ubuntu from sources
# https://github.com/dockerfile/ubuntu
#

FROM ubuntu:14.04.3

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install -y supervisor wget \
		xfce4 xfce4-goodies x11vnc xvfb \
		gconf-service libnspr4 libnss3 fonts-liberation \
		libappindicator1 libcurl3 fonts-wqy-microhei

# download google chrome and install
#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN dpkg -i google-chrome*.deb
#RUN apt-get install -f

RUN apt-get autoclean && apt-get autoremove && \
		rm -rf /var/lib/apt/lists/*

WORKDIR /root

ADD startup.sh ./
ADD supervisord.conf ./



COPY xfce4 ./.config/xfce4

EXPOSE 5900
EXPOSE 8000

RUN echo "latest" > /version

# Configure the Ubuntu server for xrdp to know that the xfce desktop environment will be used instead of Gnome or Unity. To configure these settings, you have to type the following command in terminal.
#RUN echo “xfce4-session” > ~/.xsession

#RUN sudo sed -i -e '8 {s|. /etc/X11/Xsession|startxfce4|g}' /etc/xrdp/startwm.sh

# Start the xrdp service on Ubuntu server by typing below command in terminal.
#RUN /etc/init.d/xrdp start

# Get GDAL + Circ (by Andrew Annex)

RUN add-apt-repository ppa:ubuntugis/ppa && sudo apt-get update -y
RUN apt-get install gdal-bin -y

# Add files.
#ADD root/.bashrc /root/.bashrc
#ADD root/.gitconfig /root/.gitconfig
#ADD root/.scripts /root/.scripts

# Set environment variables.
#ENV HOME /root

# Define working directory.
#WORKDIR /root

# Define default command.
#CMD ["bash"]

MAINTAINER apr

RUN apt-get update -y
RUN apt-get install -y rsync
RUN apt-get install -y x11-common \
x11-xkb-utils \
libblas3gf \
libfreetype6 \
libx11-dev \
libxrender1 \
libfontconfig1 \
libquadmath0 \
libjpeg-dev \
libjpeg62

# create user and home
RUN useradd --create-home --home-dir /home/isis3user --shell /bin/bash isis3user

# Circ installation
RUN cd /home/isis3user
RUN apt-get install openssh-server -y
RUN service ssh restart
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone https://github.com/AndrewAnnex/circ.git

# Ajenti installation
RUN cd /home/isis3user
RUN apt install -y ajenti

# RUN JAvA RUN
RUN apt-get install default-jdk
RUN apt-get install default-jre

# get isis3 FULL required binaries for Ubuntu 14.04
RUN rsync -azv --delete --partial \
isisdist.astrogeology.usgs.gov::x86-64_linux_UBUNTU/isis /home/isis3user/


# get Ames StereoPipeline data for Ubuntu 14.04
RUN cd /home/isis3user
RUN wget https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/v2.6.0/StereoPipeline-2.6.0-2017-06-01-x86_64-Linux.tar.bz2
RUN tar xvjf StereoPipeline-2.6.0-2017-06-01-x86_64-Linux.tar.bz2
RUN mv StereoPipeline-2.6.0-2017-06-01-x86_64-Linux /home/isis3user

# get isis3 base data
# RUN mkdir /home/isis3user/isis3data
# RUN rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isis3data/data/base /home/isis3user/isis3data/

# get isis3 MARS Data
#RUN rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isis3data/data/mro data/
#RUN rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isis3data/data/mex data/


# RUN touch /home/isis3user/bubbi.txts
# ENV export ISISROOT=/home/isis3user/isis
# ENV export PATH=/home/isis3user/isis/bin:$PATH
# ENV . $ISISROOT/scripts/isis3Startup.sh

RUN echo 'export ISISROOT=/home/isis3user/isis' >>/home/isis3user/.bash_profile
RUN echo 'export PATH=/home/isis3user/isis/bin:$PATH' >>/home/isis3user/.bash_profile
RUN echo '. $ISISROOT/scripts/isis3Startup.sh' >>/home/isis3user/.bash_profile
RUN echo 'export ISIS3DATA=/home/isis3user/isis3data' >>/home/isis3user/.bash_profile

RUN mkdir /home/isis3user/isis/raw_data
RUN cd /home/isis3user/isis/raw_data
RUN wget https://cdn.rawgit.com/okaragoz/PIPS/c94f2b75/rawex_file/neuctx.bat
RUN wget https://cdn.rawgit.com/okaragoz/PIPS/c94f2b75/rawex_file/stereo.default
RUN mv neuctx.bat /home/isis3user/isis/raw_data
RUN mv stereo.default /home/isis3user/isis/raw_data
RUN wget https://cdn.rawgit.com/okaragoz/PIPS/f1dba4cc/rawex_file/go.sh
RUN mv go.sh /home/isis3user/isis/raw_data
RUN cd /home/isis3user/isis/raw_data
#RUN chmod +x go.sh
#RUN ./go.sh

#RUN apt-get install tcsh -y
#RUN apt-get install csh -y
#RUN tcsh --version

#RUN /bin/tcsh
# Docker does not support yet automated tcsh environment code
#RUN setenv ISISROOT /home/isis3user/isis/
#RUN source $ISISROOT/scripts/isis3Startup.csh
#RUN setenv PATH "/home/isis3user/StereoPipeline-2.6.0-2017-06-01-x86_64-Linux/bin:${PATH}"
