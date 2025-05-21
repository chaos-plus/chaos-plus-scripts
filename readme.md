#

## Base Env

```bash

export GHPROXY=${GHPROXY:-https://ghfast.top/}

export REPO=${GHPROXY}https://raw.githubusercontent.com/chaos-plus/chaos-plus-scripts/refs/heads/main/

```
## Install CRPROXY

```bash

export CRPROXY=noproxy.top

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) --init
bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -si docker
bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -di crproxy --domain ${CRPROXY}

```

## Install K8S

```bash

export CRPROXY=noproxy.top
export DOMAIN=<Your_Domain>

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) --set linux_mirrors_auto

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) --init

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -si k8s_auto \
--installer sealos \
--cri k3s \
--k8s_version v1.29.9 \
--masters <Your_HOST_IP> \
--sshpwd <Your_SSH_Password>

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -si k8s_config

# bash <(curl -Ls ${REPO}/install_docker_traefik.sh) --set cr_mirrors_host \
# --mirrors ${CRPROXY}
bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -si k8s_cr_mirrors_registries \
--mirrors ${CRPROXY}

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki core --cidr <Your_Public_IPS>

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki frps \
--bind_route_rule frps.${DOMAIN} \
--dashboard_route_rule frps-ui.${DOMAIN} \
--http_route_rule frps-http.${DOMAIN} \
--tcp_route_rule frps-tcp.${DOMAIN}

```

## Uninstall K8S

```bash
bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -sr k8s_auto \
--sshpwd <Your_SSH_Password>

```
