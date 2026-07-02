# nix

One flake, every machine.

| Target | What | Apply with |
|---|---|---|
| `homeConfigurations.ani` | macOS (standalone home-manager) | `home-manager switch --flake .#ani` |
| `homeConfigurations.ani-linux-x86` / `-arm` | generic Linux devboxes (non-NixOS) | `home-manager switch --flake .#ani-linux-x86` |
| `homeConfigurations.ani-container-amd64` / `-arm64` | the Docker devbox image (runs as root, multi-arch) | baked in by `Dockerfile` |
| `nixosConfigurations.wsl` | NixOS-WSL: full system + home-manager as a NixOS module | `sudo nixos-rebuild switch --flake .#wsl` (alias: `update`) |

The repo lives at `~/nix` on every machine. On macOS,
`~/.config/home-manager` is a symlink to it so arg-less
`home-manager switch` (the `update` alias) keeps working:

```sh
git clone git@github.com:anishalle/nix.git ~/nix
ln -s ~/nix ~/.config/home-manager   # macOS only
```

## Layout

```
flake.nix                  targets above
modules/common.nix         cross-platform home config (packages, zsh, git, direnv, starship)
modules/darwin.nix         mac-only
modules/linux.nix          generic-linux-only (targets.genericLinux; NOT used on NixOS)
hosts/wsl/configuration.nix  NixOS-WSL system config (user ani, docker, sudo, flakes)
Dockerfile + docker/       ghcr devbox image
.github/workflows/         builds & pushes ghcr.io/anishalle/devbox on push to master
```

On WSL, `home.username` / `home.homeDirectory` are derived automatically from
the NixOS user — only darwin.nix / linux.nix hardcode home paths, for the
standalone home-manager targets.

## Docker devbox

```sh
docker run -it ghcr.io/anishalle/devbox
```

Config is pre-baked at image build for instant start. To sync a running
container to the latest pushed config:

```sh
home-manager switch --flake github:anishalle/nix#ani-container-amd64   # or -arm64
```

## Flake gotcha

New files must be `git add`ed before nix can see them, or you get
"path does not exist" during rebuild.
