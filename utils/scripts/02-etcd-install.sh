#!/usr/bin/env bash

# 2. Core Concepts: ETCD for Begginers
# https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/aca3215861c1b91dc2588b4c27b246563ee827f3/docs/02-Core-Concepts/04-ETCD-For-Beginners.md

# Ejecutar solo en VM siendo root
[ "$(id -u)" -ne 0 ] && echo "Run as root." && exit 1
if [[ $(cat /sys/devices/virtual/dmi/id/product_name) != 'VirtualBox' ]]; then
    echo "For safety, run this only in a VM"
    exit 1
fi

# Just info
101_log(){
    cat << EOF >> /dev/null
{"level":"info","ts":"2024-12-25T20:36:33.739+0100","caller":"etcdmain/etcd.go:73","msg":"Running: ","args":["./etcd-v3.5.6-linux-amd64/etcd"]}
{"level":"warn","ts":"2024-12-25T20:36:33.739+0100","caller":"etcdmain/etcd.go:105","msg":"'data-dir' was empty; using default","data-dir":"default.etcd"}
{"level":"info","ts":"2024-12-25T20:36:33.740+0100","caller":"embed/etcd.go:124","msg":"configuring peer listeners","listen-peer-urls":["http://localhost:2380"]}
{"level":"info","ts":"2024-12-25T20:36:33.741+0100","caller":"embed/etcd.go:132","msg":"configuring client listeners","listen-client-urls":["http://localhost:2379"]}
{"level":"info","ts":"2024-12-25T20:36:33.742+0100","caller":"embed/etcd.go:306","msg":"starting an etcd server","etcd-version":"3.5.6","git-sha":"cecbe35ce","go-version":"go1.16.15","go-os":"linux","go-arch":"amd64","max-cpu-set":2,"max-cpu-available":2,"member-initialized":false,"name":"default","data-dir":"default.etcd","wal-dir":"","wal-dir-dedicated":"","member-dir":"default.etcd/member","force-new-cluster":false,"heartbeat-interval":"100ms","election-timeout":"1s","initial-election-tick-advance":true,"snapshot-count":100000,"max-wals":5,"max-snapshots":5,"snapshot-catchup-entries":5000,"initial-advertise-peer-urls":["http://localhost:2380"],"listen-peer-urls":["http://localhost:2380"],"advertise-client-urls":["http://localhost:2379"],"listen-client-urls":["http://localhost:2379"],"listen-metrics-urls":[],"cors":["*"],"host-whitelist":["*"],"initial-cluster":"default=http://localhost:2380","initial-cluster-state":"new","initial-cluster-token":"etcd-cluster","quota-backend-bytes":2147483648,"max-request-bytes":1572864,"max-concurrent-streams":4294967295,"pre-vote":true,"initial-corrupt-check":false,"corrupt-check-time-interval":"0s","compact-check-time-enabled":false,"compact-check-time-interval":"1m0s","auto-compaction-mode":"periodic","auto-compaction-retention":"0s","auto-compaction-interval":"0s","discovery-url":"","discovery-proxy":"","downgrade-check-interval":"5s"}
{"level":"info","ts":"2024-12-25T20:36:33.780+0100","caller":"etcdserver/backend.go:81","msg":"opened backend db","path":"default.etcd/member/snap/db","took":"37.433243ms"}
{"level":"info","ts":"2024-12-25T20:36:33.784+0100","caller":"etcdserver/raft.go:494","msg":"starting local member","local-member-id":"8e9e05c52164694d","cluster-id":"cdf818194e3a8c32"}
{"level":"info","ts":"2024-12-25T20:36:33.785+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d switched to configuration voters=()"}
{"level":"info","ts":"2024-12-25T20:36:33.785+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became follower at term 0"}
{"level":"info","ts":"2024-12-25T20:36:33.786+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"newRaft 8e9e05c52164694d [peers: [], term: 0, commit: 0, applied: 0, lastindex: 0, lastterm: 0]"}
{"level":"info","ts":"2024-12-25T20:36:33.786+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became follower at term 1"}
{"level":"info","ts":"2024-12-25T20:36:33.786+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d switched to configuration voters=(10276657743932975437)"}
{"level":"warn","ts":"2024-12-25T20:36:33.789+0100","caller":"auth/store.go:1234","msg":"simple token is not cryptographically signed"}
{"level":"info","ts":"2024-12-25T20:36:33.792+0100","caller":"mvcc/kvstore.go:393","msg":"kvstore restored","current-rev":1}
{"level":"info","ts":"2024-12-25T20:36:33.793+0100","caller":"etcdserver/quota.go:94","msg":"enabled backend quota with default value","quota-name":"v3-applier","quota-size-bytes":2147483648,"quota-size":"2.1 GB"}
{"level":"info","ts":"2024-12-25T20:36:33.795+0100","caller":"etcdserver/server.go:854","msg":"starting etcd server","local-member-id":"8e9e05c52164694d","local-server-version":"3.5.6","cluster-version":"to_be_decided"}
{"level":"info","ts":"2024-12-25T20:36:33.796+0100","caller":"etcdserver/server.go:738","msg":"started as single-node; fast-forwarding election ticks","local-member-id":"8e9e05c52164694d","forward-ticks":9,"forward-duration":"900ms","election-ticks":10,"election-timeout":"1s"}
{"level":"info","ts":"2024-12-25T20:36:33.797+0100","caller":"fileutil/purge.go:44","msg":"started to purge file","dir":"default.etcd/member/snap","suffix":"snap.db","max":5,"interval":"30s"}
{"level":"info","ts":"2024-12-25T20:36:33.797+0100","caller":"fileutil/purge.go:44","msg":"started to purge file","dir":"default.etcd/member/snap","suffix":"snap","max":5,"interval":"30s"}
{"level":"info","ts":"2024-12-25T20:36:33.798+0100","caller":"fileutil/purge.go:44","msg":"started to purge file","dir":"default.etcd/member/wal","suffix":"wal","max":5,"interval":"30s"}
{"level":"info","ts":"2024-12-25T20:36:33.799+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d switched to configuration voters=(10276657743932975437)"}
{"level":"info","ts":"2024-12-25T20:36:33.799+0100","caller":"embed/etcd.go:275","msg":"now serving peer/client/metrics","local-member-id":"8e9e05c52164694d","initial-advertise-peer-urls":["http://localhost:2380"],"listen-peer-urls":["http://localhost:2380"],"advertise-client-urls":["http://localhost:2379"],"listen-client-urls":["http://localhost:2379"],"listen-metrics-urls":[]}
{"level":"info","ts":"2024-12-25T20:36:33.799+0100","caller":"embed/etcd.go:586","msg":"serving peer traffic","address":"127.0.0.1:2380"}
{"level":"info","ts":"2024-12-25T20:36:33.800+0100","caller":"embed/etcd.go:558","msg":"cmux::serve","address":"127.0.0.1:2380"}
{"level":"info","ts":"2024-12-25T20:36:33.800+0100","caller":"membership/cluster.go:421","msg":"added member","cluster-id":"cdf818194e3a8c32","local-member-id":"8e9e05c52164694d","added-peer-id":"8e9e05c52164694d","added-peer-peer-urls":["http://localhost:2380"]}
{"level":"info","ts":"2024-12-25T20:36:34.790+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d is starting a new election at term 1"}
{"level":"info","ts":"2024-12-25T20:36:34.791+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became pre-candidate at term 1"}
{"level":"info","ts":"2024-12-25T20:36:34.792+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d received MsgPreVoteResp from 8e9e05c52164694d at term 1"}
{"level":"info","ts":"2024-12-25T20:36:34.792+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became candidate at term 2"}
{"level":"info","ts":"2024-12-25T20:36:34.793+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d received MsgVoteResp from 8e9e05c52164694d at term 2"}
{"level":"info","ts":"2024-12-25T20:36:34.793+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became leader at term 2"}
{"level":"info","ts":"2024-12-25T20:36:34.794+0100","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"raft.node: 8e9e05c52164694d elected leader 8e9e05c52164694d at term 2"}
{"level":"info","ts":"2024-12-25T20:36:34.803+0100","caller":"etcdserver/server.go:2563","msg":"setting up initial cluster version using v2 API","cluster-version":"3.5"}
{"level":"info","ts":"2024-12-25T20:36:34.804+0100","caller":"etcdserver/server.go:2054","msg":"published local member to cluster through raft","local-member-id":"8e9e05c52164694d","local-member-attributes":"{Name:default ClientURLs:[http://localhost:2379]}","request-path":"/0/members/8e9e05c52164694d/attributes","cluster-id":"cdf818194e3a8c32","publish-timeout":"7s"}
{"level":"info","ts":"2024-12-25T20:36:34.804+0100","caller":"embed/serve.go:100","msg":"ready to serve client requests"}
{"level":"info","ts":"2024-12-25T20:36:34.804+0100","caller":"membership/cluster.go:584","msg":"set initial cluster version","cluster-id":"cdf818194e3a8c32","local-member-id":"8e9e05c52164694d","cluster-version":"3.5"}
{"level":"info","ts":"2024-12-25T20:36:34.805+0100","caller":"api/capability.go:75","msg":"enabled capabilities for version","cluster-version":"3.5"}
{"level":"info","ts":"2024-12-25T20:36:34.805+0100","caller":"etcdserver/server.go:2587","msg":"cluster version is updated","cluster-version":"3.5"}
{"level":"info","ts":"2024-12-25T20:36:34.805+0100","caller":"embed/serve.go:146","msg":"serving client traffic insecurely; this is strongly discouraged!","address":"127.0.0.1:2379"}
{"level":"info","ts":"2024-12-25T20:36:34.806+0100","caller":"etcdmain/main.go:44","msg":"notifying init daemon"}
{"level":"info","ts":"2024-12-25T20:36:34.806+0100","caller":"etcdmain/main.go:50","msg":"successfully notified init daemon"}
EOF
}

instalar_iniciar(){
    mkdir /tmp/foo && cd $_
    curl -LO https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz
    tar xvzf etcd-v3.5.6-linux-amd64.tar.gz
    ./etcd-v3.5.6-linux-amd64/etcd #&
    101_log
}

operar(){
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
    
    # export ETCDCTL_API=3
}

# ---

if true; then
    instalar_iniciar
    # en nueva sesión shell, ya que la de ./etcd está ocupada
    operar
fi
