#!/usr/bin/env bash

# TODO uncomment if we want multiple "nodes"
# num_cores_per_node=2
# total_num_cores=$(nproc --all)
# num_brokers=$(( $total_num_cores / $num_cores_per_node ))
# /usr/bin/mpiexec.hydra -n $num_brokers -bind-to core:$num_cores_per_node /usr/bin/flux start /opt/global_py_venv/bin/jupyter-lab --ip=0.0.0.0

# NOTE: do this if we only want a single "node"
if [[ $# -ne 1 ]]; then
    /usr/bin/flux start /opt/global_py_venv/bin/jupyter-lab --ip=0.0.0.0
else
    last_core_id=$(( $1 - 1 ))
    mkdir -p ${HOME}/.flux
    cat > ${HOME}/.flux/resource.toml <<EOF
[resource]
noverify = true

[[resource.config]]
hosts = "$(hostname)"
cores = "0-${last_core_id}"
EOF
    /usr/bin/flux start -c ${HOME}/.flux/resource.toml \
        /opt/global_py_venv/bin/jupyter-lab --ip=0.0.0.0
fi
