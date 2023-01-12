{ pkgs ? import <nixpkgs> {} }:

let
  nodeEnv = "production";
  nodeImage = pkgs.nodejs;
  tini = pkgs.tini;
in
  pkgs.dockerTools.buildImage {
    name = "superfluid-sentinel";
    config = {
      env = {
        NODE_ENV = nodeEnv;
      };
      workingDir = "/app";
      buildCommand = 
        ''
        apk add --update --no-cache g++ make python3 && ln -sf python3 /usr/bin/python
        '';
      copy = [
        "package.json"
        "package-lock.json*"
        "."
      ];
      runCommand = 
        ''
        npm ci --only=production
        mkdir data
        chown node:node data
        apk add --no-cache ${tini}
        '';
      entrypoint = [ "/sbin/tini" "--" ];
      cmd = [ "${pkgs.nodejs}/bin/node" "main.js" ];
    };
    config.image = nodeImage;
  }