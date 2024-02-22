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

# start the nodes, see cloud-init.yaml for configuration
.\start-nodes.ps1

# use the generated config (see output of start-nodes.ps1)
$env:KUBECONFIG = "....\k8s_config"

# see what is going on
kubectl get all,no -A -o wide
```

## Cleanup

```powershell
multipass delete node1 node2 -p

# remove VMSwitch or keep it for next time
gsudo Remove-VMSwitch kube
```
