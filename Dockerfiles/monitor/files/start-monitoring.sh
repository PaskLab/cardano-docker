#!/bin/bash

prometheus --config.file=/root/config/prometheus.yml --web.listen-address=:3200 &
sleep 3

grafana-server --config /root/config/grafana.ini --homepath /root/grafana
