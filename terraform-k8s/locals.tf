locals {
  deployment = {
    nodered = {
      #   container_count = length(var.ext_port["nodered"][terraform.workspace])
      image       = "nodered/node-red:latest-22"
      int         = 1880
      ext         = 1880
      volumespath = "/data"
    }
    influxdb = {
      #   container_count = length(var.ext_port["influxdb"][terraform.workspace])
      image       = "quay.io/influxdb/influxdb:v2.0.2"
      int         = 8086
      ext         = 8086
      volumespath = "/var/lib/influxdb"
    }
    grafana = {
      #   container_count = length(var.ext_port["grafana"][terraform.workspace])
      image       = "grafana/grafana"
      int         = 3000
      ext         = 3000
      volumespath = "/etc/grafana"
    }
  }
}
