# Devbox image: nix + the ani-container home-manager config, pre-baked.
#
# Build:  docker build -t ghcr.io/anishalle/devbox .
# Run:    docker run -it ghcr.io/anishalle/devbox
#
# The home config is built at image-build time so `docker run` drops you
# into your shell instantly. To pull the latest config from inside a
# running container:  home-manager switch --flake github:anishalle/nix#ani-container
FROM nixos/nix:latest

RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

COPY . /root/nix
RUN nix build --no-link /root/nix#homeConfigurations.ani-container.activationPackage

ENTRYPOINT ["/root/nix/docker/entrypoint.sh"]
