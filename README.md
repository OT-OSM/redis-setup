# OSM: Redis

A high end ansible role to setup standalone or a cluster Redis with best practices in terms of security and performance tunning.

## Key Features

Here some key features of this ansible role:-

- Standalone/Cluster Setup
- Muti OS support i.e. RedHat and Debian
- Multiple version support

## Requirements

No special requirement, only a privileged user is required.

## Role Variables

We have categorized variables into two part i.e. **Manadatory** and **Optional**

### Mandatory Variables

|**Variables**| **Default Values**| **Possible Values** | **Description**|
|-------------|-------------------|---------------------|----------------|
| redis_logfile | `/var/log/redis/redis.log` | *Any Linux Directory* | Logfile path of the redis server |
| redis_conf_file_location | `/etc/redis/cluster` | *Any Linux Directory* | Configuration file path for redis server |
| redis_dir | `/var/lib/redis` | *Any Linux Directory* |  Data directory for redis server |
| cluster_enabled | `true` | *true* or *false* | Redis setup in cluster mode or not |

We have some other mandatory variable under [vars](./vars) directory which can be changed as per need basis.

### Optional Variables

|**Variables**| **Default Values**| **Possible Values** | **Description**|
|-------------|-------------------|---------------------|----------------|
| redis_version | `stable` | *Valid Redis Version* | Version of redis which needs to be installed |
| redis_loglevel | `notice` | *debug* or *notice* | Loglevel on which redis will print logs |
| redis_maxclients | `10000` | *Valid integer count* | Maximum number of redis connections at a time |
| redis_databases | `16` | *Valid integer count* | Maximum number of databases can be created in redis |
| redis_db_filename | `dump.rdb` | *Valid Linux Path* | The file name for the RDB Backup |

We have some other mandatory variable under [defaults](./defaults) directory which can be changed as per need basis.

## Inventory

Inventory file for using this role will look like this:-

```ini
[redis-nodes]
 node1 ansible_ssh_host=redis1
 node2 ansible_ssh_host=redis2
 node3 ansible_ssh_host=redis3
 node4 ansible_ssh_host=redis4
 node5 ansible_ssh_host=redis5
 node6 ansible_ssh_host=redis6

[cluster-formation-node]
 node1

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=tony-stark
redis_port=6379
```

