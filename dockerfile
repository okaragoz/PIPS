#
# Ubuntu 14.04 + XFCE + ISIS3 + AMES_Stereo_Pipeline - Dockerfile
# Get Ubuntu from sources
# https://github.com/dockerfile/ubuntu
#


# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu csh curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Install. XFCE
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xubuntu-desktop tightvncserver
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get install xrdp -y
# Configure the Ubuntu server for xrdp to know that the xfce desktop environment will be used instead of Gnome or Unity. To configure these settings, you have to type the following command in terminal.
 echo “xfce4-session” > ~/.xsession

RUN sudo sed -i -e '8 {s|. /etc/X11/Xsession|startxfce4|g}' /etc/xrdp/startwm.sh

# Start the xrdp service on Ubuntu server by typing below command in terminal.
RUN /etc/init.d/xrdp start

# Get GDAL + Circ (by Andrew Annex)

RUN add-apt-repository ppa:ubuntugis/ppa && sudo apt-get update -y
RUN apt-get install gdal-bin -y

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

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
RUN git clone git@github.com:AndrewAnnex/circ.git

# Ajenti installation
RUN cd /home/isis3user
RUN curl https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh | sudo bash -s -


# get isis3 FULL data for Ubuntu 14.04
RUN rsync -azv --delete --partial \
isisdist.astrogeology.usgs.gov::x86-64_linux_UBUNTU/isis /home/isis3user/

# get Ames StereoPipeline data for Ubuntu 14.04
RUN apt-get update -y
RUN cd /home/isis3user
RUN wget https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/v2.6.0/StereoPipeline-2.6.0-2017-06-01-x86_64-Linux.tar.bz2
RUN  tar xvjf StereoPipeline-2.6.0-2017-06-01-x86_64-Linux.tar.bz2

# get isis3 base data (500 gb +) if you want
# RUN mkdir /home/isis3user/isis3data
# RUN rsync -azv --delete --partial \
# isisdist.astrogeology.usgs.gov::isis3data/data/base /home/isis3user/isis3data/

# RUN touch /home/isis3user/bubbi.txts
# ENV export ISISROOT=/home/isis3user/isis
# ENV export PATH=/home/isis3user/isis/bin:$PATH
# ENV . $ISISROOT/scripts/isis3Startup.sh

echo 'export ISISROOT=/home/isis3user/isis' >>/home/isis3user/.bash_profile
echo 'export PATH=/home/isis3user/isis/bin:$PATH' >>/home/isis3user/.bash_profile
echo '. $ISISROOT/scripts/isis3Startup.sh' >>/home/isis3user/.bash_profile
echo 'export ISIS3DATA=/home/isis3user/isis3data' >>/home/isis3user/.bash_profile

RUN mkdir /home/isis3user/isis/raw_data
RUN cd /home/isis3user/isis/raw_data
RUN wget https://cdn.rawgit.com/okaragoz/PIPS/c94f2b75/rawex_file/neuctx.bat
RUN wget https://cdn.rawgit.com/okaragoz/PIPS/c94f2b75/rawex_file/stereo.default

RUN /bin/tcsh
RUN setenv ISISROOT /home/isis3user/isis/
RUN source $ISISROOT/scripts/isis3Startup.csh
RUN setenv PATH "/home/isis3user/StereoPipeline-2.6.0-2017-06-01-x86_64-Linux/bin:${PATH}"
