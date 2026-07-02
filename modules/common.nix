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
        # from nixpkgs: pinned by the flake lock, no hash to chase when
        # upstream's main branch moves
        name = "zsh-autocomplete";
        src = "${pkgs.zsh-autocomplete}/share/zsh-autocomplete";
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
      # ~/.config/git/config is read-only under home-manager, so
      # `gh auth setup-git` can't write this itself: declare it instead.
      credential."https://github.com".helper = "!gh auth git-credential";
    };
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
