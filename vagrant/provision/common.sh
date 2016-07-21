set -e -u -o pipefail

function qpushd {
    pushd $@ > /dev/null
}

function qpopd {
    popd $@ > /dev/null
}

function get_real_path {
    local PATH

    if [[ -d $1 ]]; then
        qpushd $1
        PATH=$(pwd -P)
    else
        qpushd $(dirname $1)
        PATH="$(pwd -P)/$(basename $1)"
    fi

    qpopd
    echo $PATH
}

VAGRANT_DIR=$(get_real_path "$(dirname $0)/..")
SSH_DIR="$VAGRANT_DIR/ssh"

