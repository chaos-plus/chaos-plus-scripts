# Chaos Plus Scripts

> native, docker, k8s
## Env Setup

```bash
#!/bin/sh -e

if [ ! -n "$IPV4_WAN" ]; then
   export IPV4_WAN=$(curl -sfL ifconfig.me --silent --connect-timeout 5 --max-time 5)
fi
if [ ! -n "$IPV4_WAN" ]; then
   export IPV4_WAN=$(curl -sfL 4.ipw.cn --silent --connect-timeout 5 --max-time 5)
fi
if [ ! -n "$IPV4_WAN" ]; then
   export IPV4_WAN=$(curl -sfL https://api.ipify.org?format=text --silent --connect-timeout 5 --max-time 5)
fi

IPV4_LAN=$(ip -4 addr show |
    grep -v '127.0.0.1' |
    grep -v 'docker' |
    grep -v 'veth' |
    grep -v 'br-' |
    grep -v 'tun' |
    grep -v 'tap' |
    grep -v 'docker0' |
    grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' |
    head -n 1)

export CRPROXY=noproxy.top
export GHPROXY=https://gh.noproxy.top/

export DOMAIN="example.com"
export ACME_DNS="dnspod"
export ACME_DNS_ID="xxxx"
export ACME_DNS_KEY="****"

export SSHPWD="xxxx"

echo "--------------------------------------------------"
echo "ENV IPV4_WAN: ${IPV4_WAN}"
echo "ENV IPV4_LAN: ${IPV4_LAN}"
echo "ENV CRPROXY: ${CRPROXY}"
echo "ENV GHPROXY: ${GHPROXY}"
echo "ENV DOMAIN: ${DOMAIN}"
echo "ENV ACME_DNS: ${ACME_DNS}"
echo "ENV ACME_DNS_ID: ${ACME_DNS_ID}"
echo "ENV ACME_DNS_KEY: ${ACME_DNS_KEY}"
echo "ENV SSHPWD: ${SSHPWD}"
echo "--------------------------------------------------"

```

## Install crproxy for chinese user

> [https://github.com/chaos-plus/chaos-plus-proxy-scripts](https://github.com/chaos-plus/chaos-plus-proxy-scripts)


## Uninstall K8S

```bash
bash chaosplus.sh \
-sr k8s_auto \
-sr cri \
--sshpwd ${SSHPWD}
```


## Install K&S

```bash

bash chaosplus.sh --set linux_mirrors_auto

bash chaosplus.sh --init

mkdir -p /etc/containerd/certs.d

bash chaosplus.sh \
-set cr_mirrors_auto \
--schema https \
--mirrors ${CRPROXY}

# 1.28.11  1.29.9  1.30.5
bash chaosplus.sh -si k8s_auto \
--cri containerd \
--k8s_version v1.30.5 \
--masters ${IPV4_LAN} \
--external_ips ${IPV4_WAN} \
--sshpwd ${SSHPWD}

# bash chaosplus.sh -si k8s_config

bash chaosplus.sh \
-ki nodeport \
--range 80-60000

bash chaosplus.sh -ki helm

# 1.0.0 1.1.0 1.1.1 1.2.0 1.2.1 1.3.0
# 高版本会导致cilium gateway api 无法工作
# bash chaosplus.sh -kr gateway_api --version v1.2.0
bash chaosplus.sh -ki gateway_api --version v1.2.0

# 1.16.1  1.17.4
# bash chaosplus.sh -kr cilium
bash chaosplus.sh -ki cilium --cilium_version 1.17.0 \
--gateway_api true \
--gateway_host true
# bash chaosplus.sh -ki cilium --upgrade --cilium_version 1.17.0

bash chaosplus.sh -ki cert_manager

bash chaosplus.sh -ki metrics_server

bash chaosplus.sh -ki openebs

bash chaosplus.sh -ki acme \
--solver ${ACME_DNS} \
--secret_id ${ACME_DNS_ID} \
--secret_key ${ACME_DNS_KEY}

bash chaosplus.sh -ki gateway \
--domain ${DOMAIN}

# bash chaosplus.sh -kr kube_prometheus_stack
bash chaosplus.sh -ki kube_prometheus_stack \
--grafana_routes "grafana.${DOMAIN}" \
--tls_secret "${DOMAIN}-crt"

bash chaosplus.sh -ki frps \
--bind_routes "frps.${DOMAIN}" \
--dashboard_routes "frps-ui.${DOMAIN}" \
--http_routes "frp-http.${DOMAIN}" \
--tcp_routes "frp-tcp.${DOMAIN}" \
--tls_secret "${DOMAIN}-crt"

```

