#!/bin/bash
#yum install openssl-devel zlib-devel gcc gcc-c++ curl-devel expat-devel gettext-devel mysql-server mysql-devel wget nano
cd /usr/local/src
wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p174.tar.gz
tar xvzf ruby-1.8.7*.tar.gz
cd ruby-1.8.7*
./configure --enable-shared --enable-pthread
make
make install
cd ext/zlib
ruby extconf.rb --with-zlib-include=/usr/include --with-zlib-lib=/usr/lib64
cd ../../
make
make install
sleep 2
cd /usr/local/src
wget http://rubyforge.org/frs/download.php/70696/rubygems-1.3.7.tgz
tar xvzf rubygem*.tgz
cd rubygem*
/usr/local/bin/ruby setup.rb
gem install rubygems-update
rm -rf /usr/local/src/ruby-1.8.7-p174.tar.gz
rm -rf /usr/local/src/rubygems-1.3.7.tgz
/usr/local/bin/gem install passenger
/usr/local/bin/gem install rake
/usr/local/bin/gem install rack
/usr/local/bin/gem install fastthread
sleep 5
