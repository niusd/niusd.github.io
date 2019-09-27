---
layout: mypost
title: openstack相关记录
categories: [openstack]
---

## cinder 相关操作

* `cinder backup-list  /列出所有的backup`
* `cinder --os-volume-api-version 3.43 backup-create  --metadata creator="niusd" --name {nackupName} {volumeID} /创建备份`
* `cinder backup show {backupID} /查看backup详情`

## 网络相关操作

* `systemctl restart neutron-openvswitch-agent /重启ovs`
* `openstack port list /查看所有的port`
* `openstack port list|grep {ip}  /根据ip筛选port`
* `openstack port show {portID}  /查看某个port的详情，如安全组等信息`

## 

