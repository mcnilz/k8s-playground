# k8s cluster on Windows with mutltipass on hyperv and kubeadm

## Required

- [multipas](https://multipass.run/)[s](https://medium.com/critical-mass/multipass-e6f637a44e1d)
- [kubectl for windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
- [enable hyper-v](https://techcommunity.microsoft.com/t5/educator-developer-blog/step-by-step-enabling-hyper-v-for-use-on-windows-11/ba-p/3745905)
- [gsudo](https://github.com/gerardog/gsudo) or open admin terminal manually

## Setup

```powershell
# create hyper-v switch for networking between nodes with constant IPs
gsudo New-VMSwitch -Name "kube" -SwitchType Private

# start the nodes, see cloud-init-1.yaml and cloud-init-2.yaml for configuration
.\start-nodes.ps1

# use the generated config (see output of start-nodes.ps1)
$env:KUBECONFIG = "....\k8s_config"

# see what is going on
kubectl get all,no -A -o wide
```

## Test a simple deployment

```powershell
kubectl create deployment whoami --image=traefik/whoami --port=80
kubectl expose deployment whoami --type LoadBalancer
kubectl get services whoami -o wide
# the EXTERNAL-IP is still pending on a fresh setup
```

### Use metalLB to automatically assign external IP

```powershell
# use script on node1 (see cloud-init-1.yaml) to setup metalLB with the single external IP of node1
multipass exec node1 setup-metallb

$NODE1_IP = (multipass info node1 --format json | ConvertFrom-Json).info.node1.ipv4[0]
curl http://$NODE1_IP
```

## Cleanup

```powershell
multipass delete node1 node2 -p

# remove VMSwitch or keep it for next time
gsudo Remove-VMSwitch kube
```
