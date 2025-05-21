#

## Install CRPROXY

```bash
export CRPROXY=<Your_Domain>

bash chaosplus.sh --init
bash chaosplus.sh -si docker
bash chaosplus.sh -di crproxy --domain ${CRPROXY}

```

## Install K&S

```bash

export DOMAIN=<Your_Domain>


bash chaosplus.sh --set linux_mirrors_auto

bash chaosplus.sh --init

bash chaosplus.sh -si k8s_auto \
--installer sealos \
--cri k3s \
--k8s_version v1.29.9 \
--masters <Your_HOST_IP> \
--sshpwd <Your_SSH_Password>

bash chaosplus.sh -si k8s_config

# bash chaosplus.sh --set cr_mirrors_host \
# --mirrors ${CRPROXY}
bash chaosplus.sh -si k8s_cr_mirrors_registries \
--mirrors ${CRPROXY}

bash chaosplus.sh -ki core --cidr <Your_Public_IPS>

bash chaosplus.sh -ki frps \
--bind_route_rule frps.${DOMAIN} \
--dashboard_route_rule frps-ui.${DOMAIN} \
--http_route_rule frps-http.${DOMAIN} \
--tcp_route_rule frps-tcp.${DOMAIN}

```

## Uninstall K8S

```bash
bash chaosplus.sh -sr k8s_auto \
--sshpwd <Your_SSH_Password>

```
