{ config, pkgs, lib, ... }:
let 
  # read from json
  config = builtins.fromJSON (builtins.readFile /home/kristian/.configuration/mqtt.json);
in 
{
  networking.firewall.allowedTCPPorts = [ 8080 ];

  services.mosquitto = {
    enable = true;
    package = pkgs.mosquitto;
    config = {
      allow_anonymous = false;
      password_file = "/home/kristian/.configuration/mqttpwd";
      listener = {
        port = 1883;
        protocol = "mqtt";
      };
    };
  };

  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.zigbee2mqtt;
    settings = {

      permit_join = false;
      # serial.port = "/dev/ttyUSB0";
      frontend = true;
      device_options = {
        retain = true;
      };
      advanced = {
        channel = 25;
        network_key = config.network_key;
        log_output = [ "console" ];
        log_level = "warn";
      };
      mqtt = {
        version = 5;
        server = "mqtt://localhost:1883";
        user = "zigbee2mqtt";
        password =  config.mqtt_password;
      };
    };
  };
}