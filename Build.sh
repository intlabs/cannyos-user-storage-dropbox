#!/bin/sh
#
# CannyOS cannyos-user-storage-dropbox container build script
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
clear
curl https://raw.githubusercontent.com/intlabs/cannyos-user-storage-dropbox/master/CannyOS/CannyOS.splash
#     *****************************************************
#     *                                                   *
#     *        _____                    ____  ____        *
#     *       / ___/__ ____  ___  __ __/ __ \/ __/        *
#     *      / /__/ _ `/ _ \/ _ \/ // / /_/ /\ \          *
#     *      \___/\_,_/_//_/_//_/\_, /\____/___/          *
#     *                         /___/                     *
#     *                                                   *
#     *                                                   *
#     *****************************************************
echo "*                                                   *"
echo "*         Ubuntu docker container builder           *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Build base container image
sudo docker build -t="intlabs/cannyos-user-storage-dropbox" github.com/intlabs/cannyos-user-storage-dropbox

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*         Built base container image                *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Make shared directory on host
sudo mkdir -p "/CannyOS/build/cannyos-user-storage-dropbox"
# Ensure that there it is clear
sudo rm -r -f "/CannyOS/build/cannyos-user-storage-dropbox/*"

# Remove any old containers
sudo docker rm cannyos-user-storage-dropbox

# Launch built base container image
sudo docker run -i -t -d \
 --privileged=true --lxc-conf="native.cgroup.devices.allow = c 10:229 rwm" \
 --volume "/CannyOS/build/cannyos-user-storage-dropbox":"/CannyOS/Host" \
 --name "cannyos-user-storage-dropbox" \
 --user "root" \
 intlabs/cannyos-user-storage-dropbox

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*         Launched base container image             *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Wait for post-install script to finish running (Currently time out at ) 
x=0
while [ "$x" -lt 43200 -a ! -e "/CannyOS/build/cannyos-user-storage-dropbox/done" ]; do
   x=$((x+1))
   sleep 1.0
   echo -n "Post Install script run time: $x seconds"
done
if [ -e "/CannyOS/build/cannyos-user-storage-dropbox/done" ]
then
	echo ""
	echo "*****************************************************"
	echo "*                                                   *"
	echo "*   host detected post install script competion     *"
	echo "*                                                   *"
	echo "*****************************************************"
	echo ""

else
	echo ""
	echo "*****************************************************"
	echo "*                                                   *"
	echo "*         Post install script timeout               *"
	echo "*                                                   *"
	echo "*****************************************************"
	echo ""
fi

#Get the container id
CONTAINERID=$(sudo docker ps | grep "cannyos-user-storage-dropbox" | head -n 1 | awk 'BEGIN { FS = "[ \t]+" } { print $1 }' )

#Commit the container image
sudo docker commit -m="Installed FUSE" -a="Pete Birley" $CONTAINERID intlabs/cannyos-user-storage-dropbox-post-install

# Shut down the base image
sudo docker stop cannyos-user-storage-dropbox

echo ""
echo "*****************************************************"
echo "* Success                                           *"
echo "* CannyOS/cannyos-user-storage-dropbox-post-install *"
echo "*                                           created *"
echo "*****************************************************"
echo ""


# Make shared directory on host
sudo mkdir -p "/CannyOS/build/cannyos-user-storage-dropbox-post-install"
# Ensure that there it is clear
sudo rm -r -f "/CannyOS/build/cannyos-user-storage-dropbox-post-install/*"

# Remove any old containers
sudo docker rm dockerfile-cannyos-ubuntu-14_04-fuse

sudo docker run -i -t --rm \
 --privileged=true --lxc-conf="native.cgroup.devices.allow = c 10:229 rwm" \
 --volume "/CannyOS/build/cannyos-user-storage-dropbox-post-install":"/CannyOS/Host" \
 --name "cannyos-user-storage-dropbox-post-install" \
 --user "root" \
 intlabs/cannyos-user-storage-dropbox-post-install