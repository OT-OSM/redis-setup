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
ansible-playbook -i inventory/cluster.ini cluster.yml -e setup_mode=sharded
```

By default, the redis monitoring is enabled and if your setup doesn't require the redis exporter as part of monitoring setup. Disable the setup from [defaults/main.yml](../roles/redis-cluster/defaults/main.yml) or using command line option.

```shell
ansible-playbook -i inventory/cluster.ini cluster.yml \
  -e redis_monitoring_enabled=false -e redis_password="StrongPassword" -e setup_mode=sharded
```

## Adding node in cluster

This ansible automation is capable of adding nodes in the redis sharded cluster along with re-sharding. But instead of running the cluster.yml, we have to execute [add-node.yml](../playbooks/add-node.yml) to add nodes in the cluster.

We just need to add the nodes in the inventory like this:

```ini
[redis]
# Old redis nodes
redis1 ansible_ssh_host=172.31.57.91
redis2 ansible_ssh_host=172.31.49.187
redis3 ansible_ssh_host=172.31.62.128
# New nodes on which redis needs to be installed
redis4 ansible_ssh_host=172.31.53.190

[redis_cluster:children]
leader
follower

[leader]
# Old cluster nodes
redis-leader1 ansible_ssh_host=172.31.57.91 redis_port=6379 exporter_port=9121 leader_id=0 node_status=ready
redis-leader2 ansible_ssh_host=172.31.49.187 redis_port=6379 exporter_port=9121 leader_id=1 node_status=ready
redis-leader3 ansible_ssh_host=172.31.62.128 redis_port=6379 exporter_port=9121 leader_id=2 node_status=ready
# New node that need to be added in cluster as leader
redis-leader4 ansible_ssh_host=172.31.53.190 redis_port=6379 exporter_port=9121 leader_id=2 node_status=ready

[follower]
# Old cluster nodes
redis-follower1 ansible_ssh_host=172.31.57.91 redis_port=6380 exporter_port=9122 leader_id=0 node_status=ready
redis-follower2 ansible_ssh_host=172.31.49.187 redis_port=6380 exporter_port=9122 leader_id=1 node_status=ready
redis-follower3 ansible_ssh_host=172.31.62.128 redis_port=6380 exporter_port=9122 leader_id=2 node_status=ready
# New node that need to be added in cluster as follower
redis-follower4 ansible_ssh_host=172.31.53.190 redis_port=6379 exporter_port=9121 leader_id=2 node_status=ready
```

Once the inventory is prepared, we can execute the playbook like this:

```shell
ansible-playbook -i inventory/cluster.ini playbooks/add-node.yml
```

## Removing node from cluster

This ansible automation is capable of removing nodes in the redis sharded cluster along with re-sharding. But instead of running the cluster.yml, we have to execute [remove-node.yml](../playbooks/remove-node.yml) to remove node in the cluster.

We just need to change the `node_status` from ready to remove:

```ini
[redis]
# Old redis nodes
redis1 ansible_ssh_host=172.31.57.91
redis2 ansible_ssh_host=172.31.49.187
redis3 ansible_ssh_host=172.31.62.128
redis4 ansible_ssh_host=172.31.53.190

[redis_cluster:children]
leader
follower

[leader]
# Old cluster nodes
redis-leader1 ansible_ssh_host=172.31.57.91 redis_port=6379 exporter_port=9121 leader_id=0 node_status=ready
redis-leader2 ansible_ssh_host=172.31.49.187 redis_port=6379 exporter_port=9121 leader_id=1 node_status=ready
redis-leader3 ansible_ssh_host=172.31.62.128 redis_port=6379 exporter_port=9121 leader_id=2 node_status=ready
redis-leader4 ansible_ssh_host=172.31.53.190 redis_port=6379 exporter_port=9121 leader_id=2 node_status=ready

[follower]
# Old cluster nodes
redis-follower1 ansible_ssh_host=172.31.57.91 redis_port=6380 exporter_port=9122 leader_id=0 node_status=ready
redis-follower2 ansible_ssh_host=172.31.49.187 redis_port=6380 exporter_port=9122 leader_id=1 node_status=ready
redis-follower3 ansible_ssh_host=172.31.62.128 redis_port=6380 exporter_port=9122 leader_id=2 node_status=ready
# Redis node that needs to be removed
redis-follower4 ansible_ssh_host=172.31.53.190 redis_port=6379 exporter_port=9121 leader_id=2 node_status=remove
```

**Note: Make sure at a time, we remove only one node. This rule need to be followed strictly.**

Once the inventory changes are done, we need to execute the ansible playbook:

```shell
ansible-playbook -i inventory/cluster.ini playbooks/remove-node.yml
```
