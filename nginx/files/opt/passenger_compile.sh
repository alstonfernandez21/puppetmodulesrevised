#!/bin/bash
passenger-install-nginx-module --auto --prefix=/opt/nginx/ --auto-download --extra-configure-flags=--with-http_ssl_module

