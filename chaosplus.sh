#!/bin/sh
set -e
###################################################################################################
#
# env
#
###################################################################################################


LANG=en_US.UTF-8

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
BBLUE='\033[0;34m'
PLAIN='\033[0m'
RESET="\033[0m"

NOTE="[${BLUE}NOTE${RESET}]"
INFO="[${GREEN}INFO${RESET}]"
WARN="[${YELLOW}WARN${RESET}]"
ERROR="[${RED}ERROR${RESET}]"

RED() { echo -e "\033[31m\033[01m$1\033[0m"; }
GREEN() { echo -e "\033[32m\033[01m$1\033[0m"; }
YELLOW() { echo -e "\033[33m\033[01m$1\033[0m"; }
BLUE() { echo -e "\033[36m\033[01m$1\033[0m"; }

WHITE() { echo -e "\033[37m\033[01m$1\033[0m"; }
READP() { read -p "$(YELLOW "$1")" $2; }

NOTE() { echo -e "${NOTE} ${1}"; }
INFO() { echo -e "${INFO} ${1}"; }
WARN() { echo -e "${WARN} ${1}"; }
ERROR() { echo -e "${ERROR} ${1}"; }


PM() {
    if command -v apt &>/dev/null; then
        apt $@
    elif command -v apt-get &>/dev/null; then
        apt-get $@
    elif command -v yum &>/dev/null; then
        yum $@
    elif command -v pacman &>/dev/null; then
        pacman $@
    elif command -v dnf &>/dev/null; then
        dnf $@
    elif command -v snap &>/dev/null; then
        snap $@
    elif command -v yay &>/dev/null; then
        yay $@
    elif command -v zypper &>/dev/null; then
        zypper $@
    elif command -v brew &>/dev/null; then
        brew $@
    elif command -v flatpak &>/dev/null; then
        flatpak $@
    elif command -v port &>/dev/null; then
        port $@
    elif command -v conda &>/dev/null; then
        conda $@
    elif command -v nix &>/dev/null; then
        nix $@
    else
        echo "Package manager not supported on this system."
    fi
}

pm_install_one() {
    local package_name="$1"
    # 判断系统并选择合适的包管理器
    if command -v apt &>/dev/null; then
        # 使用 apt
        if apt search "$package_name" | grep -q "$package_name"; then
            echo "Installing $package_name using apt."
            sudo apt install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in apt repository."
        fi
    fi

    if command -v apt-get &>/dev/null; then
        # 使用 apt-get
        if apt-cache search "$package_name" | grep -q "$package_name"; then
            echo "Installing $package_name using apt-get."
            sudo apt-get install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in apt-get repository."
        fi
    fi

    if command -v yum &>/dev/null; then
        # 使用 yum
        if yum list available "$package_name" &>/dev/null; then
            echo "Installing $package_name using yum."
            sudo yum install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in yum repository."
        fi
    fi

    if command -v pacman &>/dev/null; then
        # 使用 pacman
        if pacman -Ss "$package_name" | grep -q "$package_name"; then
            echo "Installing $package_name using pacman."
            sudo pacman -S --noconfirm "$package_name"
            return
        else
            echo "Package '$package_name' not found in pacman repository."
        fi
    fi

    if command -v dnf &>/dev/null; then
        # 使用 dnf
        if dnf list available "$package_name" &>/dev/null; then
            echo "Installing $package_name using dnf."
            sudo dnf install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in dnf repository."
        fi
    fi

    if command -v snap &>/dev/null; then
        # 使用 snap
        if snap info "$package_name" &>/dev/null; then
            echo "Installing $package_name using snap."
            sudo snap install "$package_name"
            return
        else
            echo "Package '$package_name' not found in snap repository."
        fi
    fi

    if command -v yay &>/dev/null; then
        # 使用 yay
        if yay -Ss "$package_name" | grep -q "$package_name"; then
            echo "Installing $package_name using yay."
            yay -S --noconfirm "$package_name"
            return
        else
            echo "Package '$package_name' not found in yay repository."
        fi
    fi

    if command -v zypper &>/dev/null; then
        # 使用 zypper
        if zypper search "$package_name" &>/dev/null; then
            echo "Installing $package_name using zypper."
            sudo zypper install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in zypper repository."
        fi
    fi

    if command -v brew &>/dev/null; then
        # 使用 brew
        if brew search "$package_name" &>/dev/null; then
            echo "Installing $package_name using brew."
            brew install "$package_name"
            return
        else
            echo "Package '$package_name' not found in brew repository."
        fi
    fi

    if command -v flatpak &>/dev/null; then
        # 使用 flatpak
        if flatpak search "$package_name" &>/dev/null; then
            echo "Installing $package_name using flatpak."
            sudo flatpak install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in flatpak repository."
        fi
    fi

    if command -v port &>/dev/null; then
        # 使用 port
        if port search "$package_name" &>/dev/null; then
            echo "Installing $package_name using port."
            sudo port install "$package_name"
            return
        else
            echo "Package '$package_name' not found in port repository."
        fi
    fi

    if command -v conda &>/dev/null; then
        # 使用 conda
        if conda search "$package_name" &>/dev/null; then
            echo "Installing $package_name using conda."
            conda install -y "$package_name"
            return
        else
            echo "Package '$package_name' not found in conda repository."
        fi
    fi

    if command -v nix &>/dev/null; then
        # 使用 nix
        if nix search "$package_name" &>/dev/null; then
            echo "Installing $package_name using nix."
            nix-env -i "$package_name"
            return
        else
            echo "Package '$package_name' not found in nix repository."
        fi
    fi

    echo "Package manager not supported on this system."
}

pm_uninstall_one() {
    local package_name="$1"

    # 判断系统并选择合适的包管理器进行卸载
    if command -v apt &>/dev/null; then
        sudo apt remove --purge -y "$package_name" || true
    elif command -v apt-get &>/dev/null; then
        # 使用 apt-get
        sudo apt-get remove --purge -y "$package_name" || true
    elif command -v yum &>/dev/null; then
        # 使用 yum
        sudo yum remove -y "$package_name" || true
    elif command -v pacman &>/dev/null; then
        # 使用 pacman
        sudo pacman -R --noconfirm "$package_name" || true
    fi

    if command -v dnf &>/dev/null; then
        # 使用 dnf
        sudo dnf remove -y "$package_name" || true
    fi

    if command -v snap &>/dev/null; then
        # 使用 snap
        sudo snap remove "$package_name" --purge || true
    fi

    if command -v yay &>/dev/null; then
        # 使用 yay
        sudo yay -R --noconfirm "$package_name" || true
    fi

    if command -v zypper &>/dev/null; then
        # 使用 zypper
        sudo zypper remove -y "$package_name" || true
    fi

    if command -v brew &>/dev/null; then
        # 使用 brew
        sudo brew uninstall "$package_name" || true
    fi

    if command -v flatpak &>/dev/null; then
        # 使用 flatpak
        sudo flatpak uninstall "$package_name" || true
    fi

    if command -v port &>/dev/null; then
        # 使用 port
        sudo port uninstall "$package_name" || true
    fi

    if command -v conda &>/dev/null; then
        # 使用 conda
        sudo conda remove "$package_name" || true
    fi

    if command -v nix &>/dev/null; then
        # 使用 nix
        sudo nix-env -e "$package_name" || true
    fi

}

pm_install() {
    for package_name in $@; do
        pm_install_one "$package_name"
    done
}

pm_uninstall() {
    for package_name in $@; do
        pm_uninstall_one "$package_name"
    done
    hash -r
}

if [ "$(PM -v)" == 'not supported.' ]; then
    ERROR "脚本不支持当前的系统，请选择使用Ubuntu,Debian,Centos系统。" && exit
fi

INFO "ENV PM: $(PM -v)"

TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3}')
INFO "ENV TIMEZONE: ${TIMEZONE}"

VIRT=$(systemd-detect-virt)
INFO "ENV VIRT: ${VIRT}"

get_os_info() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_NAME="${ID^}"
        OS_VERSION="${VERSION_ID}"
    elif grep -q -i "alpine" /etc/issue; then
        OS_NAME="Alpine"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "debian" /etc/issue; then
        OS_NAME="Debian"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "ubuntu" /etc/issue; then
        OS_NAME="Ubuntu"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "centos|red hat|redhat" /etc/issue; then
        OS_NAME="Centos"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "arch" /etc/issue; then
        OS_NAME="Arch Linux"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "opensuse" /etc/issue; then
        OS_NAME="openSUSE"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "fedora" /etc/issue; then
        OS_NAME="Fedora"
        OS_VERSION=$(awk '{print $2}' /etc/issue)
    elif grep -q -i "debian" /proc/version; then
        OS_NAME="Debian"
        OS_VERSION=$(awk '{print $3}' /proc/version)
    elif grep -q -i "ubuntu" /proc/version; then
        OS_NAME="Ubuntu"
        OS_VERSION=$(awk '{print $3}' /proc/version)
    elif grep -q -i "centos|red hat|redhat" /proc/version; then
        OS_NAME="Centos"
        OS_VERSION=$(awk '{print $3}' /proc/version)
    elif grep -q -i "arch" /proc/version; then
        OS_NAME="Arch Linux"
        OS_VERSION=$(awk '{print $3}' /proc/version)
    elif grep -q -i "opensuse" /proc/version; then
        OS_NAME="openSUSE"
        OS_VERSION=$(awk '{print $3}' /proc/version)
    elif grep -q -i "fedora" /proc/version; then
        OS_NAME="Fedora"
        OS_VERSION=$(awk '{print $3}' /proc/version)
    else
        OS_NAME="Unknown"
        OS_VERSION="Unknown"
    fi

    if [[ "$OS_NAME" == "Unknown" || "$OS_VERSION" == "Unknown" ]]; then
        ERROR "Unknown OS. Please use Ubuntu, Debian, CentOS, openSUSE, Arch Linux" && exit 1
    fi

    echo "$OS_NAME $OS_VERSION"
}

OS_INFO=$(get_os_info)
OS_NAME=$(echo "$OS_INFO" | cut -d' ' -f1)
OS_VERSION=$(echo "$OS_INFO" | cut -d' ' -f2)

INFO "ENV OS_INFO: $OS_INFO"
INFO "ENV OS_NAME: ${OS_NAME}"
INFO "ENV OS_VERSION: ${OS_VERSION}"

LANG=en_US.UTF-8
TEMP=${TEMP:-/opt/tmp}
DATA=${DATA:-/opt/data}

INFO "ENV LANG: ${LANG}"
INFO "ENV DATA: ${DATA}"
INFO "ENV TEMP: ${TEMP}"

# 获取第一个有效的 IPv4 地址，排除回环地址和虚拟网卡的地址
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
INFO "ENV IPV4_LAN: ${IPV4_LAN}"

if [ ! -n "$IPV4_WAN" ]; then
    IPV4_WAN=$(curl -sfL ifconfig.me --silent --connect-timeout 5 --max-time 5)
fi
if [ ! -n "$IPV4_WAN" ]; then
    IPV4_WAN=$(curl -sfL 4.ipw.cn --silent --connect-timeout 5 --max-time 5)
fi
if [ ! -n "$IPV4_WAN" ]; then
    IPV4_WAN=$(curl -sfL https://api.ipify.org?format=text --silent --connect-timeout 5 --max-time 5)
fi
INFO "ENV IPV4_WAN: ${IPV4_WAN}"

PING_GCR=$(curl -Is http://gcr.io --silent --connect-timeout 2 --max-time 2 | head -n 1)
if echo "$PING_GCR" | grep -q "HTTP/1.1 200 OK"; then
    HAS_GCR="true"
elif echo "$PING_GCR" | grep -q "HTTP/1.1 301 Moved Permanently"; then
    HAS_GCR="true"
else
    HAS_GCR=""
fi
INFO "ENV HAS_GCR: ${HAS_GCR:-"false"}"

PING_GOOGLE=$(curl -Is http://google.com --silent --connect-timeout 2 --max-time 2 | head -n 1)
if echo "$PING_GOOGLE" | grep -q "HTTP/1.1 200 OK"; then
    HAS_GOOGLE="true"
elif echo "$PING_GOOGLE" | grep -q "HTTP/1.1 301 Moved Permanently"; then
    HAS_GOOGLE="true"
else
    HAS_GOOGLE=""
fi
INFO "ENV HAS_GOOGLE: ${HAS_GOOGLE:-"false"}"

GHPROXY=${GHPROXY:-https://ghfast.top/}
INFO "ENV GHPROXY: ${GHPROXY}"
CRPROXY=${CRPROXY:-kubesre.xyz}
INFO "ENV CRPROXY: ${CRPROXY}"

# https://github.com/labring-actions/cluster-image-docs/blob/main/docs/aliyun-shanghai/rootfs.md
# https://github.com/labring-actions/cluster-image-docs/blob/main/docs/aliyun-shanghai/apps.md
labring_image_registry=${LABRING_IMAGE_REGISTRY:-registry.cn-shanghai.aliyuncs.com}
labring_image_repository=${LABRING_IMAGE_REPOSITORY:-labring}

INFO "ENV LABRING_IMAGE_REGISTRY: ${labring_image_registry}"
INFO "ENV LABRING_IMAGE_REPOSITORY: ${labring_image_repository}"

getarg() {
    local __name=$1
    shift # 去掉第一个参数（即参数名称），剩下的是参数列表
    local __value=""
    local __start=false
    for arg in "$@"; do
        if [[ $arg =~ ^- ]]; then   # 如果是选项参数（以 - 开头）
            local _key="${arg//-/}" # 去掉 - 符号
            if [[ "$_key" == "$__name" ]]; then
                __start=true # 开始收集值
            else
                __start=false # 停止收集值
            fi
        fi

        if [[ ! $arg =~ ^- && $__start == true ]]; then
            __value="$__value $arg" # 收集值
        fi
    done
    echo $__value # 输出收集到的值
}

hasarg() {
    local __name=$1
    shift # 去掉第一个参数（即参数名称），剩下的是参数列表
    local __value=""
    local __start=false
    local __has=false
    for arg in "$@"; do
        if [[ $arg =~ ^- ]]; then   # 如果是选项参数（以 - 开头）
            local _key="${arg//-/}" # 去掉 - 符号
            if [[ "$_key" == "$__name" ]]; then
                __start=true # 开始收集值
                __has=true
                break
            else
                __start=false # 停止收集值
            fi
        fi
    done
    echo $__has
}

TOKEN=$(getarg token $@)
TOKEN=${TOKEN:-Pa44VV0rd14VVrOng}
INFO "ENV TOKEN: ${TOKEN}"

CLUSTER=$(getarg cluster $@)
CLUSTER=${CLUSTER:-default}
INFO "ENV CLUSTER: ${CLUSTER}"

add_crontab() {
    crontab -l | {
        cat
        echo "$@"
    } | crontab -
    crontab -l
}

remove_crontab() {
    crontab -l | grep -v "$@" | crontab -
    crontab -l
}

start_timer() {
    local name=$1
    sudo systemctl daemon-reload      # 重新加载 systemd 配置
    sudo systemctl enable $name.timer # 启用定时任务
    sudo systemctl start $name.timer  # 启动定时任务
}

stop_timer() {
    local name=$1
    sudo systemctl disable $name.timer # 禁用定时任务
    sudo systemctl stop $name.timer    # 停止定时任务
}

add_env() {
    local env_path=$1
    local new_path="export PATH=\$PATH:$1"
    if [ -z "$env_path" ]; then
        ERROR "add env failed for empty path"
        exit 1
    fi
    if [ ! -d "$env_path" ]; then
        mkdir -p "$env_path"
    fi
    for profile_file in ~/.bashrc ~/.profile ~/.bash_profile ~/.zshrc; do
        if [ -f "$profile_file" ] && ! grep -q "$env_path" "$profile_file"; then
            INFO "Adding env [$env_path] to [$profile_file]"
            echo "$new_path" >>"$profile_file"
        else
            INFO "Env [$env_path] already exists in [$profile_file]"
        fi
    done
}

# add_sshpass name ips pwd
add_sshpass() {
    node=$1
    ips=$2
    ips=$(echo ${ips[@]} | tr ',' ' ')
    pwd=$3

    if [ -z "$node" ]; then
        ERROR "add ssh host failed for missing $node"
        exit 1
    fi

    if [ -z "$ips" ]; then
        ERROR "add ssh host failed for missing ips"
        exit 1
    fi

    if [ -z "$pwd" ]; then
        ERROR "add ssh host failed for missing password"
        exit 1
    fi

    idx=0
    for ip in $ips; do
        idx=$(expr $idx + 1)
        hst=${node}-${idx}
        echo "------- add ssh host '$hst' '$ip' '$pwd'"
        sshpass -p "${pwd}" ssh -o stricthostkeychecking=no root@${ip} "hostnamectl set-hostname $hst"
        sshpass -p "${pwd}" ssh -o stricthostkeychecking=no root@${ip} "echo -e '#\n127.0.0.1 localhost $hst\n#\n' >> /etc/hosts"
        sshpass -p "${pwd}" ssh -o stricthostkeychecking=no root@${ip} 'rm -rf ~/.ssh/*'
        sshpass -p "${pwd}" ssh -o stricthostkeychecking=no root@${ip} 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -C "ansible cluster"'
        echo "------- ssh key gen '$hst' '$ip'"
        sshpass -p "${pwd}" ssh-copy-id -o stricthostkeychecking=no root@${ip}
    done
}

# get_html_version url regex
get_html_version() {
    echo $(curl -sfL $1 | grep -oP $2 | head -n 1)
}

get_github_release_version() {
    local repo=$1
    if [[ $repo =~ releases/latest ]]; then
        local url="https://api.github.com/repos/$repo"
    else
        local url="https://api.github.com/repos/$repo/releases/latest"
    fi
    echo $(curl -sfL $url | grep -oE '"tag_name": "[^"]+"' | head -n1 | cut -d'"' -f4)
}

# https://github.com/labring-actions/cluster-image-docs/blob/main/docs/aliyun-shanghai/rootfs.md
# https://github.com/labring-actions/cluster-image-docs/blob/main/docs/aliyun-shanghai/apps.md
get_sealos_release_version() {
    local v_rootfs=$(get_html_version ${GHPROXY}https://raw.githubusercontent.com/labring-actions/cluster-image-docs/refs/heads/main/docs/aliyun-shanghai/rootfs.md "(?<=/${1}:)[^\])]+")
    if [ -n "$v_rootfs" ]; then
        echo $v_rootfs
    fi
    local v_apps=$(get_html_version ${GHPROXY}https://raw.githubusercontent.com/labring-actions/cluster-image-docs/refs/heads/main/docs/aliyun-shanghai/apps.md "(?<=/${1}:)[^\])]+")
    if [ -n "$v_apps" ]; then
        echo $v_apps
    fi
}

###################################################################################################
#
# init
#
###################################################################################################

init() {

    # 检查并更新 apt 系统
    if command -v apt &>/dev/null; then
        echo "Updating and upgrading packages using apt"
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt autoremove -y
    fi

    # 检查并更新 apt-get 系统
    if command -v apt-get &>/dev/null; then
        echo "Updating and upgrading packages using apt-get"
        sudo apt-get update -y
        sudo apt-get upgrade -y
        sudo apt-get autoremove -y
    fi

    # 检查并更新 yum 系统
    if command -v yum &>/dev/null; then
        echo "Updating and upgrading packages using yum"
        sudo yum update -y
        sudo yum install epel-release -y
        sudo yum autoremove -y
    fi

    # 检查并更新 pacman 系统
    if command -v pacman &>/dev/null; then
        echo "Updating and upgrading packages using pacman"
        sudo pacman -Syu --noconfirm
        sudo pacman -Rns $(pacman -Qdtq)
    fi

    # 检查并更新 dnf 系统
    if command -v dnf &>/dev/null; then
        echo "Updating and upgrading packages using dnf"
        dnf install dnf
        sudo dnf update -y
        sudo dnf autoremove -y
    fi

    # 检查并更新 zypper 系统
    if command -v zypper &>/dev/null; then
        echo "Updating and upgrading packages using zypper"
        sudo zypper refresh -y
        sudo zypper update -y
        sudo zypper remove --clean-deps $(zypper packages --orphaned -t package | awk '{print $3}')
    fi

    # 检查并更新 brew 系统
    if command -v brew &>/dev/null; then
        echo "Updating and upgrading packages using brew"
        brew update
        brew upgrade
        brew cleanup
    fi

    # 检查并更新 flatpak 系统
    if command -v flatpak &>/dev/null; then
        echo "Updating and upgrading packages using flatpak"
        sudo flatpak update -y
    fi

    # 检查并更新 port 系统
    if command -v port &>/dev/null; then
        echo "Updating and upgrading packages using port"
        sudo port selfupdate
        sudo port upgrade outdated
    fi

    # 检查并更新 conda 系统
    if command -v conda &>/dev/null; then
        echo "Updating and upgrading packages using conda"
        conda update --all -y
    fi

    # 检查并更新 nix 系统
    if command -v nix &>/dev/null; then
        echo "Updating and upgrading packages using nix"
        nix-channel --update
        nix-env -u '*'
    fi

    # 如果没有找到支持的包管理器
    if ! (command -v apt &>/dev/null || command -v apt-get &>/dev/null || command -v yum &>/dev/null || command -v pacman &>/dev/null || command -v dnf &>/dev/null || command -v zypper &>/dev/null || command -v brew &>/dev/null || command -v flatpak &>/dev/null || command -v port &>/dev/null || command -v conda &>/dev/null || command -v nix &>/dev/null); then
        echo "No supported package manager found on this system."
    fi

    INFO "----------------------------------------------------------"
    INFO "setup system start"
    INFO "----------------------------------------------------------"

    # 设置 swap 为 0 并关闭 swap
    if ! grep -q 'vm.swappiness = 0' /etc/sysctl.conf; then
        echo "vm.swappiness = 0" >>/etc/sysctl.conf
    fi
    swapoff -a && swapon -a
    sysctl -p

    # 关闭 firewalld 服务
    INFO "Stopping and disabling firewalld"
    sudo systemctl stop firewalld.service 2>/dev/null || true
    sudo systemctl disable firewalld.service 2>/dev/null || true
    sudo systemctl status firewalld.service 2>/dev/null || true

    # 配置 transparent hugepages
    INFO "Disabling transparent hugepages"
    echo never >/sys/kernel/mm/transparent_hugepage/enabled
    echo never >/sys/kernel/mm/transparent_hugepage/defrag
    cat /sys/kernel/mm/transparent_hugepage/enabled


    SYSCTL_CONF="/etc/sysctl.conf"

    add_sysctl_param() {
        local param="$1"
        local value="$2"
        if ! grep -q "^${param} *= *" "$SYSCTL_CONF"; then
            echo "${param} = ${value}" >> "$SYSCTL_CONF"
        fi
    }

    # 添加常规参数（逐个判断）
    add_sysctl_param "fs.file-max" 1000000
    add_sysctl_param "net.core.somaxconn" 32768
    add_sysctl_param "net.ipv4.tcp_syncookies" 0
    add_sysctl_param "vm.overcommit_memory" 1
    add_sysctl_param "vm.swappiness" 0

    # 获取主版本+次版本号（如 4.15）
    kernel_version=$(uname -r | cut -d'-' -f1 | cut -d'.' -f1-2)

    # 判断是否支持 net.ipv4.tcp_tw_recycle（< 4.12 的老内核才支持）
    if [[ $(echo "$kernel_version < 4.12" | bc -l) -eq 1 ]]; then
        # 检查内核是否支持该参数
        if sysctl -a 2>/dev/null | grep -q "net.ipv4.tcp_tw_recycle"; then
            add_sysctl_param "net.ipv4.tcp_tw_recycle" 0
        fi
    fi

    # 应用配置
    sysctl -p || true

    # 设置文件描述符限制
    if ! grep -q 'root.*nofile.*1000000' /etc/security/limits.conf; then
        cat <<EOF >>/etc/security/limits.conf
root           soft    nofile         1000000
root           hard    nofile         1000000
root           soft    stack          32768
root           hard    stack          32768
EOF
    fi

    # 加载 br_netfilter 模块，并写入 sysctl 配置
    INFO "Configuring bridge-nf parameters and sysctl tuning"
    modprobe br_netfilter

    local K8S_SYSCTL_CONF="/etc/sysctl.d/k8s.conf"
    cat <<EOF >"$K8S_SYSCTL_CONF"
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.core.somaxconn = 32768
vm.swappiness = 0
net.ipv4.tcp_syncookies = 0
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
fs.file-max = 1000000
fs.inotify.max_user_watches = 1048576
fs.inotify.max_user_instances = 1024
net.ipv4.conf.all.rp_filter = 1
net.ipv4.neigh.default.gc_thresh1 = 80000
net.ipv4.neigh.default.gc_thresh2 = 90000
net.ipv4.neigh.default.gc_thresh3 = 100000
EOF
    sysctl --system

    INFO "----------------------------------------------------------"
    INFO "setup system done"
    INFO "----------------------------------------------------------"

    INFO "----------------------------------------------------------"
    INFO "install tool start"
    INFO "----------------------------------------------------------"

    # 使用 pm_install 统一安装所有工具包
    local packages=(
        curl wget git vim expect openssl iptables python3 qrencode tar zip unzip sed xxd
        pwgen ntp ntpdate ntpstat jq sshpass neofetch irqbalance linux-cpupower systemd rsyslog fail2ban
        snapd net-tools dnsutils cron apache2-utils bind-utils cronie httpd-tools inetutils
    )
    for package in "${packages[@]}"; do
        pm_install "$package" 2>/dev/null || true
    done

    if command -v fail2ban &>/dev/null; then
        sudo systemctl enable --now fail2ban
        sudo systemctl start fail2ban
    fi

    if command -v snapd &>/dev/null; then
        sudo systemctl enable --now snapd.socket
        sudo systemctl enable snapd
        sudo systemctl start snapd
    fi

    add_env "/snap/bin"

    if command -v git &>/dev/null; then
        git config --global credential.helper store
    fi

    # # 配置防火墙规则
    # iptables -P INPUT ACCEPT
    # iptables -P FORWARD ACCEPT
    # iptables -P OUTPUT ACCEPT
    # iptables -F
    # iptables --flush
    # iptables -tnat --flush

    if command -v neofetch &>/dev/null; then
        local MOTD=/etc/motd
        echo -e "" >$MOTD
        echo -e "\e[31m**********************************\e[0m" >>$MOTD
        echo -e "\e[33m\e[05m⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎\e[0m" >>$MOTD
        echo -e "\e[31m正式环境, 数据无价, 谨慎操作\e[0m" >>$MOTD
        echo -e "\e[33m\e[05m⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎⚠︎⚠︎⚠️⚠️⚠️⚠︎\e[0m" >>$MOTD
        echo -e "\e[31m**********************************\e[0m" >>$MOTD
        echo -e "" >>$MOTD
        local NEOFETCH=/etc/profile.d/neofetch.sh
        echo '' >$NEOFETCH
        echo 'echo "" ' >>$NEOFETCH
        echo 'neofetch' >>$NEOFETCH
        echo 'echo -e "\e[35mIPV4 WAN: \e[36m`curl ifconfig.me --silent`"' >>$NEOFETCH
        echo 'echo -e "\e[31m**********************************" ' >>$NEOFETCH
        echo 'echo -e "\e[0m" ' >>$NEOFETCH
        echo '' >>$NEOFETCH
    fi

    if command -v ntpd &>/dev/null; then
        sudo systemctl start ntpsec || true
        sudo systemctl start ntpd || true
        sudo systemctl enable ntpd || true
        sudo systemctl enable ntpsec || true
    #   sudo systemctl status ntpd
    fi

    if command -v irqbalance &>/dev/null; then
        sudo systemctl enable irqbalance
        sudo systemctl start irqbalance
    fi

    if command -v cpupower &>/dev/null; then
        sudo modprobe acpi_cpufreq || true
        sudo cpupower frequency-set --governor performance || true
    fi

    INFO "----------------------------------------------------------"
    INFO "install tool done"
    INFO "----------------------------------------------------------"

}

###################################################################################################
#
# system
#
###################################################################################################

system_install_golang() {
    if command -v apt &>/dev/null; then
        apt install golang
    elif command -v snap &>/dev/null; then
        snap install go --classic
    elif command -v brew &>/dev/null; then
        brew install go
    else
        local GO_VERSION=$(get_html_version https://go.dev/dl/ 'go[0-9\.]+\.linux-amd64.tar.gz')
        wget -O /tmp/$GO_VERSION "https://go.dev/dl/$GO_VERSION"
        rm -rf /usr/local/go
        tar -C /usr/local -xzf /tmp/$GO_VERSION
        add_env "/usr/local/go/bin"
        rm -f /tmp/$GO_VERSION
    fi
    if ! command -v go &>/dev/null; then
        ERROR "Golang installation failed."
        exit 1
    fi
    if command -v go &>/dev/null; then
        go version
        go env -w GO111MODULE=on
        go env -w GOPROXY=https://goproxy.cn,direct
    fi
}

system_install_java() {
    curl -sfL "https://get.sdkman.io" | bash
    source "/root/.sdkman/bin/sdkman-init.sh"
    # sdk list java
    sdk install java
    if ! command -v java &>/dev/null; then
        ERROR "java installation failed."
        exit 1
    fi
    java -version
}

system_install_python() {
    pm_install python3
}

system_install_nodejs() {
    # https://github.com/Schniz/fnms
    local node_version=$(getarg node_version $@)
    node_version=${node_version:-'22'}

    if command -v brew &>/dev/null; then
        brew install fnm
    elif command -v scoop &>/dev/null; then
        scoop install fnm
    elif command -v choco &>/dev/null; then
        choco install fnm
    elif command -v cargo &>/dev/null; then
        cargo install fnm
    elif command -v winget &>/dev/null; then
        winget install Schniz.fnm
    # else
    #     curl -sfL https://fnm.vercel.app/install | bash
    fi
    if ! command -v fnm &>/dev/null; then
        local VERSION=$(get_github_release_version "nvm-sh/nvm/releases/latest")
        curl -sfL ${GHPROXY}https://raw.githubusercontent.com/nvm-sh/nvm/${VERSION}/install.sh | bash
    fi
    source ~/.bashrc 2>/dev/null || true
    if command -v fnm &>/dev/null; then
        fnm install $node_version
    elif command -v nvm &>/dev/null; then
        nvm install $node_version
    elif command -v snap &>/dev/null; then
        snap install node --classic
    elif command -v brew &>/dev/null; then
        brew install node@$node_version
    fi
    if ! command -v node &>/dev/null; then
        ERROR "node installation failed."
        exit 1
    fi
}

system_install_rustlang() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    if command -v rustc &>/dev/null; then
        rustc --version
    else
        ERROR "Rust installation failed."
        exit 1
    fi
}

system_install_k8slens() {
    if command -v snap &>/dev/null; then
        sudo snap install kontena-lens --classic
    elif command -v apt &>/dev/null; then
        curl -sfL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg >/dev/null
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | sudo tee /etc/apt/sources.list.d/lens.list >/dev/null
        sudo apt update
        sudo apt install lens
    elif command -v dnf &>/dev/null; then
        sudo dnf config-manager --add-repo https://downloads.k8slens.dev/rpm/lens.repo
        sudo dnf install lens
    elif command -v yum &>/dev/null; then
        sudo yum-config-manager --add-repo https://downloads.k8slens.dev/rpm/lens.repo
        sudo yum install lens
    fi
}

system_install_vscode() {
    if command -v apt &>/dev/null; then
        sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        rm -f packages.microsoft.gpg
        sudo apt install apt-transport-https
        sudo apt update
        sudo apt install code # or code-insiders
    elif command -v yum &>/dev/null; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
        yum check-update
        sudo yum install code # or code-insiders
    elif command -v snap &>/dev/null; then
        sudo snap install code --classic
    elif command -v nix-env &>/dev/null; then
        nix-env -i vscode
    elif command -v zypper &>/dev/null; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo >/dev/null
        zypper refresh
        sudo zypper install code # or code-insiders
    fi
}

system_install_windsurf() {
    if command -v apt-get &>/dev/null; then
        curl -sfL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list >/dev/null
        sudo apt-get update
        sudo apt-get upgrade windsurf
    fi
}

system_install_ansible() {
    INFO "----------------------------------------------------------"
    INFO "install ansible start"
    INFO "----------------------------------------------------------"

    mkdir -p /etc/ansible/
    cat <<EOF >/etc/ansible/ansible.cfg
[defaults]
host_key_checking = False
vars_plugins_enabled = host_group_vars
[vars_host_group_vars]
stage = inventory
EOF
    cat /etc/ansible/ansible.cfg

    pm_install ansible

    INFO "----------------------------------------------------------"
    INFO "install ansible end"
    INFO "----------------------------------------------------------"
}

system_install_ansible_inventory() {
    local section=$1
    local ips=$2
    local pwd=$3
    add_ssh_host "${section}" "${ips}" "${pwd}"
    ips=$(echo ${ips[@]} | tr ',' ' ')
    echo "" >>/etc/ansible/hosts
    echo "[${section}]" >>/etc/ansible/hosts
    for ip in ${ips[@]}; do
        echo "$ip ansible_ssh_user='root' ansible_ssh_pass='${pwd}' " >>/etc/ansible/hosts
    done
    echo "" >>/etc/ansible/hosts
    cat /etc/ansible/hosts
    echo "------------  ansible test ------------"
    ansible all -m command -a "uname -a"
    ansible all --list-hosts
    echo "------------  ansible test end--------"
}

system_install_singbox() {
    if ! command -v sb &>/dev/null; then
        bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh)
    else
        NOTE "singbox is already installed"
    fi
}

system_install_docker() {
    if [ ! -n "$(which docker 2>/dev/null)" ]; then
        # curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
        bash <(curl -sfL https://linuxmirrors.cn/docker.sh)
    else
        NOTE "docker is already installed"
    fi
    # 安装docker-compose
    if [ ! -n "$(which docker-compose 2>/dev/null)" ]; then
        DOCKER_COMPOSE=$(find / -name docker-compose | grep "docker" 2>/dev/null)
        echo $DOCKER_COMPOSE
        sudo chmod 777 $DOCKER_COMPOSE
        \cp -rf $DOCKER_COMPOSE /usr/bin/docker-compose
    else
        NOTE "docker-compose is already installed"
    fi
}

system_uninstall_cri() {

    INFO "----------------------------------------------------------"
    INFO "uninstall cri start"
    INFO "----------------------------------------------------------"

    # 清理所有容器、镜像、卷
    if command -v docker &>/dev/null; then
        docker rm -f $(docker ps -aq) || true
        docker rmi -f $(docker images -q) || true
        docker volume rm -f $(docker volume ls -q) || true
        docker system prune -a -f || true
        docker volume prune -f || true
    fi

    # if command -v containerd &>/dev/null; then
    #     containerd rm -f $(containerd ps -q)
    #     containerd rmi -f $(containerd images)
    #     containerd volume rm -f $(containerd volume ls -q)
    # fi

    if command -v crictl &>/dev/null; then
        crictl rm -f $(crictl ps -a -q) || true
        crictl rmi -f $(crictl images) || true
        crictl volume rm -f $(crictl volume ls -q) || true
    fi

    if command -v ctr &>/dev/null; then
        ctr rm -f $(ctr ps -a -q) || true
        ctr rmi -f $(ctr images) || true
        ctr volume rm -f $(ctr volume ls -q) || true
    fi

    if command -v podman &>/dev/null; then
        podman rm -f $(podman ps -aq) || true
        podman rmi -f $(podman images) || true
        podman volume rm -f $(podman volume ls -q) || true
    fi

    if command -v microk8s &>/dev/null; then
        microk8s stop
        microk8s reset
        microk8s start
    fi

    if command -v k3s &>/dev/null; then
        k3s stop
        k3s reset
        k3s start
    fi

    if command -v sealos &>/dev/null; then
        sealos stop
        sealos reset
    fi

    if command -v kubeadm &>/dev/null; then
        kubeadm reset
    fi

    if command -v kind &>/dev/null; then
        kind delete cluster --all
    fi

    if command -v kubectl &>/dev/null; then
        kubectl delete --force --grace-period=0 --all deployments
        kubectl delete --force --grace-period=0 --all services
        kubectl delete --force --grace-period=0 --all pods
        kubectl delete --force --grace-period=0 --all daemonsets
        kubectl delete --force --grace-period=0 --all statefulsets
        kubectl delete --force --grace-period=0 --all cronjobs
        kubectl delete --force --grace-period=0 --all jobs
        kubectl delete --force --grace-period=0 --all secrets
        kubectl delete --force --grace-period=0 --all configmaps
        kubectl delete --force --grace-period=0 --all pvc
        kubectl delete --force --grace-period=0 --all pv
        kubectl delete --force --grace-period=0 --all namespaces
    fi

    # 停止和禁用 Docker 和 containerd 服务
    sudo systemctl stop docker 2>/dev/null || true
    sudo systemctl disable docker 2>/dev/null || true
    sudo systemctl stop containerd 2>/dev/null || true
    sudo systemctl disable containerd 2>/dev/null || true

    pm_uninstall docker docker-ce docker-ce-cli containerd.io docker.io docker-engine docker-compose-plugin runc

    # 删除与 Docker 和 containerd 相关的文件和目录
    INFO "Cleaning up Docker and containerd directories"

    sudo rm -rf /etc/docker 2>/dev/null || true
    sudo rm -rf /var/lib/docker 2>/dev/null || true
    sudo rm -rf /var/run/docker 2>/dev/null || true

    sudo rm -rf /etc/containerd 2>/dev/null || true
    sudo rm -rf /var/lib/containerd 2>/dev/null || true
    sudo rm -rf /var/run/containerd 2>/dev/null || true

    sudo rm -rf /etc/systemd/system/docker.service.d/ 2>/dev/null || true
    sudo rm -rf /etc/systemd/system/containerd.service.d/ 2>/dev/null || true

    sudo rm -f /etc/systemd/system/docker.service.d/*
    sudo rm -f /etc/systemd/system/containerd.service.d/*

    sudo rm -rf /etc/cni /opt/cni /var/lib/cni /var/lib/rancher/k3s

    if command -v journalctl &>/dev/null; then
        sudo journalctl --vacuum-time=1d
    fi
    sudo systemctl daemon-reload
    sudo systemctl reset-failed

    INFO "----------------------------------------------------------"
    INFO "uninstall cri done"
    INFO "----------------------------------------------------------"
}

###################################################################################################
#
# setter
#
###################################################################################################
set_cr_mirrors_host() {

    export PS4='\[\e[35m\]+ $(basename $0):${FUNCNAME}:${LINENO}: \[\e[0m\]'

    local config_path="/etc/containerd/certs.d"
    mkdir -p "$config_path"

    # 读取参数
    local mirror_list="$(getarg mirrors "$@")"
    mirror_list="${mirror_list:-$CRPROXY}"
    IFS=',' read -ra crmirrors <<<"$mirror_list"

    local scheme="$(getarg scheme "$@")"
    scheme="${scheme:-https}"

    local registries=(
        "cr.l5d.io" "l5d"
        "docker.elastic.co" "elastic"
        "registry-1.docker.io" "docker" "dhub"
        "docker.io" "docker" "dhub"
        "gcr.io" "gcr"
        "ghcr.io" "ghcr"
        "k8s.gcr.io" "k8s-gcr"
        "registry.k8s.io" "k8s"
        "mcr.microsoft.com" "mcr"
        "nvcr.io" "nvcr"
        "quay.io" "quay"
        "registry.jujucharms.com" "jujucharms"
    )

    generate_hosts_toml() {
        local registry="$1"
        shift
        local prefixes=("$@")
        [ "${#crmirrors[@]}" -eq 0 ] && return 1

        printf 'server = "%s://%s"\n' "$scheme" "$registry"
        for mirror in "${crmirrors[@]}"; do
            for prefix in "${prefixes[@]}"; do
                printf '[host."%s://%s.%s"]\n' "$scheme" "$prefix" "$mirror"
                printf '  capabilities = ["pull", "resolve"]\n'
                if [ "$scheme" = "http" ]; then
                    printf '  skip_verify = true\n'
                fi
            done
        done
    }

    local i=0
    while [ $i -lt ${#registries[@]} ]; do
        local registry="${registries[$i]}"
        let i=i+1
        local prefixes=()
        while [ $i -lt ${#registries[@]} ] && [[ "${registries[$i]}" != *.* ]]; do
            prefixes+=("${registries[$i]}")
            let i=i+1
        done

        local hosts_dir="$config_path/$registry"
        mkdir -p "$hosts_dir"
        if ! generate_hosts_toml "$registry" "${prefixes[@]}" >"$hosts_dir/hosts.toml"; then
            NOTE "未设置镜像，加速未启用，删除 $hosts_dir"
            rm -rf "$hosts_dir"
        fi
    done

    ls -al $config_path

    NOTE "containerd 镜像加速配置已完成：$config_path"
}

set_cr_mirrors_registries() {
    local mirror_list=$(getarg mirrors "$@")
    local mirror_list="${mirror_list:-${CRPROXY}}"
    IFS=',' read -ra mirrors <<<"$mirror_list"

    local scheme=$(getarg scheme "$@")
    local scheme="${scheme:-https}"

    local registries_file=$(getarg registries "$@")
    if [ -d "/etc/rancher/k3s" ]; then
        registries_file="${registries_file:-/etc/rancher/k3s/registries.yaml}"
    fi
    if [ -d "/var/snap/microk8s/current/args" ]; then
        registries_file="${registries_file:-/var/snap/microk8s/current/args/registries.yaml}"
    fi
    if [ -z "$registries_file" ]; then
        echo "ERROR: missing registries path" >&2
        return 1
    fi

    echo "$registries_file"
    mkdir -p "$(dirname "$registries_file")"
    rm -f "$registries_file"

    # 定义 registry => 前缀 映射表
    local -A registry_prefixes=(
        ["cr.l5d.io"]="l5d"
        ["docker.elastic.co"]="elastic"
        ["registry-1.docker.io"]="dhub"
        ["docker.io"]="dhub"
        ["gcr.io"]="gcr"
        ["ghcr.io"]="ghcr"
        ["k8s.gcr.io"]="k8s-gcr"
        ["registry.k8s.io"]="k8s"
        ["mcr.microsoft.com"]="mcr"
        ["nvcr.io"]="nvcr"
        ["quay.io"]="quay"
        ["registry.jujucharms.com"]="jujucharms"
    )

    echo "mirrors:" >>"$registries_file"

    # 用于收集 registry host 以生成 configs
    declare -A insecure_hosts=()

    for registry in "${!registry_prefixes[@]}"; do
        local prefix="${registry_prefixes[$registry]}"
        if [ "${#mirrors[@]}" -eq 0 ]; then
            continue
        fi

        echo "  $registry:" >>"$registries_file"
        echo "    endpoint:" >>"$registries_file"
        for mirror in "${mirrors[@]}"; do
            local endpoint="${scheme}://${prefix}.${mirror}"
            echo "      - ${endpoint}" >>"$registries_file"

            # 如果使用 http，添加到 insecure host 列表
            if [ "$scheme" = "http" ]; then
                insecure_hosts["${prefix}.${mirror}"]=1
            fi
        done
    done

    # 添加 sealos hub
    cat <<EOF >>"$registries_file"
  sealos.hub:5000:
    endpoint:
      - "http://sealos.hub:5000"
configs:
  sealos.hub:5000:
    auth:
      username: admin
      password: passw0rd
    tls:
      insecure_skip_verify: true
EOF

    # 添加其他 insecure hosts
    for host in "${!insecure_hosts[@]}"; do
        cat <<EOF >>"$registries_file"
  ${host}:
    tls:
      insecure_skip_verify: true
EOF
    done

    cat "$registries_file"

    if [ -d "/etc/rancher/k3s" ]; then
        NOTE "restart k3s"
        systemctl restart k3s
    fi
    if [ -d "/var/snap/microk8s/current/args" ]; then
        if command -v microk8s &>/dev/null; then
            NOTE "restart k3s microk8s"
            microk8s.stop
            microk8s.start
        fi
    fi
    if command -v containerd &>/dev/null 2>&1; then
        NOTE "restart containerd"
        systemctl restart containerd
    fi
}

set_cr_mirrors_auto() {
    if [ -z "$HAS_GCR" ]; then
        if [ -d "/etc/containerd/certs.d" ]; then
            set_cr_mirrors_host $@
        fi
        if [ -d "/etc/rancher/k3s" ]; then
            set_cr_mirrors_registries $@
        fi
        if [ -d "/var/snap/microk8s/current/args" ]; then
            set_cr_mirrors_registries $@
        fi
    fi
}

set_linux_mirrors_official() {
    bash <(curl -sfL https://linuxmirrors.cn/main.sh) \
        --use-official-source true \
        --protocol http \
        --use-intranet-source false \
        --backup false \
        --upgrade-software false \
        --clean-cache false \
        --ignore-backup-tips
}

set_linux_mirrors_ustc() {
    bash <(curl -sfL https://linuxmirrors.cn/main.sh) \
        --source mirrors.ustc.edu.cn \
        --protocol http \
        --use-intranet-source false \
        --backup false \
        --upgrade-software false \
        --clean-cache false \
        --ignore-backup-tips

}

set_linux_mirrors_auto() {
    if [ -n "$HAS_GOOGLE" ]; then
        set_linux_mirrors_official
    else
        set_linux_mirrors_ustc
    fi
}

set_linux_mirrors() {
    local abroad=$(getarg abroad $@)
    if [ "$abroad" == "true" ]; then
        bash <(curl -sfL https://linuxmirrors.cn/main.sh) --abroad
    elif [ "$abroad" == "false" ]; then
        bash <(curl -sfL https://linuxmirrors.cn/main.sh)
    elif [ -n "$HAS_GOOGLE" ]; then
        bash <(curl -sfL https://linuxmirrors.cn/main.sh) --abroad
    else
        bash <(curl -sfL https://linuxmirrors.cn/main.sh)
    fi
}

set_docker_mirrors() {
    local mirror_list=$(getarg mirrors "$@")
    local mirror_list="${mirror_list:-$CRPROXY}"
    IFS=',' read -ra mirror_hosts <<<"$mirror_list"

    local scheme=$(getarg scheme "$@")
    local scheme="${scheme:-http}"

    local docker_config_path="/etc/docker/daemon.json"
    sudo mkdir -p /etc/docker

    local registries=(
        "cr.l5d.io:l5d"
        "docker.elastic.co:elastic"
        "registry-1.docker.io:dhub"
        "docker.io:dhub"
        "gcr.io:gcr"
        "ghcr.io:ghcr"
        "k8s.gcr.io:k8s-gcr"
        "registry.k8s.io:k8s"
        "mcr.microsoft.com:mcr"
        "nvcr.io:nvcr"
        "quay.io:quay"
        "registry.jujucharms.com:jujucharms"
    )

    {
        echo '{'
        echo '  "registry-mirrors": ['
        for i in "${!mirror_hosts[@]}"; do
            mirror="${mirror_hosts[$i]}"
            if [[ $i -lt $((${#mirror_hosts[@]} - 1)) ]]; then
                echo "    \"https://dhub.${mirror}\","
            else
                echo "    \"https://dhub.${mirror}\""
            fi
        done
        echo '  ],'
        echo '  "max-concurrent-downloads": 50,'
        echo '  "log-driver": "json-file",'
        echo '  "log-level": "warn",'
        echo '  "log-opts": {'
        echo '    "max-size": "512m",'
        echo '    "max-file": "1"'
        echo '  },'
        echo '  "exec-opts": ["native.cgroupdriver=systemd"],'
        echo '  "storage-driver": "overlay2",'
        echo '  "insecure-registries": ['

        for i in "${!registries[@]}"; do
            local reg="${registries[$i]%%:*}"
            local comma=","
            [[ $i -eq $((${#registries[@]} - 1)) ]] && comma=""
            echo "    \"$reg\"$comma"
        done

        echo '  ],'
        echo '  "data-root": "/var/lib/docker",'
        echo '  "registry-configs": {'

        for i in "${!registries[@]}"; do
            local reg="${registries[$i]%%:*}"
            local prefix="${registries[$i]##*:}"
            local is_last=$((i == ${#registries[@]} - 1))

            echo "    \"$reg\": {"
            echo "      \"endpoint\": ["
            for j in "${!mirror_hosts[@]}"; do
                local host="${mirror_hosts[$j]}"
                local comma=","
                [[ $j -eq $((${#mirror_hosts[@]} - 1)) ]] && comma=""
                echo "        \"${scheme}://${prefix}.${host}\"$comma"
            done
            echo "      ]"
            echo -n "    }"
            [[ $is_last -eq 0 ]] && echo "," || echo ""
        done

        echo '    , "sealos.hub:5000": {'
        echo '      "endpoint": ['
        echo '        "http://sealos.hub:5000"'
        echo '      ]'
        echo '    }'
        echo '  }'
        echo '}'
    } | sudo tee "$docker_config_path" >/dev/null

    sudo mkdir -p /etc/systemd/system/docker.service.d
    cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/limit-nofile.conf >/dev/null
[Service]
LimitNOFILE=1048576
EOF

    sudo systemctl daemon-reexec 2>/dev/null || true
    sudo systemctl enable docker 2>/dev/null || true
    sudo systemctl restart docker 2>/dev/null || true

    echo "✅ Docker daemon.json 已生成：$docker_config_path"
    sudo cat "$docker_config_path"
}

###################################################################################################
#
# k8s-system
#
###################################################################################################

system_install_sealos() {

    local VERSION=$(get_github_release_version "labring/sealos/releases/latest")
    if ! command -v sealos &>/dev/null; then
        curl -sfL ${GHPROXY}/https://raw.githubusercontent.com/labring/sealos/main/scripts/install.sh | PROXY_PREFIX=${GHPROXY} sh -s ${VERSION} labring/sealos
    fi
    if ! command -v sealos &>/dev/null; then
        wget ${GHPROXY}/https://github.com/labring/sealos/releases/download/${VERSION}/sealos_${VERSION#v}_linux_amd64.tar.gz &&
            tar zxvf sealos_${VERSION#v}_linux_amd64.tar.gz sealos &&
            chmod +x sealos && mv sealos /usr/bin
    fi
    if ! command -v sealos &>/dev/null; then
        if command -v apt &>/dev/null; then
            echo "deb [trusted=yes] https://apt.fury.io/labring/ /" | sudo tee /etc/apt/sources.list.d/labring.list
            sudo apt update
            sudo apt install sealos
        fi
    fi
    if ! command -v sealos &>/dev/null; then
        if command -v yum &>/dev/null; then
            sudo cat >/etc/yum.repos.d/labring.repo <<EOF
[fury]
name=labring Yum Repo
baseurl=https://yum.fury.io/labring/
enabled=1
gpgcheck=0
EOF
            sudo yum clean all
            sudo yum install sealos
        fi
    fi

    if ! command -v sealos &>/dev/null; then
        ERROR "install sealos cli failed;" && exit
    fi

}

system_install_k8s_sealos() {
    if ! command -v sealos &>/dev/null; then
        system_install_sealos
    fi

    local masters=$(getarg masters $@)
    local add_masters=$(getarg add_masters $@)
    local add_nodes=$(getarg add_nodes $@)
    local external_ips=$(getarg external_ips $@)
    local sshpwd=$(getarg sshpwd $@)
    local cri=$(getarg cri $@)
    local cri=${cri:-$K8S_CRI}
    local k8s_version=$(getarg k8s_version $@)
    local k8s_version=${k8s_version:-$K8S_VERSION}

    local cluster=$(getarg cluster $@)
    local cluster=${cluster:-"$CLUSTER"}

    if [ -z "$masters" ] && [ -z "$add_masters" ] && [ -z "$add_nodes" ]; then
        ERROR "masters, add_masters, add_nodes at least one should be set" && exit 1
    fi

    if [ -z "$sshpwd" ]; then
        read -s -p "Enter SSH password: " sshpwd
    fi

    get_k8s_image() {
        case "$cri" in
        "") echo "kubernetes" ;;
        "containerd") echo "kubernetes" ;;
        "docker") echo "kubernetes-docker" ;;
        "k3s") echo "k3s" ;;
        *)
            ERROR "K8S_CRI must be containerd, k3s, or docker" && exit 1
            ;;
        esac
    }
    local k8s_image=$(get_k8s_image)
    # https://github.com/labring-actions/cluster-image-docs/blob/main/docs/aliyun-shanghai/rootfs.md
    if [ -n "$masters" ]; then
        local latest_version=$(get_sealos_release_version $k8s_image)
        local latest_version=${latest_version:-"v1.29.9"}
        local k8s_version=${k8s_version:-$latest_version}
        sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/${k8s_image}:${k8s_version} \
            --masters ${masters} \
            -p ${sshpwd}
    fi
    if [ -n "$add_masters" ]; then
        sealos add --cluster $cluster --masters $add_masters -p ${sshpwd}
    fi
    if [ -n "$add_nodes" ]; then
        sealos add --cluster $cluster --nodes $add_nodes -p ${sshpwd}
    fi
    if [ -n "$external_ips" ]; then
        sealos cert --cluster $cluster --alt-names $external_ips
    fi
}

system_install_k8s_microk8s() {
    snap install microk8s --classic
}

# system_install_k8s_k3s() {
#     local ips=$(getarg ips $@)
#     local TOKEN=$(getarg token $@)
#     # 将逗号分隔的 IP 地址转换为数组
#     IFS=',' read -r -a IPS <<<"$ips"
#     # 合并两个数组
#     local EXTERNAL_IPS=("${IPS[@]}" "$IPV4_LAN" "$IPV4_WAN")
#     local UNIQUE_IPS=($(echo "${EXTERNAL_IPS[@]}" | tr ' ' '\n' | sort -u | grep -v '^$' | tr '\n' ' '))

#     # 动态拼接 tls-san 参数
#     local TLS_SANS=""
#     for IP in "${UNIQUE_IPS[@]}"; do
#         if [ -n "$IP" ]; then # 确保IP非空
#             local TLS_SANS="$TLS_SANS --tls-san $IP"
#         fi
#     done

#     if [ -z "${TLS_SANS}" ]; then
#         ERROR "MISSING TLS_SANS" && exit 1
#     else
#         NOTE "TLS_SANS: $TLS_SANS"
#     fi
#     if [ -z "${TOKEN}" ]; then
#         ERROR "MISSING TOKEN" && exit 1
#     fi

#     # --flannel-backend=wireguard-native,none
#     # --node-external-ip $IPV4_LAN  \
#     # TODO HAS_GOOGLE ?
#     curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -s - server \
#         --token $TOKEN --cluster-init \
#         --disable traefik \
#         --disable servicelb \
#         --disable-network-policy \
#         --write-kubeconfig-mode 777 \
#         --kube-proxy-arg "proxy-mode=ipvs" \
#         --kube-proxy-arg "masquerade-all=true" \
#         --kube-proxy-arg "metrics-bind-address=0.0.0.0" \
#         --flannel-backend none \
#         $TLS_SANS
#     if ! command -v kubectl &>/dev/null; then
#         ERROR "install k3s cli failed;" && exit
#     fi
#     local spinner="/-\|"
#     NOTE "Waiting for k3s to be ready..."
#     for i in {1..300}; do
#         local nodes_status=$(kubectl get nodes -o custom-columns="NAME:.metadata.name,STATUS:.status.conditions[?(@.type=='Ready')].status" | awk 'NR>1')
#         local not_ready=$(echo "$nodes_status" | grep -v "True")
#         if [ -z "$not_ready" ]; then
#             kubectl get nodes
#             INFO "k3s is ready."
#             return 0
#         fi
#         echo -ne "\rk3s is not ready, waiting...[${spinner:i%4:1}], ${i}s"
#         sleep 1
#     done

#     WARN "k3s did not become ready in the expected time."
#     # journalctl -xeu k3s.service  # 可根据需要解注释查看详细日志
#     # exit 1
# }

system_install_k8s_auto() {
    local K8S_CRI=$(getarg cri $@)
    local total_mem=$(free -g | grep Mem | awk '{print $2}')
    NOTE "check memory: ${total_mem}G"

    # 可选值：containerd, docker, k3s
    if [ "$total_mem" -ge 16 ]; then
        K8S_CRI=${K8S_CRI:-'containerd'}
    else
        K8S_CRI=${K8S_CRI:-'k3s'}
    fi

    NOTE "install k8s with cri: $K8S_CRI"

    system_install_k8s_sealos $@
    system_install_k8s_config

}

system_install_k8s() {
    system_install_k8s_auto $@
}

system_install_k8s_config() {
    if [ -f "/etc/rancher/k3s/k3s.yaml" ]; then
        export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    elif [ -f "/var/snap/microk8s/current/credentials/client.config" ]; then
        export KUBECONFIG=/var/snap/microk8s/current/credentials/client.config
    elif [ -f "/etc/kubernetes/admin.conf" ]; then
        export KUBECONFIG=/etc/kubernetes/admin.conf
    fi

    if [ -n "$KUBECONFIG" ]; then
        INFO "export KUBECONFIG=$KUBECONFIG"
    fi
}

system_uninstall_sealos() {
    if command -v sealos &>/dev/null; then
        INFO "Uninstalling sealos..."

        local cluster=$(getarg cluster $@)
        local masters=$(getarg masters $@)
        local nodes=$(getarg nodes $@)
        local sshpwd=$(getarg sshpwd $@)

        local cluster=${cluster:-"$CLUSTER"}

        if [ -z $sshpwd ]; then
            ERROR "missing --sshpwd <password>" && exit 1
        fi

        if [ -n "$nodes" ]; then
            sealos delete --cluster $cluster --nodes ${nodes:-""} -p ${sshpwd} --force || ERROR "Failed to delete nodes"
        fi
        if [ -n "$masters" ]; then
            sealos reset --cluster $cluster --masters ${masters} -p ${sshpwd} --force || ERROR "Failed to reset sealos"
        fi
        if [ -z "$masters" ] && [ -z "$nodes" ]; then
            sealos reset --cluster $cluster --force || true
        fi
        pm_uninstall sealos
        if command -v sealos &>/dev/null; then
            rm -rf $(which sealos)
        fi
    else
        INFO "Sealos is not installed."
    fi
}

system_uninstall_microk8s() {
    if command -v microk8s &>/dev/null; then
        INFO "Stopping and uninstalling microk8s..."
        microk8s.stop || ERROR "Failed to stop microk8s"
        snap remove microk8s --purge || ERROR "Failed to remove microk8s"
        rm -rf /var/snap/microk8s 2>/dev/null
    else
        INFO "Microk8s is not installed."
    fi
}

system_uninstall_k3s() {
    if [ -f "/usr/local/bin/k3s-uninstall.sh" ]; then
        INFO "Uninstalling k3s..."
        /usr/local/bin/k3s-uninstall.sh || ERROR "Failed to uninstall k3s"
    else
        INFO "K3s uninstall script not found."
    fi

    if [ -f "/usr/local/bin/k3s-agent-uninstall.sh" ]; then
        INFO "Uninstalling k3s agent..."
        /usr/local/bin/k3s-agent-uninstall.sh || ERROR "Failed to uninstall k3s agent"
    else
        INFO "K3s agent uninstall script not found."
    fi
}

system_uninstall_k8s_auto() {
    system_uninstall_sealos $@
    system_uninstall_microk8s $@
    system_uninstall_k3s $@
}

system_uninstall_k8s() {
    system_uninstall_k8s_auto $@
}

###################################################################################################
#
# docker app
#
###################################################################################################

docker_install_crproxy() {
    local DOMAIN=$(getarg domain $@)
    local DOMAIN=${DOMAIN:-$CRPROXY}
    if command -v docker &>/dev/null 2>&1; then
        local VERSION=$(get_github_release_version "DaoCloud/crproxy")
        docker rm -f crproxy
        docker run -dit \
            --restart=always \
            --privileged \
            -p 80:8080 \
            -p 443:8080 \
            -e DOMAIN=${DOMAIN}.xyz \
            --name crproxy \
            ghcr.io/daocloud/crproxy/crproxy:${VERSION} \
            -a :8080 \
            --enable-pprof true \
            --retry 3 \
            --retry-interval 3s \
            --disable-keep-alives nvcr.io \
            --privileged-no-auth \
            --simple-auth \
            --token-url "https://${DOMAIN}/auth/token" \
            --override-default-registry=docker.${DOMAIN}=docker.io \
            --override-default-registry=dhub.${DOMAIN}=docker.io \
            --override-default-registry=l5d.${DOMAIN}=cr.l5d.io \
            --override-default-registry=elastic.${DOMAIN}=docker.elastic.co \
            --override-default-registry=gcr.${DOMAIN}=gcr.io \
            --override-default-registry=ghcr.${DOMAIN}=ghcr.io \
            --override-default-registry=k8s-gcr.${DOMAIN}=k8s.gcr.io \
            --override-default-registry=k8s.${DOMAIN}=registry.k8s.io \
            --override-default-registry=mcr.${DOMAIN}=mcr.microsoft.com \
            --override-default-registry=nvcr.${DOMAIN}=nvcr.io \
            --override-default-registry=quay.${DOMAIN}=quay.io \
            --override-default-registry=jujucharms.${DOMAIN}=registry.jujucharms.com
    fi
}

###################################################################################################
#
# k8s core
#
###################################################################################################

k8s_install_acme() {
    local namespace=$(getarg namespace $@)
    local namespace=${namespace:-"default"}
    local domain=$(getarg domain $@)
    local domain=${domain:-"${DOMAIN}"}
    local solver=$(getarg solver $@)
    local solver=${solver:-"${ACME_DNS}"}
    if [ -z "$solver" ]; then
        ERROR "missing --solver <solver>" && exit 1
    fi
    local secretId=$(getarg secret_id $@)
    local secretId=${secretId:-"${ACME_DNS_ID}"}
    local secretKey=$(getarg secret_key $@)
    local secretKey=${secretKey:-"${ACME_DNS_KEY}"}

    echo "ENV domain: ${domain}"
    echo "ENV solver: ${solver}"
    echo "ENV secretId: ${secretId}"
    echo "ENV secretKey: ${secretKey}"

    if [ "$solver" == "dnspod" ] || [ "$solver" == "dns_dp" ]; then
        # https://imroc.cc/kubernetes/certs/sign-free-certs-for-dnspod
        # https://github.com/imroc/cert-manager-webhook-dnspod
        if [ -z "$secretId" ] || [ -z "$secretKey" ]; then
            ERROR "missing --secretId <secretId> or --secretKey <secretKey>" && exit 1
        fi
        kubectl apply -f ${GHPROXY}https://raw.githubusercontent.com/imroc/cert-manager-webhook-dnspod/master/bundle.yaml

        # ClusterIssuer 会从 cert-manager 的 namespace 下找 Secret, 所以要创建在 cert-manager namespace 下不能改
        kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: dnspod-secret-${domain}
  namespace: cert-manager
type: Opaque
stringData:
  secretId: "${secretId}"
  secretKey: "${secretKey}"
EOF

        # ClusterIssuer 是集群级资源, 它不属于任何 namespace.
        kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: dnspod-${domain}
  namespace: cert-manager
spec:
  acme:
    email: acme@${domain}
    privateKeySecretRef:
      name: dnspod-letsencrypt-${domain}
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - dns01:
          webhook:
            config:
              secretIdRef:
                key: secretId
                name: dnspod-secret-${domain}
              secretKeyRef:
                key: secretKey
                name: dnspod-secret-${domain}
              ttl: 600
              recordLine: ""
            groupName: acme.dnspod.com
            solverName: dnspod
EOF

        kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-${domain}-tls
  namespace: ${namespace}
spec:
  secretName: wildcard-${domain}-tls
  issuerRef:
    name: dnspod-${domain}
    kind: ClusterIssuer
    group: cert-manager.io
  dnsNames:
    - "${domain}"
    - "*.${domain}"
EOF

    elif [ "$solver" == "ali" ] || [ "$solver" == "dns_ali" ]; then
        echo "ali not support" && exit 1
    elif [ "$solver" == "namesilo" ] || [ "$solver" == "dns_namesilo" ]; then
        echo "namesilo not support" && exit 1
    else
        ERROR "ENV solver: $solver is invalid, please use dnspod, ali, namesilo"
        exit 1
    fi

    # 重启cert-manager-webhook-dnspod
    kubectl delete pod -n cert-manager -l app=cert-manager-webhook-dnspod

    # kubectl wait --for=condition=Ready certificate/wildcard-${domain}-tls -n ${namespace} --timeout=120s || true

    # 查看 ClusterIssuer 状态
    kubectl describe clusterissuer dnspod-${domain}
    # 查看证书状态
    kubectl describe -n ${namespace} certificate wildcard-${domain}-tls
    kubectl get certificaterequest -A
    # 或直接查看具体请求
    # kubectl describe certificaterequest wildcard-${domain}-tls-1 -n ${namespace}
    # 查看 cert-manager 日志
    kubectl logs -n cert-manager deploy/cert-manager

}

k8s_install_nodeport() {
    local range=$(getarg range $@)

    if [[ "$range" =~ ^([0-9]+)-([0-9]+)$ ]]; then
        local start=${BASH_REMATCH[1]}
        local end=${BASH_REMATCH[2]}
        if [ $start -le $end ]; then
            echo "" >/dev/null
        else
            ERROR "ENV range: $range is invalid, please use start <= end"
            exit 1
        fi

        if [ $start -ge 1 ] && [ $start -le 65535 ] && [ $end -ge 1 ] && [ $end -le 65535 ]; then
            echo "" >/dev/null
        else
            ERROR "ENV range: $range is invalid, please use 1-65535"
            exit 1
        fi
    else
        ERROR "ENV range: $range is invalid, please use 1-65535"
        exit 1
    fi

    local range=${range:-"1000-60000"}

    if [ -f /etc/kubernetes/manifests/kube-apiserver.yaml ]; then
        local MANIFEST_FILE="/etc/kubernetes/manifests/kube-apiserver.yaml"
        local BACKUP_FILE="${MANIFEST_FILE}.bak.$(date +%s)"
        local TARGET_ARG="service-node-port-range=${range}"
        echo "🔧 修改 $MANIFEST_FILE ..."
        if grep -q "$TARGET_ARG" "$MANIFEST_FILE"; then
            echo "✅ 参数已存在，无需修改。"
            exit 0
        fi
        \cp -rf "$MANIFEST_FILE" "$BACKUP_FILE"
        # 如果有备份文件不会生效, 移走后生效
        \mv -f "$BACKUP_FILE" ${TEMP}/
        echo "📦 备份原文件到 ${TEMP}/$(basename "$BACKUP_FILE")"
        echo "✏️ 清理旧的 node-port-range 参数整行..."
        sed -i '/--service-node-port-range=/d' "$MANIFEST_FILE"
        echo "➕ 追加参数 $TARGET_ARG 到 containers.command ..."
        # 只在第一个 "- --" 行后面插入一次
        sed -i "/^[[:space:]]*- kube-apiserver$/a \    - --${TARGET_ARG}" "$MANIFEST_FILE"
        if command -v kubelet &>/dev/null; then
            echo "✅ 发现 kubelet，修改 static pod 后将自动生效。"
        else
            echo "⚠️ 未发现 kubelet，尝试重启 containerd..."
            if command -v containerd &>/dev/null; then
                systemctl restart containerd 2>/dev/null && echo "✅ 已尝试重启 containerd。"
            else
                echo "❌ 未找到 containerd，无法重启。"
            fi
        fi
    fi
    if [ -f /etc/systemd/system/k3s.service ]; then
        local SERVICE_FILE="/etc/systemd/system/k3s.service"
        local BACKUP_FILE="/etc/systemd/system/k3s.service.bak.$(date +%s)"
        local TARGET_ARG="--kube-apiserver-arg service-node-port-range=${range}"
        echo "🔍 检查 $SERVICE_FILE 是否已经包含正确参数..."
        # 检查 ExecStart 行中是否已存在该参数
        if grep -q "${TARGET_ARG}" "$SERVICE_FILE"; then
            echo "✅ 已包含参数，无需修改。"
            exit 0
        fi
        echo "🛠 备份原始文件到 $BACKUP_FILE"
        cp "$SERVICE_FILE" "$BACKUP_FILE"
        echo "✏️ 修改 ExecStart 行..."
        # 删除已有的 service-node-port-range 参数（如有），防止冲突
        sed -i -E "/^ExecStart=/ s/--kube-apiserver-arg service-node-port-range=[^ ]+//g" "$SERVICE_FILE"
        # 然后追加目标参数
        sed -i "/^ExecStart=/ s|$| ${TARGET_ARG}|" "$SERVICE_FILE"
        cat "$SERVICE_FILE"
        echo "🔄 重新加载 systemd 配置并重启 k3s 服务..."
        systemctl daemon-reexec
        systemctl daemon-reload
        systemctl restart k3s
        echo "✅ 修改完成并重启 k3s 成功。"
    fi
}

k8s_uninstall_gateway_api() {
    # https://github.com/kubernetes-sigs/gateway-api/tree/main/conformance/reports
    local version=$(getarg version $@)
    local version=${version:-"$(get_github_release_version "kubernetes-sigs/gateway-api")"}
    kubectl delete -f ${GHPROXY}https://github.com/kubernetes-sigs/gateway-api/releases/download/${version}/experimental-install.yaml
}

k8s_install_gateway_api() {
    local version=$(getarg version $@)
    local version=${version:-"$(get_github_release_version "kubernetes-sigs/gateway-api")"}
    # Gateway API CRD
    # kubectl apply -f ${GHPROXY}https://github.com/kubernetes-sigs/gateway-api/releases/download/${version}/standard-install.yaml
    kubectl apply -f ${GHPROXY}https://github.com/kubernetes-sigs/gateway-api/releases/download/${version}/experimental-install.yaml
}

k8s_install_longhorn() {
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version longhorn)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/longhorn:${latest_version}
    fi
}

k8s_install_openebs() {
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version openebs)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/openebs:${latest_version}
    elif command -v helm &>/dev/null 2>&1; then
        helm repo add openebs https://openebs.github.io/openebs
        helm repo update
        helm upgrade --install openebs \
            --namespace openebs openebs/openebs \
            --set engines.replicated.mayastor.enabled=false \
            --create-namespace
    else
        ERROR "OpenEBS installation failed."
        exit 1
    fi

    INFO "OpenEBS installed successfully."
}

k8s_install_istio() {
    local profile=$(getarg profile $@)
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version istio)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/istio:${latest_version} \
            -e ISTIOCTL_OPTS="--set profile=${profile:-minimal} -y"
        kubectl -n istio-system wait --for=condition=Ready pods --all
        kubectl get gatewayclass
        kubectl label namespace default istio-injection=enabled
        # istioctl dashboard controlz deployment/istiod.istio-system
        # kubectl get namespace -L istio-injection
        # kubectl get all -n istio-system
    fi
}

k8s_install_helm() {
    if ! command -v helm &>/dev/null; then
        if command -v sealos &>/dev/null; then
            local cluster=$(getarg cluster $@)
            local cluster=${cluster:-"$CLUSTER"}
            # https://github.com/labring-actions/cluster-image/blob/main/applications/helm
            local latest_version=$(get_sealos_release_version helm)
            sudo sealos run --cluster $cluster \
                -f ${labring_image_registry}/${labring_image_repository}/helm:${latest_version}
        elif command -v snap &>/dev/null; then
            sudo snap install helm --classic
        elif command -v dnf &>/dev/null; then
            sudo dnf install helm
        elif command -v microk8s &>/dev/null; then
            microk8s.helm install
        elif command -v pacman &>/dev/null; then
            sudo pacman -S helm
        elif command -v apt &>/dev/null; then
            curl https://baltocdn.com/helm/signing.asc | sudo tee /etc/apt/trusted.gpg.d/helm.asc
            sudo apt-get install apt-transport-https --yes
            sudo apt update
            sudo apt install helm
        elif command -v yum &>/dev/null; then
            curl -sfL ${GHPROXY}https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
        elif command -v brew &>/dev/null; then
            brew install helm
        else
            # 使用 curl 下载 Helm 安装脚本
            local latest_release_url="https://get.helm.sh/helm-latest-version"
            local latest_release_response=$(curl -sfL "$latest_release_url" 2>&1 || true)
            local version=$(echo "$latest_release_response" | grep '^v[0-9]')
            echo $version
            curl -sfL https://get.helm.sh/helm-$version-linux-amd64.tar.gz -o helm.tar.gz

            # 解压并移动到 /usr/local/bin 目录
            tar -zxvf helm.tar.gz
            sudo mv linux-amd64/helm /usr/local/bin/helm
        fi
    fi

    if command -v helm &>/dev/null; then
        helm version
        helm repo add aliyun https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts >/dev/null || true
        helm repo add kaiyuanshe http://mirror.kaiyuanshe.cn/kubernetes/charts >/dev/null || true
        # helm repo add dandydev https://dandydeveloper.github.io/charts >/dev/null || true
        helm repo add azure http://mirror.azure.cn/kubernetes/charts >/dev/null || true
        helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null || true
    else
        ERROR "Helm installation failed."
        exit 1
    fi
}

k8s_install_cert_manager() {
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version cert-manager)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/cert-manager:${latest_version}
        kubectl -n cert-manager wait --for=condition=Ready pods --all
    fi
}

k8s_install_cilium_cidr() {
    local cidr=$(getarg cidr $@)
    local cidr=${CIDR:-$cidr}
    local cidr=${cidr:-$IPV4_WAN}
    local cidr=$(echo ${cidr[@]} | tr ',' ' ')
    if [ -z "$cidr" ]; then
        echo "ERROR: MISSING cidr" && exit 1
    fi
    echo "cidr=>$cidr"
    kubectl delete CiliumLoadBalancerIPPool --all 2>/dev/null || true
    for addr in $cidr; do
        kubectl apply -f - <<EOF
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "ip-pool-${addr}"
spec:
  blocks:
  - cidr: "${addr}/32"
EOF
    done
    kubectl annotate svc higress-gateway -n higress-system --overwrite io.cilium/lb-ipam-ips=$IP_POOL 2>/dev/null || true
}

k8s_install_cilium() {

    local latest_version=$(get_sealos_release_version cilium)
    local latest_version=${latest_version#v}
    local cilium_version=$(getarg cilium_version $@)
    local cilium_version=${cilium_version:-$latest_version}
    local cilium_version=${cilium_version:-"1.15.8"}

    #   https://docs.cilium.io/en/stable/network/concepts/ipam/
    local ipam=$(getarg ipam $@)
    local ipam=${ipam:-"kubernetes"} # cluster-pool,kubernetes ;

    local kubeProxyReplacement=$(getarg kubeProxyReplacement $@)
    local kubeProxyReplacement=${kubeProxyReplacement:-"true"}

    local ingress=$(getarg ingress $@)
    local ingress=${ingress:-"false"}
    local ingressHost=$(getarg ingress_host $@)
    local ingressHost=${ingressHost:-"false"}

    local gatewayAPI=$(getarg gateway_api $@)
    local gatewayAPI=${gatewayAPI:-"false"}
    local gatewayHost=$(getarg gateway_host $@)
    local gatewayHost=${gatewayHost:-"false"}

    local envoy=$(getarg envoy $@)
    local envoy=${envoy:-"true"}

    #     cat <<EOF >/etc/sysctl.d/99-zzz-override_cilium.conf
    # # Disable rp_filter on Cilium interfaces since it may cause mangled packets to be dropped
    # net.ipv4.conf.lxc*.rp_filter = 0
    # net.ipv4.conf.cilium_*.rp_filter = 0
    # # The kernel uses max(conf.all, conf.{dev}) as its value, so we need to set .all. to 0 as well.
    # # Otherwise it will overrule the device specific settings.
    # net.ipv4.conf.all.rp_filter = 0
    # EOF
    # cat /etc/sysctl.d/99-zzz-override_cilium.conf
    # sysctl -p /etc/sysctl.d/99-zzz-override_cilium.conf

    if [ "$kubeProxyReplacement" == "true" ]; then
        kubectl -n kube-system delete ds kube-proxy 2>/dev/null || true
        kubectl -n kube-system delete cm kube-proxy 2>/dev/null || true
    fi

    # https://docs.cilium.io/en/stable/helm-reference/
    local ExtraValues=","
    if [ -n "${ipam}" ]; then
        NOTE "Cilium ipam mode => ${ipam}"
        local ExtraValues=$ExtraValues",ipam.mode=${ipam}"
    fi
    if [ -n "${kubeProxyReplacement}" ]; then
        NOTE "Cilium kubeProxyReplacement => ${kubeProxyReplacement}"
        local ExtraValues=$ExtraValues",kubeProxyReplacement=${kubeProxyReplacement}"
        local ExtraValues=$ExtraValues",nodePort.enabled=true"
    fi
    # local ExtraValues=$ExtraValues",global.nodeinit.enabled=true"
    # local ExtraValues=$ExtraValues",global.nodeinit.securityContext.privileged=true"
    # local ExtraValues=$ExtraValues",ipam.Operator.ClusterPoolIPv4MaskSize=24"
    # local ExtraValues=$ExtraValues",ipam.operator.clusterPoolIPv4PodCIDRList=10.42.0.0/16"
    # local ExtraValues=$ExtraValues",ipv4NativeRoutingCIDR=10.42.0.0/16"
    # local ExtraValues=$ExtraValues",routingMode=native"
    # local ExtraValues=$ExtraValues",autoDirectNodeRoutes=true"
    # local ExtraValues=$ExtraValues",tunnel=diabled" // tunnel was deprecated in v1.14 and has been removed in v1.15
    # local ExtraValues=$ExtraValues",bpf.masquerade=true"
    # local ExtraValues=$ExtraValues",bpf.hostLegacyRouting=true"
    # local ExtraValues=$ExtraValues",loadBalancer.mode=hybrid"
    if [ "${gatewayAPI}" = "true" ]; then
        NOTE "Cilium Gateway API enabled"
        local ExtraValues=$ExtraValues",gatewayAPI.enabled=true"

        if [ "${gatewayHost}" = "true" ]; then
            # Enabling the Cilium Gateway API host network mode automatically disables the LoadBalancer type Service mode.
            # They are mutually exclusive.
            # The listener is exposed on all interfaces ( for IPv4 and/or for IPv6).
            NOTE "Cilium Gateway API host enabled"
            local ExtraValues=$ExtraValues",gatewayAPI.hostNetwork.enabled=true"
            # local ExtraValues=$ExtraValues",gatewayAPI.externalTrafficPolicy=~"
        fi
    fi
    if [ "${ingress}" = "true" ]; then
        NOTE "Cilium Ingress enabled"
        local ExtraValues=$ExtraValues",ingressController.enabled=${ingress}"
        local ExtraValues=$ExtraValues",ingressController.loadbalancerMode=shared"

        if [ "${ingressHost}" = "true" ]; then
            NOTE "Cilium Ingress host enabled"
            local ExtraValues=$ExtraValues",ingressController.hostNetwork.enabled=${ingressHost}"
            local ExtraValues=$ExtraValues",ingressController.service.externalTrafficPolicy=~"
        else
            local ExtraValues=$ExtraValues",ingressController.service.type=LoadBalancer"
            local ExtraValues=$ExtraValues",ingressController.service.insecureNodePort=80"
            local ExtraValues=$ExtraValues",ingressController.service.secureNodePort=443"
        fi
    fi
    if [ "${envoy}" = "true" ]; then
        local ExtraValues=$ExtraValues",envoy.enabled=true"
        local ExtraValues=$ExtraValues",securityContext.privileged=true"
        local ExtraValues=$ExtraValues",envoy.securityContext.privileged=true"

        local ExtraValues=$ExtraValues",envoy.securityContext.keepCapNetBindService=true"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[0]=NET_BIND_SERVICE"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[1]=NET_ADMIN"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[2]=IPC_LOCK"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[3]=SYS_MODULE"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[4]=SYS_ADMIN"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[5]=SYS_RESOURCE"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[6]=DAC_OVERRIDE"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[7]=FOWNER"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[8]=SETGID"
        local ExtraValues=$ExtraValues",envoy.securityContext.envoy[9]=SETUID"

        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.keepCapNetBindService=true"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[0]=NET_BIND_SERVICE"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[1]=NET_ADMIN"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[2]=IPC_LOCK"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[3]=SYS_MODULE"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[4]=SYS_ADMIN"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[5]=SYS_RESOURCE"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[6]=DAC_OVERRIDE"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[7]=FOWNER"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[8]=SETGID"
        local ExtraValues=$ExtraValues",envoy.securityContext.capabilities.envoy[9]=SETUID"

        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[0]=NET_BIND_SERVICE"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[1]=NET_ADMIN"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[2]=IPC_LOCK"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[3]=SYS_MODULE"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[4]=SYS_ADMIN"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[5]=SYS_RESOURCE"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[6]=DAC_OVERRIDE"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[7]=FOWNER"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[8]=SETGID"
        local ExtraValues=$ExtraValues",securityContext.capabilities.ciliumAgent[9]=SETUID"

        # local ExtraValues=$ExtraValues",loadBalancer.l7.backend=envoy"
    fi
    local ExtraValues="$(echo "$ExtraValues" | sed -E 's/,+/,/g')"

    # if command -v sealos &>/dev/null; then
    #     if ! command -v cilium &>/dev/null; then
    #         echo "cilium not installed, try to install with sealos"
    #         local cluster=$(getarg cluster $@)
    #         local cluster=${cluster:-"$CLUSTER"}

    #         # ip link delete flannel.1 2>/dev/null || true
    #         # ip link delete cni0 2>/dev/null || true
    #         # ip link delete cilium_vxlan 2>/dev/null || true

    #         NOTE "Cilium ExtraValues => ${ExtraValues}"
    #         # https://github.com/labring-actions/cluster-image/blob/main/applications/cilium
    #         sudo sealos run --cluster $cluster \
    #             -f ${labring_image_registry}/${labring_image_repository}/cilium:v${cilium_version} \
    #             --env ExtraValues="$ExtraValues"
    #     fi
    # fi

    if ! command -v cilium &>/dev/null; then
        echo "cilium not installed, try to install with cilium cli"
        local CILIUM_CLI_VERSION=$(curl -sfL ${GHPROXY}https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
        local CLI_ARCH=amd64
        if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
        curl -sfL --remote-name-all ${GHPROXY}https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
        sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
        sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
        rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

        cilium version --client
    fi

    if ! command -v cilium &>/dev/null; then
        ERROR "install cilium failed" && exit
    fi

    NOTE "cilium installed successfully"

    if kubectl -n kube-system get daemonset cilium &>/dev/null; then
        INFO "Cilium is already installed and running. No need to install again."
    else
        INFO "Cilium is not installed or not running. Installing..."
        if [ -z "$KUBECONFIG" ]; then
            ERROR "KUBECONFIG is not set" && exit 1
        fi

        local ExtraValues=${ExtraValues//,/ --set }
        eval "echo $ExtraValues && cilium install --version $cilium_version $ExtraValues"
    fi

    if [ "$(hasarg upgrade $@)" == true ]; then
        # local latest_version=$(get_github_release_version cilium/cilium)
        # local latest_version=${latest_version#v}
        local cilium_version=${cilium_version:-${latest_version}}
        NOTE "Upgrading Cilium to version $cilium_version"
        local ExtraValues=${ExtraValues//,/ --set }

        eval "echo $ExtraValues && cilium upgrade --version $cilium_version $ExtraValues"

        # eval "echo $ExtraValues && cilium upgrade \
        #     --version $latest_version \
        #     --reuse-values $ExtraValues \
        #     --set preflight.enabled=true \
        #     --set agent=false \
        #     --set operator.enabled=false \
        # "
    fi

    wait_for_cilium() {
        WARN "Waiting for Cilium to be ready..."
        for i in {1..120}; do
            local has_error=$(cilium status | grep "error")
            local has_waiting=$(cilium status | grep "Unavailable")
            if [ "$has_error" == "" ] && [ "$has_waiting" == "" ]; then
                INFO "Cilium is ready."
                return 0
            fi
            WARN "Cilium is not ready, waiting..."
            cilium status --wait
        done

        ERROR "Cilium did not become ready in the expected time."
        exit 1
    }
    wait_for_cilium

    # cilium version

    if [ "${gatewayAPI}" = "true" ]; then
        cilium config view | grep -w "enable-gateway-api"
        kubectl get gatewayclass cilium
    fi

}

k8s_uninstall_cilium() {
    cilium uninstall 2>/dev/null || true
    for node in $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'); do
        if kubectl describe node "$node" | grep -q 'node.cilium.io/agent-not-ready:NoSchedule'; then
            kubectl taint nodes "$node" node.cilium.io/agent-not-ready:NoSchedule-
        fi
    done
    kubectl get secret --all-namespaces | grep cilium | awk '{print "kubectl -n "$1" delete secret "$2}' | bash
    kubectl delete daemonset,deployment,svc,cm,secret,clusterrole,clusterrolebinding,role,rolebinding,sa -l k8s-app=cilium -A
}

k8s_uninstall_higress() {
    helm uninstall higress --namespace higress-system || true
    hgctl uninstall --purge-resources || true
}

k8s_install_higress() {
    local local=$(getarg local $@)
    local host=$(getarg host $@)
    local type=$(getarg type $@)
    local istio=$(getarg istio $@)
    local gateway=$(getarg gateway $@)
    local ingress_class=$(getarg ingress_class $@)
    local ingress_class=${ingress_class:-higress}

    echo "local=${local}"
    echo "host=${host}"
    echo "type=${type}"
    echo "istio=${istio}"
    echo "gateway=${gateway}"

    local VERSION=$(get_github_release_version "alibaba/higress")
    echo "latest hgctl version: $VERSION"
    curl -sfL ${GHPROXY}https://raw.githubusercontent.com/alibaba/higress/main/tools/hack/get-hgctl.sh |
        sed "s|https://github.com|${GHPROXY}https://github.com|g" |
        sed "s|downloadFile() {|downloadFile() {\nexport VERSION=${VERSION}|g" | bash

    # if command -v hgctl &> /dev/null; then
    #     echo y | hgctl install  \
    #     --set profile=k8s \
    #     --set global.enableIstioAPI=${gateway:-true} \
    #     --set global.enableGatewayAPI=${istio:-true} \
    #     --set charts.higress.url=https://higress.cn/helm-charts

    if command -v helm &>/dev/null; then
        helm repo add higress.io https://higress.cn/helm-charts
        helm upgrade --install higress -n higress-system higress.io/higress \
            --create-namespace \
            --render-subchart-notes \
            --set global.local=${local:-false} \
            --set global.ingressClass="${ingress_class}" \
            --set global.enableIstioAPI=${istio:-true} \
            --set global.enableGatewayAPI=${gateway:-true} \
            --set higress-core.gateway.replicas=1 \
            --set higress-core.gateway.kind=DaemonSet \
            --set higress-core.gateway.hostNetwork=${host:-false} \
            --set higress-core.gateway.service.type=${type:-LoadBalancer} \
            --set higress-core.gateway.resources.requests.cpu=256m \
            --set higress-core.gateway.resources.requests.memory=128Mi \
            --set higress-core.gateway.resources.limits.cpu=256m \
            --set higress-core.gateway.resources.limits.memory=128Mi \
            --set higress-core.controller.replicas=1 \
            --set higress-core.controller.service.type=ClusterIP \
            --set higress-core.controller.resources.requests.cpu=256m \
            --set higress-core.controller.resources.requests.memory=128Mi \
            --set higress-core.controller.resources.limits.cpu=256m \
            --set higress-core.controller.resources.limits.memory=128Mi \
            --set higress-core.pilot.replicaCount=1 \
            --set higress-core.pilot.resources.limits.cpu=256m \
            --set higress-core.pilot.resources.limits.memory=128Mi \
            --set higress-core.pilot.resources.requests.cpu=256m \
            --set higress-core.pilot.resources.requests.memory=128Mi \
            --set higress.console.replicas=1 \
            --set higress-console.service.type=NodePort \
            --set higress-console.resources.requests.cpu=128m \
            --set higress-console.resources.requests.memory=128Mi \
            --set higress-console.certmanager.enabled=false
        # --set higress-core.gateway.tolerations[0].key=node-role.kubernetes.io/control-plane \
        # --set higress-core.gateway.tolerations[0].operator=Exists \
        # --set higress-core.gateway.tolerations[0].effect=NoSchedule \
        # --set "higress-core.controller.nodeSelector.node-role\.kubernetes\.io\/control-plane=" \
        kubectl -n higress-system wait --for=condition=Ready pods --all
        kubectl get po -n higress-system
    elif command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version higress)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/higress:${latest_version} \
            -e HELM_OPTS=" \
    --set global.local=${local:-false} \
    --set global.ingressClass=higress \
    --set global.enableIstioAPI=${istio:-true} \
    --set global.enableGatewayAPI=${gateway:-true} \
    --set higress-core.gateway.replicas=1 \
    --set higress-core.gateway.hostNetwork=${host:-false} \
    --set higress-core.gateway.service.type=${type:-LoadBalancer} \
    --set higress-core.gateway.resources.requests.cpu=256m \
    --set higress-core.gateway.resources.requests.memory=128Mi \
    --set higress-core.gateway.resources.limits.cpu=256m \
    --set higress-core.gateway.resources.limits.memory=128Mi \
    --set higress-core.controller.replicas=1 \
    --set higress-core.controller.service.type=ClusterIP \
    --set higress-core.controller.resources.requests.cpu=256m \
    --set higress-core.controller.resources.requests.memory=128Mi \
    --set higress-core.controller.resources.limits.cpu=256m \
    --set higress-core.controller.resources.limits.memory=128Mi \
    --set higress-core.pilot.replicaCount=1 \
    --set higress-core.pilot.resources.limits.cpu=256m \
    --set higress-core.pilot.resources.limits.memory=128Mi \
    --set higress-core.pilot.resources.requests.cpu=256m \
    --set higress-core.pilot.resources.requests.memory=128Mi \
    --set higress.console.replicas=1 \
    --set higress-console.service.type=NodePort \
    --set higress-console.resources.requests.cpu=128m \
    --set higress-console.resources.requests.memory=128Mi \
    --set higress-console.certmanager.enabled=false \
    "
        kubectl -n higress-system wait --for=condition=Ready pods --all
        kubectl get po -n higress-system
        # kubectl port-forward service/higress-gateway -n higress-system 80:80 443:443
    fi

}

k8s_install_higress_console() {
    if command -v hgctl &>/dev/null; then
        hgctl dashboard
    else
        ERROR "higress console installation failed."
    fi
}

k8s_install_ingress_nginx() {
    local host=$(getarg host $@)
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version ingress-nginx)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/ingress-nginx:${latest_version} \
            -e HELM_OPTS="--set controller.hostNetwork=${host:-true} --set controller.kind=DaemonSet --set controller.service.type=NodePort"
        # 使用宿主机网络, DaemonSet保证每个节点都可以接管流量, 使用NodePort暴露端口
        # 至此可以应用可以使用 ingressClass=ingress 暴露服务; 值得注意的是, 如果服务不可用,可能LoadBalancer不会分配ExternalIP
    elif command -v helm &>/dev/null; then
        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update
        helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx \
            --namespace ingress-nginx \
            --create-namespace \
            --set controller.hostNetwork=${host:-true} \
            --set controller.kind=DaemonSet \
            --set controller.service.type=NodePort
    fi
}

k8s_install_kube_state_metrics() {
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version kube-state-metrics)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/kube-state-metrics:${latest_version}
    elif command -v helm &>/dev/null; then
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo update
        helm upgrade --install kube-state-metrics prometheus-community/kube-state-metrics
    fi
}

k8s_install_metrics_server() {
    if command -v sealos &>/dev/null 2>&1; then
        local cluster=$(getarg cluster $@)
        local cluster=${cluster:-"$CLUSTER"}
        local latest_version=$(get_sealos_release_version metrics-server)
        sudo sealos run --cluster $cluster \
            -f ${labring_image_registry}/${labring_image_repository}/metrics-server:${latest_version}
    elif command -v kubectl &>/dev/null; then
        kubectl apply -f ${GHPROXY}https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    elif command -v microk8s &>/dev/null; then
        microk8s.kubectl apply -f ${GHPROXY}https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    elif command -v helm &>/dev/null; then
        helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
        helm repo update
        helm upgrade --install metrics-server metrics-server/metrics-server
    fi
}

k8s_install_config() {
    system_install_k8s_config
}

k8s_install_core() {

    k8s_install_helm $@

    k8s_install_gateway_api $@

    k8s_install_cilium $@

    k8s_install_istio $@

    k8s_install_cert_manager $@

    k8s_install_metrics_server $@

    # k8s_install_kube_state_metrics $@

    k8s_install_openebs $@

    # k8s_install_longhorn $@

    # k8s_install_ingress_nginx $@

    k8s_install_higress $@

    # k8s_install_higress_console $@

}

k8s_install_namespace() {
    local namespace=$(getarg namespace $@)
    if [ -z "${namespace}" ]; then
        ERROR "namespace is required"
        return 1
    fi
    kubectl create namespace ${namespace}
}

k8s_install_gateway() {
    local domain=$(getarg domain $@)
    local name=$(getarg name $@)
    local name=$(echo ${name} | tr '.' '-')
    local name=${name:-wildcard-$(echo ${domain} | tr '.' '-')-gateway}
    local namespace=$(getarg namespace $@)

    if [ -z "${domain}" ]; then
        ERROR "domain is required"
        return 1
    fi

    cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: ${name}
  namespace: ${namespace:-default}
spec:
  gatewayClassName: cilium
  listeners:
  - name: http-root-${domain}
    port: 80
    protocol: HTTP
    hostname: "${domain}"
    allowedRoutes:
      namespaces:
        from: All
  - name: http-wildcard-${domain}
    port: 80
    protocol: HTTP
    hostname: "*.${domain}"
    allowedRoutes:
      namespaces:
        from: All
  - name: https-root-${domain}
    port: 443
    protocol: HTTPS
    hostname: "${domain}"
    tls:
      certificateRefs:
      - kind: Secret
        name: wildcard-${domain}-tls
    allowedRoutes:
      namespaces:
        from: All
  - name: https-wildcard-${domain}
    port: 443
    protocol: HTTPS
    hostname: "*.${domain}"
    tls:
      certificateRefs:
      - kind: Secret
        name: wildcard-${domain}-tls
    allowedRoutes:
      namespaces:
        from: All
EOF

    cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: ${name}-redirect-to-https
  namespace: ${namespace:-default}
spec:
  parentRefs:
    - name: ${name}
      namespace: ${namespace:-default}
      sectionName: http-root-${domain}
  hostnames:
    - "${domain}"
    - "*.${domain}"
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      filters:
        - type: RequestRedirect
          requestRedirect:
            scheme: https
            port: 443
            statusCode: 302

EOF

}

# https://kubernetes.github.io/ingress-nginx/examples/auth/basic/
k8s_install_route() {
    local name=$(getarg name $@)
    local namespace=$(getarg namespace $@)
    local service_name=$(getarg service_name $@)
    local service_port=$(getarg service_port $@)

    local routes=$(getarg routes $@)
    local routes=${routes:-${name}.localhost}
    local routes=$(echo ${routes[@]} | tr ',' ' ')
    local path_type=$(getarg path_type $@)
    local tlsSecret=$(getarg tls_secret $@)
    local sslRedirect=$(getarg ssl_redirect $@)

    local ingress_mode=$(getarg ingress_mode $@)
    local ingress_class=$(getarg ingress_class $@)
    local ingress_classes=$(kubectl get ingressclasses -o jsonpath='{.items[*].metadata.name}')
    if [ "$ingress_mode" == "" ] && [ -n "$ingress_classes" ]; then
        local ingress_mode="true"
    fi
    if [ "$ingress_mode" == "true" ] && [ "$ingress_class" == "" ] && [ -n "$ingress_classes" ]; then
        local ingress_class=$(echo "$ingress_classes" | awk '{print $1}')
    fi

    # https://github.com/kubernetes-sigs/gateway-api/blob/master/examples/gatewayclass.yaml
    local gateway=$(getarg gateway $@)
    local gateway_mode=$(getarg gateway_mode $@)
    local gateway_classes=$(kubectl get gatewayclasses.gateway.networking.k8s.io -A --no-headers | awk '{print $1 " " $2}')
    if [ "$gateway_mode" == "" ] && [ -n "${gateway_classes}" ]; then
        local gateway_mode="true"
    fi

    NOTE ">>> install routing rules for routes: ${routes}"
    local idx=0
    for route in $routes; do
        local domain=$(echo "$route" | awk -F. '{print $(NF-1)"."$NF}')
        local idx=$(expr $idx + 1)
        echo "--------------------------------------------------------------------------"
        echo "Creating route for: ${route} (gateway_mode=${gateway_mode})"
        if [ "${gateway_mode}" == "true" ]; then
            # ---------------------- Gateway API 模式 --------------------------
            cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: ${name}${idx}
  namespace: ${namespace:-default}
spec:
  parentRefs:
  - name: ${gateway:-wildcard-$(echo ${domain} | tr '.' '-')-gateway}
    namespace: ${namespace:-default}
  hostnames:
  - ${route}
  rules:
  - matches:
    - path:
        type: ${path_type:-PathPrefix}
        value: /
    backendRefs:
    - name: ${service_name:-${name}}
      port: ${service_port:-80}
EOF

        elif [ "${ingress_mode}" == "true" ]; then
            # ---------------------- Ingress 模式 --------------------------

            local annotations=""
            if [ -n "$tlsSecret" ]; then
                annotations="nginx.ingress.kubernetes.io/backend-protocol: 'HTTP'
    nginx.ingress.kubernetes.io/proxy-ssl-name: '${domain}'
    nginx.ingress.kubernetes.io/proxy-ssl-server-name: 'true'
    nginx.ingress.kubernetes.io/ssl-redirect: '${sslRedirect:-false}'"
                local tls="tls:
  - hosts:
    - \"${route}\"
    secretName: ${tlsSecret:-wildcard-${domain}-tls}"
            fi

            cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${name}${idx}
  namespace: ${namespace:-default}
  annotations:
    kubernetes.io/ingress.class: ${ingress_class:-nginx}
    ${annotations}
spec:
  ingressClassName: ${ingress_class:-nginx}
  rules:
  - host: ${route}
    http:
      paths:
      - path: "/"
        pathType: ${path_type:-ImplementationSpecific}
        backend:
          service:
            name: ${service_name:-${name}}
            port:
              number: ${service_port:-80}
  ${tls}
EOF

        fi
    done
}

###################################################################################################
#
# k8s app
#
###################################################################################################

k8s_install_frps() {

    local tmpdir=$(getarg tmpdir $@)
    local tmpdir=${tmpdir:-$TEMP}
    local tmpdir=${tmpdir:-"$(pwd)"}
    local tmpdir=${tmpdir}/.k8s_frps
    mkdir -p $tmpdir

    local namespace=$(getarg namespace $@ 2>/dev/null)
    local namespace=${namespace:-frp-system}
    local storage_class=$(getarg storage_class $@ 2>/dev/null)
    local storage_class=${storage_class:-""}

    local ingress_class=$(getarg ingress_class $@ 2>/dev/null)

    local service_type=$(getarg service_type $@ 2>/dev/null)
    local service_type=${service_type:-NodePort}

    local image=$(getarg image $@ 2>/dev/null)
    local image=${image:-docker.io/snowdreamtech/frps}

    kubectl create namespace $namespace 2>/dev/null || true

    local token=$(getarg token $@)
    local token=${token:-${TOKEN}}

    local CONTAINER_NAME=frps

    local FRPS_TOML=frps.toml
    local FRPS_YAML=frps.yaml

    local port_bind=$(getarg port_bind $@)
    local port_bind=${port_bind:-7000}

    local port_ui=$(getarg port_ui $@)
    local port_ui=${port_ui:-7500}

    local port_http=$(getarg port_http $@)
    local port_http=${port_http:-7501}

    local port_tcp=$(getarg port_tcp $@)
    local port_tcp=${port_tcp:-7502}

    cat <<EOF >${tmpdir}/${FRPS_TOML}
bindPort = ${port_bind}
tcpmuxHTTPConnectPort = ${port_tcp}
vhostHTTPPort = ${port_http}
webServer.addr = "0.0.0.0"
webServer.port = ${port_ui}
webServer.user = "${dashboard_user:admin}"
webServer.password = "${dashboard_password}"
auth.token = "${token}"
log.level = "debug"
log.maxDays = 7
log.disablePrintColor = false
detailedErrorsToClient = true
# 用于 HTTP 请求的自定义 404 页面
# custom404Page = "/path/to/404.html"
EOF

    echo "------------------------------------------------------"
    cat ${tmpdir}/${FRPS_TOML}
    echo "------------------------------------------------------"

    kubectl delete secret ${FRPS_TOML} -n ${namespace} 2>/dev/null || true
    kubectl create secret generic ${FRPS_TOML} -n ${namespace} --from-file=${tmpdir}/${FRPS_TOML}

    # local VERSION=$(get_github_release_version "fatedier/frp")

    cat <<EOF >${tmpdir}/${FRPS_YAML}
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: frps
  namespace: ${namespace}
  labels:
    app: frps
spec:
  selector:
    matchLabels:
      app: frps
  template:
    metadata:
      labels:
        app: frps
    spec:
      containers:
        - name: frps
          image: ${image}
          ports:
            - name: bind
              containerPort: ${port_bind}
            - name: http
              containerPort: ${port_http}
            - name: tcp
              containerPort: ${port_tcp}
            - name: ui
              containerPort: ${port_ui}
          volumeMounts:
            - name: config
              mountPath: "/etc/frp"
              readOnly: true
      volumes:
        - name: config
          secret:
            secretName: ${FRPS_TOML}
EOF

    kubectl delete -f ${tmpdir}/${FRPS_YAML} 2>/dev/null || true
    kubectl apply -f ${tmpdir}/${FRPS_YAML}

    echo "
apiVersion: v1
kind: Service
metadata:
  name: frps
  namespace: ${namespace:-default}
spec:
  type: ${service_type}
  ports:
    - protocol: TCP
      name: bind
      port: ${port_bind}
      targetPort: ${port_bind}
      nodePort: ${port_bind}
    - protocol: TCP
      name: http
      port: ${port_http}
      targetPort: ${port_http}
      nodePort: ${port_http}
    - protocol: TCP
      name: tcp
      port: ${port_tcp}
      targetPort: ${port_tcp}
      nodePort: ${port_tcp}
    - protocol: TCP
      name: ui
      port: ${port_ui}
      targetPort: ${port_ui}
      nodePort: ${port_ui}
  selector:
    app: frps
" | kubectl apply -f -

    local bind_routes=$(getarg bind_routes $@)
    local bind_routes=${bind_routes:-'frps.localhost'}

    local dashboard_routes=$(getarg dashboard_routes $@)
    local dashboard_routes=${dashboard_routes:-'frps-ui.localhost'}

    local http_routes=$(getarg http_routes $@)
    local http_routes=${http_routes:-'frp-http.localhost'}

    local tcp_routes=$(getarg tcp_routes $@)
    local tcp_routes=${tcp_routes:-'frp-tcp.localhost'}

    local tls_secret=$(getarg tls_secret $@)

    local srv_name=$(kubectl get service -n ${namespace} | grep frps | awk '{print $1}')

    k8s_install_route \
        --name frps-bind \
        --namespace ${namespace} \
        --ingress_class ${ingress_class} \
        --service_name $srv_name \
        --service_port $port_bind \
        --routes ${bind_routes} \
        --tls_secret ${tls_secret}

    k8s_install_route \
        --name frps-ui \
        --namespace ${namespace} \
        --ingress_class ${ingress_class} \
        --service_name $srv_name \
        --service_port $port_ui \
        --routes ${dashboard_routes} \
        --tls_secret ${tls_secret}

    k8s_install_route \
        --name frps-http \
        --namespace ${namespace} \
        --ingress_class ${ingress_class} \
        --service_name $srv_name \
        --service_port $port_http \
        --routes ${http_routes} \
        --tls_secret ${tls_secret}

    k8s_install_route \
        --name frps-tcp \
        --namespace ${namespace} \
        --ingress_class ${ingress_class} \
        --service_name $srv_name \
        --service_port $port_tcp \
        --routes ${tcp_routes} \
        --tls_secret ${tls_secret}

    rm -rf ${tmpdir}

    echo "------------------------------------------------------------------"
    echo "done"
    echo "------------------------------------------------------------------"
}

###################################################################################################
#
# menu entry
#
###################################################################################################

if [ "$(hasarg debug $@)" == "true" ] || [ "$(hasarg x $@)" == "true" ]; then
    set -x
fi

while [ $# -gt 0 ]; do
    case "$1" in
    --init)
        init
        ;;
    -set | --set)
        NOTE "================ set $2"
        eval "set_$2 $@"
        ;;
    -si | --si | --system-install)
        NOTE "================ system-install $2"
        eval "system_install_$2 $@"
        ;;
    -sr | --sr | --system-uninstall)
        NOTE "================ system-uninstall $2"
        eval "system_uninstall_$2 $@"
        ;;
    -di | --di | --docker-install)
        NOTE "================ docker-install $2"
        eval "docker_install_$2 $@"
        ;;
    -dr | --dr | --docker-uninstall)
        NOTE "================ docker-uninstall $2"
        eval "docker_uninstall_$2 $@"
        ;;
    -ki | --ki | --k8s-install)
        NOTE "================ k8s-install $2"
        k8s_install_config
        eval "k8s_install_$2 $@"
        ;;
    -kr | --kr | --k8s-uninstall)
        NOTE "================ k8s-uninstall $2"
        k8s_install_config
        eval "k8s_uninstall_$2 $@"
        ;;
    -onekey | --onekey)
        NOTE "================ onekey $2"
        eval "onekey_$2 $@"
        ;;
    *)
        # echo "Illegal option $1"
        ;;
    esac
    shift $(($# > 0 ? 1 : 0))
done
