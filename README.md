# docker-rtorrent-base
## Base image for rtorrent-related images.

## Overview
Not meant to be run as an actual container, but rather used as a base for more robust ones.  Compiles xmlrpc, libtorrent, and rtorrent.  Installs default configuration file.

- Used as base for other images
    - neosar/docker-rtorrent-daemon
    - neosar/docker-rutorrent

## Credits
Based heavily off of romancin/rutorrent-flood-docker.