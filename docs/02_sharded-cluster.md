# Redis Sharded Cluster

A Redis cluster is simply a [data sharding strategy](https://www.digitalocean.com/community/tutorials/understanding-database-sharding). It automatically partitions data across multiple Redis nodes. It is an advanced feature of Redis which achieves distributed storage and prevents a single point of failure.

In case of any redis node failure, a follower node will automatically promote as the leader and whenever the old follower node will come back online, it will start acting as a follower. There are a minimum of 3 nodes required to build a Redis-sharded cluster with leader-only architecture. If we include followers as well, there will be at least 6 nodes/processes of Redis.

A sample reference inventory for redis cluster can be found [here](../inventory/cluster.ini):

```ini
[redis]
redis1 ansible_ssh_host=172.31.57.91
redis2 ansible_ssh_host=172.31.49.187
redis3 ansible_ssh_host=172.31.62.128

[redis_cluster:children]
leader
follower

[leader]
redis-leader1 ansible_ssh_host=172.31.57.91 redis_port=6379 exporter_port=9121 leader_id=0 node_status=ready
redis-leader2 ansible_ssh_host=172.31.49.187 redis_port=6379 exporter_port=9121 leader_id=1 node_status=ready
redis-leader3 ansible_ssh_host=172.31.62.128 redis_port=6379 exporter_port=9121 leader_id=2 node_status=ready

[follower]
redis-follower1 ansible_ssh_host=172.31.57.91 redis_port=6380 exporter_port=9122 leader_id=0 node_status=ready
redis-follower2 ansible_ssh_host=172.31.49.187 redis_port=6380 exporter_port=9122 leader_id=1 node_status=ready
redis-follower3 ansible_ssh_host=172.31.62.128 redis_port=6380 exporter_port=9122 leader_id=2 node_status=ready
```

## Sample Playbook

A sample playbook for sharded cluster setup is described as:

```yaml
---
- hosts: redis
  roles:
    - { role: redis, tags: ["preinstall", "redis"] }

- hosts: redis_cluster
  roles:
    - { role: redis-cluster, tags: ["install", "redis-cluster"] }
```

```shell
ansible-playbook -i inventory/cluster.ini cluster.yml
```

By default, the redis monitoring is enabled and if your setup doesn't require the redis exporter as part of monitoring setup. Disable the setup from [defaults/main.yml](../roles/redis-cluster/defaults/main.yml) or using command line option.

```shell
ansible-playbook -i inventory/cluster.ini cluster.yml \
  -e redis_monitoring_enabled=false -e redis_password="StrongPassword"
```
