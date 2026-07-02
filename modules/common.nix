{ config, pkgs, lib, ... }:

# Platform-agnostic core: everything here must work on darwin AND linux.
# Mac-only things go in darwin.nix, linux-only in linux.nix.
{
  home.username = "ani";
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # NOTE: with pkgs makes it so you dont have to do pkgs.[package]. every time
  home.packages = with pkgs; [
    ### shell / cli basics
    ripgrep
    jq
    fzf
    bat
    htop
    fd
    tree
    wget
    coreutils
    p7zip

    ### NOTE: ### DEV
    git
    git-lfs
    starship
    uv
    rustup
    zsh-autocomplete
    gh
    neovim
    gnupg
    tree-sitter

    ### languages / toolchains
    go
    gopls
    maven

    ### build tools
    cmake
    meson
    automake
    texinfo

    ### cloud / infra
    awscli2
    cloudflared
    rclone
    localstack

    ### misc
    ffmpeg
    graphviz
    iverilog # icarus-verilog
    jadx
    openconnect
    opencode
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml".source = ../starship.toml;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        export PATH="$HOME/.cargo/bin:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.emacs.d/bin:$PATH"
      '')
      ''
        if [ -x "$HOME/.local/bin/wo" ]; then
          source <("$HOME/.local/bin/wo" init zsh)
        fi
      ''
    ];

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };

    shellAliases = {
      cr = "cargo run";
      update = "home-manager switch";
      claude = "claude --dangerously-skip-permissions";
    };

    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "main";
          hash = "sha256-998rYEyYD67XleSDbqvnQptRrGuG2N2AgFvTpFWvoV8=";
        };
      }
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "master";
      };
      user = {
        name = "anishalle";
        email = "anish.alle11@gmail.com";
      };
      github = {
        user = "anishalle";
      };
    };
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
