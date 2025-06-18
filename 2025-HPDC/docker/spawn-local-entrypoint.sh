#!/usr/bin/env bash

num_cores_per_node=2
total_num_cores=$(nproc --all)
num_brokers=$(( $total_num_cores / $num_cores_per_node ))

/usr/bin/mpiexec.hydra -n $num_brokers -bind-to core:$num_cores_per_node /usr/bin/flux start /opt/global_py_venv/bin/jupyter-lab --ip=0.0.0.0
