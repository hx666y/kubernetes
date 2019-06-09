cat > hongxuan-csr.json <<EOF
{
  "CN": "hongxuan",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "BeiJing",
      "ST": "BeiJing"
    }
  ]
}
EOF

cfssl gencert -ca=/root/k8s/k8s-cert/ca.pem -ca-key=/root/k8s/k8s-cert/ca-key.pem -config=/root/k8s/k8s-cert/ca-config.json -profile=kubernetes hongxuan-csr.json | cfssljson -bare hongxuan 

kubectl config set-cluster kubernetes \
  --certificate-authority=/root/k8s/k8s-cert/ca.pem \
  --embed-certs=true \
  --server=https://172.16.8.20:6443 \
  --kubeconfig=hongxuan-kubeconfig
  
kubectl config set-credentials hongxuan \
  --client-key=hongxuan-key.pem \
  --client-certificate=hongxuan.pem \
  --embed-certs=true \
  --kubeconfig=hongxuan-kubeconfig

kubectl config set-context default \
  --cluster=kubernetes \
  --user=hongxuan \
  --kubeconfig=hongxuan-kubeconfig

kubectl config use-context default --kubeconfig=hongxuan-kubeconfig
