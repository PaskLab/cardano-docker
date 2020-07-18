#!/bin/bash

node_exporter &
sleep 3

prometheus --config.file=/root/config/prometheus.yml --web.listen-address=:3200 &
