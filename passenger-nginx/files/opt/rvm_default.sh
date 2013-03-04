#!/usr/bin/env bash
yum -y install gcc* make automake zlib-devel libjpeg-devel giflib-devel freetype-devel bison openssl-devel git readline-devel
curl -L https://get.rvm.io | bash -s stable
command /usr/local/rvm/bin/rvm install 1.9.2
