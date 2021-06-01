# ubuntu.focal64

A VM with python3.9 and a single node K8s cluster setup

### start VM
```sh
$ vagrant up
```

### get config for host access
```sh
$ ./get_kubeconfig.sh
```

### set KUBECONFIG for host access
```sh
$ source ./set_kubeconfig.sh
$ kubectl get all -A
```
