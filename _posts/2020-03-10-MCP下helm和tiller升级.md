---
layout: mypost
title: MCP下helm和tiller的升级
categories: [k8s]
---

## 1.进入cfg01节点，修改tiller镜像地址

- 1.进入目录
/srv/salt/reclass/classes/cluster/inspurtest/kubernetes
- 编辑control.yml文件中tiller镜像版本，如下图
![](https://niusdimage-1258441135.cos.ap-chengdu.myqcloud.com/img/20200310154611.png)
- 执行salt命令，给master节点刷上，命令如下
`salt -C 'I@kubernetes:master' state.sls kubernetes.master.kube-addons`
- 在k8s的master节点，安装和tiller对应版本的helmclient
```
         $ wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
        $ tar -xvzf helm-v2.11.0-linux-amd64.tar.gz
        $ mv <unpacked_dir>/helm /usr/local/bin/helm
        $ helm init --client-only
```
- 在master节点生成新的证书
```
a.	Generate CA certs
$ openssl genrsa -out ./ca.key.pem 4096
$ openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca
b.	Generate certs for Tiller 
$ openssl genrsa -out ./tiller.key.pem 4096
$ openssl genrsa -out ./helm.key.pem 4096
$ openssl req -key tiller.key.pem -new -sha256 -out tiller.csr.pem
c.	Generate certs for helm client
$ openssl req -key helm.key.pem -new -sha256 -out helm.csr.pem
$ openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in tiller.csr.pem -out tiller.cert.pem -days 365
$ openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in tiller.csr.pem -out tiller.cert.pem -days 365
```
- 生成helm-tiller-deploy.yaml文件
```
$ helm init --dry-run --debug --tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ca.cert.pem  > helm-tiller-deploy.yml
```
- 重新安装tiller  
` kubectl apply -f helm-tiller-deploy.yml`

- 根据生成的证书，替换/root/.helm下的证书
- 执行helm ls --tls验证是否升级成功