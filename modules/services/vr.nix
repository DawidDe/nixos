{ config, lib, pkgs, ... }:

{
    services.wivrn = {
        enable = true;

        autoStart = true;
    }
}