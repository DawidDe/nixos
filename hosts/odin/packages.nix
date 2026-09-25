{ config, lib, pkgs, basalt, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
    hyprpolkitagent
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
    yubioath-flutter
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
    incus
    remmina

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
    heroic
    satisfactorymodmanager
    bs-manager

    # ── Security / VPN / Passwords ───────────────────────────
    proton-vpn-cli
    pangolin-cli
  ];
}