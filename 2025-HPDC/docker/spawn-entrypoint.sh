#!/usr/bin/env bash
# Copyright 2025 Lawrence Livermore National Security, LLC and other
# Benchpark developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: Apache-2.0

num_cores_per_node=2
total_num_cores=$(nproc --all)
num_brokers=$(( $total_num_cores / $num_cores_per_node ))

/usr/bin/mpiexec.hydra -n $num_brokers -bind-to core:$num_cores_per_node /usr/bin/flux start /opt/global_py_venv/bin/jupyterhub-singleuser
