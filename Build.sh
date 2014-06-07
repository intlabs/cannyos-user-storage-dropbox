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
sudo docker stop cannyos-user-storage-dropbox
sudo docker rm cannyos-user-storage-dropbox

# Get peramiters for logging into dropbox
echo ""
echo "*********************************************************************************************************************************\n"
echo "*                                                                                                                               *\n"
echo "* Goto https://www.dropbox.com/developers/apps and create a dropbox api app                                                     *\n"
echo "* Please enter app_key                                                                                                          *\n"
echo "*                                                                                                                               *\n"
echo "*********************************************************************************************************************************\n"
read app_key
echo ""
echo "*********************************************************************************************************************************\n"
echo "*                                                                                                                               *\n"
echo "* Goto https://www.dropbox.com/developers/apps and create a dropbox api app                                                     *\n"
echo "* Please enter app_secret                                                                                                       *\n"
echo "*                                                                                                                               *\n"
echo "*********************************************************************************************************************************\n"
echo ""
read app_secret
echo ""
echo "*********************************************************************************************************************************\n"
echo "*                                                                                                                               *\n"
echo "* Goto https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=$app_key and create a dropbox api app *\n"
echo "* Please enter authorization_code                                                                                               *\n"
echo "*                                                                                                                               *\n"
echo "*********************************************************************************************************************************\n"
echo ""
echo ""
read authorization_code

# Launch built base container image
sudo docker run -i -t --rm \
 --privileged=true --lxc-conf="native.cgroup.devices.allow = c 10:229 rwm" \
 --volume "/CannyOS/build/cannyos-user-storage-dropbox":"/CannyOS/Host" \
 --name "cannyos-user-storage-dropbox" \
 --user "root" \
 -p 222:22 \
 intlabs/cannyos-user-storage-dropbox \
 new $app_key $app_secret $authorization_code

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "* CannyOS/cannyos-user-storage-dropbox-post-install *"
echo "*                                           created *"
echo "*****************************************************"
echo ""

echo "********************************************************************************"
echo "*                                                                              *"
echo "*  launch using: (for an existing connection)                                  *"
echo "*          -this currently has permission problems on reconnection             *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""
echo "sudo docker run -it --rm -p 222:22 -p 111:111 -p 2049:2049 \\"
echo "--privileged=true --lxc-conf=\"native.cgroup.devices.allow = c 10:229 rwm\" \\"
echo "--name test --hostname test \\"
echo "-v /var/user-storage intlabs/dockerfile-ubuntu-fileserver \\"
echo "existing <access_token>"