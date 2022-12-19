## Redis Replicated Cluster

At the base of Redis replication (excluding the high availability features provided as an additional layer by Redis Cluster or Redis Sentinel) there is a leader follower replication that is simple to use and configure. It allows replica Redis instances to be exact copies of leader instances. The replica will automatically reconnect to the leader every time the link breaks, and will attempt to be an exact copy of it regardless of what happens to the leader.

A sample reference inventory for redis cluster can be found [here](../inventory/replicated.ini):

```ini
[redis]
redis1 ansible_ssh_host=172.31.54.213
redis2 ansible_ssh_host=172.31.62.71
redis3 ansible_ssh_host=172.31.48.40

[redis_cluster:children]
leader
follower

[leader]
redis-leader1 ansible_ssh_host=172.31.54.213 redis_port=6379 exporter_port=9121

[follower]
redis-follower1 ansible_ssh_host=172.31.62.71 redis_port=6379 exporter_port=9121
redis-follower2 ansible_ssh_host=172.31.48.40 redis_port=6379 exporter_port=9121
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
ansible-playbook -i inventory/cluster.ini cluster.yml -e setup_mode=replicated
```

By default, the redis monitoring is enabled and if your setup doesn't require the redis exporter as part of monitoring setup. Disable the setup from [defaults/main.yml](../roles/redis-cluster/defaults/main.yml) or using command line option.

```shell
ansible-playbook -i inventory/cluster.ini cluster.yml \
  -e redis_monitoring_enabled=false -e redis_password="StrongPassword" -e setup_mode=replicated
```

## Sentinel Integration

In the redis leader-follower replication, automatic fail-over is not supported. For fail-over mechanism in leader-follower, we need to integrate Sentinel into the system.

We need to add sentinel servers inside the inventory file:

```ini
[redis]
redis1 ansible_ssh_host=172.31.54.213
redis2 ansible_ssh_host=172.31.62.71
redis3 ansible_ssh_host=172.31.48.40

[sentinel]
sentinel1 ansible_ssh_host=172.31.54.213 sentinel_port=26379 quorum_count=2
sentinel2 ansible_ssh_host=172.31.62.71 sentinel_port=26379 quorum_count=2
sentinel3 ansible_ssh_host=172.31.48.40 sentinel_port=26379 quorum_count=2

[redis_cluster:children]
leader
follower

[leader]
redis-leader1 ansible_ssh_host=172.31.54.213 redis_port=6379 exporter_port=9121

[follower]
redis-follower1 ansible_ssh_host=172.31.62.71 redis_port=6379 exporter_port=9121
redis-follower2 ansible_ssh_host=172.31.48.40 redis_port=6379 exporter_port=9121
```

After these changes, we simply need to execute playbook to integrate sentinel in the existing redis setup:

```shell
ansible-playbook -i inventory/cluster.ini cluster.yml -e setup_mode=replicated
```
