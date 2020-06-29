{ pkgs ? import <nixpkgs> {} }:

let
  unstable = import (
    fetchTarball { url = https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;}
  ) {
    config = pkgs.config;
  };
in
pkgs.mkShell {
  name = "k8s-takeway-shell";

  buildInputs = with pkgs; [
    gnugrep
    kubernetes-helm
    #unstable.kubernetes-helm
  ];

  shellHook = ''
  '';
}
