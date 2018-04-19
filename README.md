# PIPSM
Planetary Image Processing Docker Container Stack for MARS.

Ready for virtualization based on Ubuntu 14.04 + XFCE (with x11vnc server )+ ISIS3 + AMES_Stereo_Pipeline v2.6 + Circ (Coordinate-dependent CTX Mosaic tool) + Ajenti Core 1 web based management user interface with Terminal and file accses.

PIPSM
====

*One Click, Ready to use - Planetary Image Processing Container Stack for MARS*

PIPSM generate virtual docker container for processing easily digital elevation model from CTX mosaics or HIRISE images, and then do some basic filtering and stripe overlap to come up with a reasonably minimal list of images.

PIPSM contains;
- Ubuntu 14.04.03
- XFCE (with x11vnc server)
- ISIS3 (MRO, MEX & DEM)
- AMES_Stereo_Pipeline v2.6
- Circ (Coordinate-dependent CTX Mosaic tool developed by Andrew Annex)
- GDAL
- Ajenti Core v1.


Installation
------------

Currently you must have docker installation on your system 'https://docs.docker.com/install/#cloud', then download and run Dockerfile of the PIPSM manually or Docker Hub based installation is also available in 'https://hub.docker.com'.

 `docker build [OPTIONS] PATH | URL |`


Usage
-----

.. code:: bash

  Usage:       x11VNC connection on 5900 port is available
               Ajenti connection on 8000 port is available
               Circ usage: "https://github.com/AndrewAnnex/circ"

Quick reference
---------------
               Where to get help:
               the Docker Community Forums, the Docker Community Slack, or Stack Overflow
