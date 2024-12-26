# Certified Kubernetes Administrator (CKA) with Practice Tests

> [!NOTE]
> - https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests
> - https://github.com/kodekloudhub/certified-kubernetes-administrator-course


<details>
<summary>Índice</summary>

- [Certified Kubernetes Administrator (CKA) with Practice Tests](#certified-kubernetes-administrator-cka-with-practice-tests)
  - [1. ~~Introduction~~](#1-introduction)
  - [2. Core Concepts](#2-core-concepts)
  - [3. Scheduling](#3-scheduling)
  - [4. Logging \& Monitoring](#4-logging--monitoring)
  - [5. Application Lifecycle Management](#5-application-lifecycle-management)
  - [6. Cluster Maintenance](#6-cluster-maintenance)
  - [7. Security](#7-security)
  - [8. Storage](#8-storage)
  - [9. Networking](#9-networking)
  - [10. Design and Install a Kubernetes Cluster](#10-design-and-install-a-kubernetes-cluster)
  - [11. Install "Kubernetes the kubeadm way"](#11-install-kubernetes-the-kubeadm-way)
  - [12. End-to-End Tests on a Kubernetes Cluster](#12-end-to-end-tests-on-a-kubernetes-cluster)
  - [13. Troubleshooting](#13-troubleshooting)
  - [14. Other Topics](#14-other-topics)
  - [15. Lightning Labs](#15-lightning-labs)
  - [16. Mock Exams](#16-mock-exams)
  - [17. Course Conclusion](#17-course-conclusion)


</details>

---

## 1. ~~Introduction~~

## 2. Core Concepts

<!-- ### Cluster: Runtime, ETCD, API, Controller, Scheduler, Kubelet, Proxy -->

- Cluster Arquitecture
- Docker VS ContainerD
  - Open Container Initiative: imagespec + runtimespec: Container Runtime Interface (compatibilidad necesaria para K8s)
  - **containerD** CLI tools (debugging): `ctr` `nerdctl` `crictl` (critcl de K8s, compatibilidad universal)
- ETCD For Beginners <!--more info when discussing HA topics-->
  - History: 2013==v0.1, 2015==v2, 2017==v3.1, 2018==CNCF_Incubation (OJO API diffs 2~3; desde v3.5, APIv3 by default)
  - Definition: *distributed reliable **key-value store** that is Simple, Secure and Fast*
  - Install ETCD: [./utils/scripst/02-etcd-install.sh](#)

```bash
# tldr etcdctl
# vagrant up && vagrant ssh

{
mkdir /tmp/foo && cd $_
curl -LO https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz
tar xvzf etcd-v3.5.6-linux-amd64.tar.gz

./etcd-v3.5.6-linux-amd64/etcd #&
  # {"level":"info","ts":"2024-12-25T20:36:33.800+0100","caller":"membership/cluster.go:421","msg":"added member","cluster-id":"cdf818194e3a8c32","local-member-id":"8e9e05c52164694d","added-peer-id":"8e9e05c52164694d","added-peer-peer-urls":["http://localhost:2380"]}
  # {"level":"info","ts":"2024-12-25T20:36:34.804+0100","caller":"etcdserver/server.go:2054","msg":"published local member to cluster through raft","local-member-id":"8e9e05c52164694d","local-member-attributes":"{Name:default ClientURLs:[http://localhost:2379]}","request-path":"/0/members/8e9e05c52164694d/attributes","cluster-id":"cdf818194e3a8c32","publish-timeout":"7s"}
}
{
cp /tmp/foo/etcd-v3.5.6-linux-amd64/etcdctl /usr/local/bin
echo "alias edc='etcdctl'" >> ~/.zshrc && source ~/.zshrc

etcdctl put key1 value1
  # OK
etcdctl get key1
  # key1
  # value1
# etcdctl --help

etcdctl version
  # etcdctl version: 3.5.6
  # API version: 3.5
}
```

- ETCD in Kubernetes
  - Datastore: polled by `kubectl`: info nodes, pods, configs, secrets, accounts, roles, bindings, etc.
  - Changes attempted > updated on ETCD > considered completed
  - SETUP manual: OJO Certs más adelante; OJO `--advertise-client-urls`: ETCD listening address, to be **used by Kube-API server to reach the ETCD server**

```bash
wget -q --https-only "https://github.com/etcd-io/etcd/releases/download/v3.3.11/etcd-v3.3.11-linux-amd64.tar.gz"

# ETCD_NAME=''
# INTERNAL_IP=''
# CONTROLLER0_IP=''
# CONTROLLER1_IP=''

cat << EOF >> **/etcd.service
ExecStart=/usr/local/bin/etcd \\
  -- name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/kubernetes.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-adverrtise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls  https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379, \\
  # advertise-client-urls: ETCD listening address, to be used by Kube-API server to reach the ETCD server
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  # initial-cluster: different ETCD server instances in HA
  --initial-cluster controller-0=https://${CONTROLLER0_IP}:2380,controller-1=https://${CONTROLLER1_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
EOF
```
- - SETUP kubeadm:
```bash
# En el PaaS no existe el POD !!
kubectl get pod etcd-master  -n kube-system

# Consultar toda la datastore
kubectl exec etcd-master -n kube-system etcdctl get / --prefix -keys-only
  # Registry: minios, pods, replicasets, deployments, roles, secrets...
```
- - HA: multiple master nodes, multiple ETCD instances, ojo con `--initial-cluster`
- ETCD Commands (Optional)
```bash
# export ETCDCTL_API=3
etcdctl snapshot save 
etcdctl endpoint health
etcdctl get
etcdctl put

# Apart from that, you must also specify path to certificate files so that ETCDCTL can authenticate to the ETCD API Server. The certificate files are available in the etcd-master at the following path. We discuss more about certificates in the security section of this course. So don't worry if this looks complex:
# So for the commands I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:
kubectl exec etcd-master -n kube-system -- \
  sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/etcd/server.crt \
  --key /etc/kubernetes/pki/etcd/server.key" 
```
- Kube-API Server
- Kube Controller Manager
- Kube Scheduler
- Kubelet
- Kube Proxy

<!-- ### DEMO TEST 01 -->

- Recap Pods
- Pods with YAML
- DEMO: Pods with YAML
- Practice TEST Introduction
- DEMO: Accessing Labs
- COURSE Setup: Accessing the Labs
- Practice TEST: Pods + Solution
- Recap ReplicaSet
- Practice TEST: ReplicaSets + Solution
- Deployments
- Certification Tip!
- Practice TEST: Deployments
- Services
- Services Cluster IP
- Services: LoadBalancer
- Practice TEST: Services + Solution
- Namespaces
- Pratice TEST: Namespaces + Solution
- Imperative VS Declarative
- Cert TIPS: Imperative COmmands with Kubectl
- Practice TEST: Imperative COmmands + Solution
- Kubectl Apply COmmand



## 3. Scheduling
## 4. Logging & Monitoring
## 5. Application Lifecycle Management
## 6. Cluster Maintenance
## 7. Security
## 8. Storage
## 9. Networking
## 10. Design and Install a Kubernetes Cluster
## 11. Install "Kubernetes the kubeadm way"
## 12. End-to-End Tests on a Kubernetes Cluster
## 13. Troubleshooting
## 14. Other Topics
## 15. Lightning Labs
## 16. Mock Exams
## 17. Course Conclusion

