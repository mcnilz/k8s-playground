multipass launch -vv --name node1 --cloud-init cloud-init-1.yaml --memory 3G `
    --cpus 4 --disk 6G --network name=kube,mode=manual,mac=52:54:00:4b:ab:cd `
    focal

multipass exec node1 sudo config-with-external-ip > k8s_config

$KUBECONFIG = (Resolve-Path .\k8s_config).Path
Write-Output "`$env:KUBECONFIG = `"$KUBECONFIG`""

multipass launch -vv --name node2 --cloud-init cloud-init-2.yaml --memory 2G `
    --cpus 4 --disk 6G --network name=kube,mode=manual,mac=52:54:00:4b:ab:ce `
    focal

$JOIN = multipass exec node1 -- sudo kubeadm token create --ttl=1m `
    --print-join-command --description "for node 2"

multipass exec node2 -- sudo sh -c $JOIN
