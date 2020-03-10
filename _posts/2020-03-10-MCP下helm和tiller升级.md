---
layout: mypost
title: MCP��helm��tiller������
categories: [k8s]
---

## 1.����cfg01�ڵ㣬�޸�tiller�����ַ

- 1.����Ŀ¼
/srv/salt/reclass/classes/cluster/inspurtest/kubernetes
- �༭control.yml�ļ���tiller����汾������ͼ
![](https://niusdimage-1258441135.cos.ap-chengdu.myqcloud.com/img/20200310154611.png)
- ִ��salt�����master�ڵ�ˢ�ϣ���������
`salt -C 'I@kubernetes:master' state.sls kubernetes.master.kube-addons`
- ��k8s��master�ڵ㣬��װ��tiller��Ӧ�汾��helmclient
```
         $ wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
        $ tar -xvzf helm-v2.11.0-linux-amd64.tar.gz
        $ mv <unpacked_dir>/helm /usr/local/bin/helm
        $ helm init --client-only
```
- ��master�ڵ������µ�֤��
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
- ����helm-tiller-deploy.yaml�ļ�
```
$ helm init --dry-run --debug --tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ca.cert.pem  > helm-tiller-deploy.yml
```
- ���°�װtiller  
` kubectl apply -f helm-tiller-deploy.yml`

- �������ɵ�֤�飬�滻/root/.helm�µ�֤��
- ִ��helm ls --tls��֤�Ƿ������ɹ�