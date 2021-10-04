{ config, lib, pkgs, ... }:

let
  mainUser = "ozzy"; # web development user
  documentRoot = "/var/www"; # root folder to serve files from
in
{
  # apache web server
  services.httpd = {
    enable = true;
    adminAddr = "${mainUser}@localhost";
    enablePHP = true;
    phpOptions = ''
      date.timezone = "Europe/Berlin"
    '';
    virtualHosts = {
      localhost = {
        inherit documentRoot;
      };
    };
  };

  # set password using:
  # sudo mysql -e "set password for root@localhost = PASSWORD('changeme');"
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "127.0.0.1";
  };

  system.activationScripts.initialize-lampp-documentRoot = lib.stringAfter [ "users" "groups" ] ''
    mkdir -p "${documentRoot}"
    chown -R "${mainUser}:${config.services.httpd.group}" "${documentRoot}"
    chmod -R u+rwX,go+rX,go-w "${documentRoot}"
    ln -sf ${pkgs.phpmyadmin} /var/www/phpmyadmin
  '';
}
