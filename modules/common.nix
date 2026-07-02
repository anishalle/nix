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

    ### cloud / infra
    rclone


    ### C build toolchain (per-project shells cover this remotely)
    cmake
    meson
    automake
    texinfo

    ### misc
    ffmpeg
    graphviz
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
  xdg.configFile."starship.toml".source = ../configs/starship.toml;

  # Unfree for ad-hoc CLI use (nix-env/nix-shell). Flake-based commands
  # (nix shell/run nixpkgs#...) instead need NIXPKGS_ALLOW_UNFREE=1 --impure;
  # packages inside this flake are covered by allowUnfree in flake.nix.
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }\n";

  # Out-of-store symlink: ~/.config/nvim -> ~/nix/configs/nvim stays writable,
  # so LazyVim can update lazy-lock.json/lazyvim.json in place and edits apply
  # without a rebuild. Relies on the repo living at ~/nix on every machine.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/configs/nvim";

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
      codex = "codex --yolo";
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
