# Chaos Plus Scripts

> native, docker, k8s

## Install crproxy for chinese user

> [https://github.com/chaos-plus/chaos-plus-proxy-scripts](https://github.com/chaos-plus/chaos-plus-proxy-scripts)


## Install K8S

```bash

export CRPROXY=noproxy.top
export GHPROXY=https://gh.noproxy.top/
export DOMAIN=<Your_Domain>
export REPO=${GHPROXY}https://raw.githubusercontent.com/chaos-plus/chaos-plus-scripts/refs/heads/main/

bash <(curl -Ls ${REPO}/chaosplus.sh) --set linux_mirrors_auto

bash <(curl -Ls ${REPO}/chaosplus.sh) --init

bash <(curl -Ls ${REPO}/chaosplus.sh) -si k8s_auto \
--cri k3s \
--k8s_version v1.29.9 \
--masters <Your_HOST_IP> \
--sshpwd <Your_SSH_Password>

bash <(curl -Ls ${REPO}/chaosplus.sh) -si k8s_config

# bash <(curl -Ls ${REPO}/chaosplus.sh) --set cr_mirrors_host \
# --mirrors ${CRPROXY}
bash <(curl -Ls ${REPO}/chaosplus.sh) -si k8s_cr_mirrors_registries \
--mirrors ${CRPROXY}

#bash <(curl -Ls ${REPO}/chaosplus.sh) -ki core --cidr <Your_Public_IPS>

bash <(curl -Ls ${REPO}/chaosplus.sh) -ki helm

bash<(curl -Ls ${REPO}/chaosplus.sh) -ki cilium
# bash chaosplus.sh -ki cilium --upgrade
# bash chaosplus.sh -ki cilium_cidr
# --cidr xx.xx.xx.xx,xx.xx.xx.xx

bash <(curl -Ls ${REPO}/chaosplus.sh) -ki istio

bash <(curl -Ls ${REPO}/chaosplus.sh) -ki cert_manager

bash <(curl -Ls ${REPO}/chaosplus.sh) -ki metrics_server

bash <(curl -Ls ${REPO}/chaosplus.sh) -ki openebs

# higress 2 好像不支持 gatewayAPI, 使用 Host+NodePort
bash <(curl -Ls ${REPO}/chaosplus.sh) -ki higress \
--gateway false \
--istio true \
--host true \
--type NodePort

# install frps
bash <(curl -Ls ${REPO}/chaosplus.sh) -ki frps \
--bind_routes frps.${DOMAIN} \
--dashboard_routes frps-ui.${DOMAIN} \
--http_routes frp-http.${DOMAIN},frp-xx.${DOMAIN} \
--tcp_routes frp-tcp.${DOMAIN}

```

## Uninstall K8S

```bash
bash <(curl -Ls ${REPO}/chaosplus.sh) -sr k8s_auto \
--sshpwd <Your_SSH_Password>
bash chaosplus.sh -sr cri
```
