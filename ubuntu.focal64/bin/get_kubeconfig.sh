#/usr/bin/env bash

vagrant ssh -c "sudo kubectl config view --flatten > /tmp/kubeconfig"
vagrant ssh -c "sed -i 's|server: http.*|server: https:\/\/192.168.33.11:6443|g' /tmp/kubeconfig"
vagrant ssh -c "cat /tmp/kubeconfig" > kubeconfig
