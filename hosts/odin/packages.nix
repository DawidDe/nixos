{
  pkgs,
  basalt,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # ── Core / System ─────────────────────────────────────────
    bash
    bash-completion
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
    openvpn
    libreoffice
    vscodium
    antigravity
    superfile
    drawio
    yubioath-flutter
    basalt.packages.x86_64-linux.basalt-launcher-dev

    # ── Development / Programming ────────────────────────────
    python314
    uv
    ruff
    gitleaks
    nodejs
    #jdk21
    jdk25
    nodejs_22
    ffmpeg
    libopus
    github-cli
    rpi-imager
    sops
    age
    age-plugin-yubikey
    bruno
    ruff

    # ── Kubernetes / Infrastructure ──────────────────────────
    kubectl
    kubelogin-oidc
    talosctl
    fluxcd
    cilium-cli
    sshm
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
    kicad

    # ── Gaming ────────────────────────────────────────────────
    steam
    heroic
    satisfactorymodmanager
    bs-manager

    # ── Security / VPN / Passwords ───────────────────────────
    proton-vpn-cli
    pangolin-cli

    # ── local llm ────────────────────────────────────────────
    llama-cpp-vulkan
  ];

}
