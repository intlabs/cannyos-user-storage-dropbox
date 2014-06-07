#
# CannyOS User Storage Dropbox
#
# https://github.com/intlabs/cannyos-user-storage-dropbox
#
# Copyright 2014 Pete Birley
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Pull base image.
FROM intlabs/dockerfile-cannyos-ubuntu-14_04-fuse

# Set environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Set the working directory
WORKDIR /

#****************************************************
#                                                   *
#         INSERT COMMANDS BELLOW THIS               *
#                                                   *
#****************************************************

# install official dropbox comand line utilities
ADD http://www.dropbox.com/download?dl=packages/dropbox.py /bin/dropbox.py

#Install fuse dropbox utility support packages:
RUN apt-get install -y libfuse2 python-pkg-resources python-pip

#Install ff4d for CannyOS
WORKDIR /
ADD CannyOS/Storage/Dropbox CannyOS/Storage/Dropbox
WORKDIR /CannyOS/Storage/Dropbox
RUN pip install dropbox

#Make mountpoint
RUN mkdir -p /mnt/dropbox

#****************************************************
#                                                   *
#         ONLY PORT RULES BELLOW THIS               *
#                                                   *
#****************************************************

#SSH
EXPOSE 22/tcp

#****************************************************
#                                                   *
#         NO COMMANDS BELLOW THIS                   *
#                                                   *
#****************************************************

# Add startup 
ADD /CannyOS/startup.sh /CannyOS/startup.sh
RUN chmod +x /CannyOS/startup.sh

# Add post-install script
#ADD /CannyOS/post-install.sh /CannyOS/post-install.sh
#RUN chmod +x /CannyOS/post-install.sh

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
ENTRYPOINT ["/CannyOS/startup.sh"]