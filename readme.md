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

#bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki core --cidr <Your_Public_IPS>

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki helm

bash<(curl -Ls ${REPO}/install_docker_traefik.sh) -ki cilium
# bash chaosplus.sh -ki cilium_cidr
# --cidr xx.xx.xx.xx

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki istio

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki cert_manager

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki metrics_server

bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki openebs

// higress 2 好像不支持 gatewayAPI, 使用 Host+NodePort
bash <(curl -Ls ${REPO}/install_docker_traefik.sh) -ki higress \
--gateway false \
--istio true \
--host true \
--type NodePort


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
