# talos custom kernel stuff

```sh
podman run --rm -d --name buildkitd --privileged docker.io/moby/buildkit
```

Use the TUI to change the kernel build config. Remember to save.

```sh
buildctl --addr=podman-container://buildkitd build --frontend dockerfile.v0 --local context=. --local dockerfile=. --opt filename=Pkgfile --opt target=kernel-prepare --output type=oci --export-cache type=inline --import-cache type=inline | podman load
podman tag SOMETHING kernel-prepare
podman run -e PATH=/toolchain/bin:/bin -w /src -v ./kernel/build/config-amd64:/src/.config --rm -it kernel-prepare bash -c 'mkdir /tmp && make menuconfig'
```

Build kernel image. This takes a while.

```sh
buildctl --addr=podman-container://buildkitd build --frontend dockerfile.v0 --local context=. --local dockerfile=. --opt filename=Pkgfile --opt target=kernel --output type=oci --export-cache type=inline --import-cache type=inline | podman load
podman tag SOMETHING ghcr.io/astra137/talos-kernel:5.15.16-alx
podman push ghcr.io/astra137/talos-kernel:5.15.16-alx
```

Build installer image.

```sh
podman build --build-arg RM="/lib/modules" --squash -t ghcr.io/astra137/talos-installer .
podman push ghcr.io/astra137/talos-installer
```

Build installer ISO.

```sh
mkdir out
podman run --rm -v ./out:/out ghcr.io/astra137/talos-installer iso
```

Clean up.

```sh
podman image prune
podman volume prune
```
