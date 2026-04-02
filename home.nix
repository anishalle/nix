{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ani";
  home.homeDirectory = "/Users/ani";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # NOTE: with pkgs makes it so you dont have to do pkgs.[package]. every time
  home.packages = with pkgs;[
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    ripgrep
    jq
    fzf
    bat
    htop


    ###NOTE: ### DEV
    git
    starship
    uv
    rustup
    zsh-autocomplete
    gh
    colima
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
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtraFirst = ''
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.config/emacs/bin:$PATH"
    '';
    initContent = ''
      if [ -x "$HOME/.local/bin/wo" ]; then
        source <("$HOME/.local/bin/wo" init zsh)
      fi
      '';

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
        };

      #plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)
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
        };
    };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ani/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
