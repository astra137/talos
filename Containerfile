FROM scratch AS customization
COPY --from=ghcr.io/astra137/talos-kernel:5.15.16-alx /lib/modules /lib/modules

FROM ghcr.io/talos-systems/installer:latest
ARG RM
COPY --from=ghcr.io/astra137/talos-kernel:5.15.16-alx /boot/vmlinuz /usr/install/${TARGETARCH}/vmlinuz
