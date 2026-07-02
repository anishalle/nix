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
RUN nix build --no-link /root/nix#homeConfigurations.ani-container.activationPackage

ENTRYPOINT ["/root/nix/docker/entrypoint.sh"]
