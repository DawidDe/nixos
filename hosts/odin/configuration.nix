{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/printing.nix
    ../../modules/services/pipewire.nix
    ../../modules/services/greetd.nix
    ../../modules/services/xdg-portal.nix
    ../../modules/services/polkit.nix
    ../../modules/services/hyprland.nix
    ../../modules/services/keyring.nix
  ];

  # Host-specific configurations
  networking.hostName = "odin";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  environment.systemPackages = with pkgs; [
    # ── Core / System ─────────────────────────────────────────
    bash
    nano
    git
    sudo
    screen
    fastfetch
    htop

    # ── Desktop / Window Manager ─────────────────────────────
    hyprlauncher
    quickshell
    kitty
    hyprshot
    gtk3
    gtk4
    greetd
    wayscriber

    # ── Browsers / Productivity ──────────────────────────────
    brave-origin
    libreoffice
    vscodium
    superfile
    drawio
    basalt.packages.x86_64-linux.basalt-launcher-dev

    # ── Development / Programming ────────────────────────────
    python314
    nodejs
    jdk21
    jdk25
    ffmpeg
    libopus
    github-cli
    rpi-imager

    # ── Kubernetes / Infrastructure ──────────────────────────
    kubectl
    kubelogin-oidc
    talosctl
    termius
    opentofu

    # ── Android / Waydroid ────────────────────────────────────
    android-tools
    waydroid
    waydroid-nftables
    waydroid-helper

    # ── Communication ────────────────────────────────────────
    vesktop
    signal-desktop

    # ── Media / Creative ─────────────────────────────────────
    spotify
    vlc
    obs-studio
    #davinci-resolve

    # ── Gaming ────────────────────────────────────────────────
    steam
    satisfactorymodmanager

    # ── Security / VPN / Passwords ───────────────────────────
    proton-vpn-cli
    pangolin-cli
  ];

  system.stateVersion = "26.05";
}