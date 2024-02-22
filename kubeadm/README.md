# k8s cluster on Windows with mutltipass on hyperv and kubeadm

- [multipas](https://multipass.run/)[s](https://medium.com/critical-mass/multipass-e6f637a44e1d)
- [kubectl for windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
- [enable hyper-v](https://techcommunity.microsoft.com/t5/educator-developer-blog/step-by-step-enabling-hyper-v-for-use-on-windows-11/ba-p/3745905)
- [gsudo](https://github.com/gerardog/gsudo) or open admin terminal manually

```powershell
# create hyper-v switch for networking between nodes with constant IPs
gsudo New-VMSwitch -Name "kube" -Notes "for k8s networking" -SwitchType Private

# start the nodes, see cloud-init.yaml for configuration
.\start-nodes.ps1

# use the generated config (see output of start-nodes.ps1)
$env:KUBECONFIG = "....\k8s_config"

kubectl get all,no -A -o wide
```
