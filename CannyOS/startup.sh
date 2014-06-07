#!/bin/sh
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
cat /CannyOS/CannyOS.splash
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
echo "*      WELCOME TO A CANNYOS DOCKER CONTAINER        *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Run postinstall script if required.
if [ -e /CannyOS/post-install.sh ]; then
	/CannyOS/post-install.sh
	exit
fi

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*         Startup script launch                     *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

#Startup script begins:

set -e

#if set to new - it will expect the app_key, app_secret and authorisation code to be supplied
#if set to existing - it will expect the access_token to be supplied
mode="${1}"

if [ "$mode" = "new" ]; then
	app_key="${2}"
	app_secret="${3}"
	authorization_code="${4}"
	echo "********************************************************************************"
	echo "*                                                                              *"
	echo "*    this mode expects you to have done the following:                         *"
	echo "*    create a new dropbox api app and use its generated output                 *"
	echo "*    go to the url specified bellow  (exaple for cannyos testing)              *"
	echo "*                                                                              *"
	echo "********************************************************************************"
	echo ""
	echo "https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=axq0c8se5oo7ndh"
	echo ""
fi

if [ "$mode" = "existing" ]; then
	access_token="${2}"
	echo "********************************************************************************"
	echo "*                                                                              *"
	echo "*    this mode expects you to have already got an access_token                 *"
	echo "*                                                                              *"
	echo "********************************************************************************"
	echo ""
fi

echo "********************************************************************************"
echo "*                                                                              *"
echo "*  launch using: (for a new connection)                                        *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""
echo "sudo docker run -it --rm -p 222:22 -p 111:111 -p 2049:2049 \\"
echo "--privileged=true --lxc-conf=\"native.cgroup.devices.allow = c 10:229 rwm\" \\"
echo "--name test --hostname test \\"
echo "-v /var/user-storage intlabs/dockerfile-ubuntu-fileserver \\"
echo "new <app_key> <app_secret> <authorization_code>"
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
echo ""
echo "********************************************************************************"
echo "*                                                                              *"
echo "*    Your dropbox drive will be mounted at /mnt/dropbox                        *"
echo "*                                                                              *"
echo "*                                                                              *"
echo "*               (c) Pete Birley 2014 - petebirley@gmail.com                    *"
echo "*                                                                              *"
echo "********************************************************************************"
echo ""

# Parse Command line entry
if [ "$mode" = "new" ]; then
	#Get a new access token
	/CannyOS/Storage/Dropbox/getDropboxAccessToken.py -ak $app_key -as $app_secret -c $authorization_code 
fi

if [ "$mode" = "existing" ]; then
	#Store access token
	echo $access_token >> /ff4d/ff4d.config
fi


#Launch Dropbox FUSE
/CannyOS/Storage/Dropbox/ff4d.py -ar -bg /mnt/dropbox 

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*         Startup script finish                     *"
echo "*                                                   *"
echo "*****************************************************"
echo ""

# Drop into shell
bash