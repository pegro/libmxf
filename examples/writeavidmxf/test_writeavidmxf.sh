#!/bin/sh
#
# Simple test script
#
# Copyright (C) 2008, British Broadcasting Corporation
# All Rights Reserved.
#
# Author: Stuart Cunningham
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the British Broadcasting Corporation nor the names
#       of its contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

VALGRIND_CMD=""
if [ "$1" = "--valgrind" ] ; then
	VALGRIND_CMD="valgrind --leak-check=full"
fi

# create sample essence as input file (size of largest input for unc1080i)
dd if=/dev/zero bs=4147200 count=1 of=essence.dat 2>/dev/null

# TODO: create DV test files
for format in IMX30 IMX40 IMX50 \
	DNxHD1080p1235 DNxHD1080p1237 DNxHD1080p1238 \
	DNxHD1080i1241 DNxHD1080i1242 DNxHD1080i1243 \
	DNxHD720p1250 DNxHD720p1251 DNxHD720p1252 \
	DNxHD1080p1253 \
	unc unc1080i unc720p
do
	command="$VALGRIND_CMD ./writeavidmxf --prefix test_$format --$format essence.dat --pcm essence.dat"
	echo $command
	$command || exit 1
done

for format in \
	DNxHD1080p1253 DNxHD1080p1235 DNxHD1080p1237 DNxHD1080p1238
do
	command="$VALGRIND_CMD ./writeavidmxf --prefix test_${format}_23.976 --film23.976 --$format essence.dat --pcm essence.dat"
	echo $command
	$command || exit 1
done

rm -f essence.dat
