# Devbox image: nix + the ani-container home-manager config, pre-baked.
#
# Build:  docker build -t ghcr.io/anishalle/devbox .
# Run:    docker run -it ghcr.io/anishalle/devbox
#
# The home config is built at image-build time so `docker run` drops you
# into your shell instantly. To pull the latest config from inside a
# running container:  home-manager switch --flake github:anishalle/nix#ani-container
FROM nixos/nix:latest

RUN { \
      echo "experimental-features = nix-command flakes"; \
      # cache.nixos.org downloads flake out under heavy parallelism on CI
      # runners: fewer connections, more retries, longer stall tolerance
      echo "http-connections = 12"; \
      echo "download-attempts = 10"; \
      echo "stalled-download-timeout = 90"; \
    } >> /etc/nix/nix.conf

COPY . /root/nix

# The base image pre-installs packages whose files collide with the
# home-manager profile (coreutils-full vs coreutils, git-minimal vs git,
# man-db via programs.man, wget): remove them, then activate the home
# config at build time so `docker run` starts fully set up.
RUN nix-env -e coreutils-full wget git-minimal man-db && \
    export USER=root HOME=/root && \
    "$(nix build --no-link --print-out-paths /root/nix#homeConfigurations.ani-container.activationPackage)/activate"

ENTRYPOINT ["/root/nix/docker/entrypoint.sh"]
