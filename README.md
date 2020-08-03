# OSM: Redis

A high end ansible role to setup standalone or a cluster Redis with best practices in terms of security and performance tunning.

## Key Features

Here some key features of this ansible role:-

- Standalone/Cluster Setup
- Muti OS support i.e. RedHat and Debian
- Multiple version support
- Best Practices in terms of redis setup
- Security

## Requirements

No special requirement, only a privileged user is required to access server.

## Role Variables

We have categorized variables into two part i.e. **Manadatory** and **Optional**

### Mandatory Variables

|**Variables**| **Default Values**| **Possible Values** | **Description**|
|-------------|-------------------|---------------------|----------------|
| redis_password | `NotWeak@123` | *Any Strong Password* | Redis server password |
| redis_logfile | `/var/log/redis/redis.log` | *Any Linux Directory* | Logfile path of the redis server |
| redis_conf_file_location | `/etc/redis/cluster` | *Any Linux Directory* | Configuration file path for redis server |
| redis_dir | `/var/lib/redis` | *Any Linux Directory* |  Data directory for redis server |
| cluster_enabled | `true` | *true* or *false* | Redis setup in cluster mode or not |
| upgrade_redis | `false` | *true* or *false* | Whether you want to upgrade the existing redis cluster or not |

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
[standalone]
standalone1 ansible_ssh_host=23.92.28.137

[redis_nodes]
redisnode1 ansible_ssh_host=23.92.28.137
redisnode2 ansible_ssh_host=173.230.142.155
redisnode3 ansible_ssh_host=50.116.35.169

[master_nodes]
masternode1 ansible_ssh_host=23.92.28.137 master_id=0
masternode2 ansible_ssh_host=173.230.142.155 master_id=1
masternode3 ansible_ssh_host=50.116.35.169 master_id=2

[slave_nodes]
slavenode1 ansible_ssh_host=23.92.28.137 master_id=2
slavenode2 ansible_ssh_host=173.230.142.155 master_id=0
slavenode3 ansible_ssh_host=50.116.35.169 master_id=1

[redis_cluster:children]
master_nodes
slave_nodes

[cluster_formation_node]
masternode1

[redis_cluster:vars]
redis_port=6379
master_redis_port=6379
slave_redis_port=6380

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=root
```

## Example Playbook

Here is an example playbook:-

```yml
---
- hosts: redis_nodes
  become: true
  roles:
    - osm_redis

- hosts: redis_cluster
  become: true
  roles:
    - osm_redis
```

## Usage

For using this role you have to execute playbook only

```shell
ansible-playbook -i hosts site.yml
```

## Running Test Cases for Setup

For running the test cases, we have a seperate folder named inspec. Inspec (https://www.inspec.io/) should be installed if you want to run the test cases.

Command which needs to be run

```shell
inspec exec . -t ssh://username@server_ip -i /path/to/keyfile
```

### Test Results

```
Profile: Test cases for OSM Redis Cluster (redis-osm-test-cases)
Version: 0.1.0
Target:  ssh://root@173.230.142.155:22

  ✔  redis-rules-01: Redis user and group check
     ✔  User redis should exist
     ✔  User redis shell should eq "/sbin/nologin"
     ✔  Group redis should exist
  ✔  redis-rules-02: Redis file and permissions check
     ✔  File /var/log/redis should exist
     ✔  File /var/log/redis owner should eq "redis"
     ✔  File /var/log/redis group should eq "redis"
     ✔  File /var/log/redis mode should cmp == "0755"
     ✔  File /etc/systemd/system/redis.service should exist
     ✔  File /etc/systemd/system/redis.service owner should eq "root"
     ✔  File /etc/systemd/system/redis.service group should eq "root"
     ✔  File /etc/systemd/system/redis.service mode should cmp == "0644"
     ✔  File /etc/redis/cluster/redis.conf should exist
     ✔  File /etc/redis/cluster/redis.conf owner should eq "redis"
     ✔  File /etc/redis/cluster/redis.conf group should eq "redis"
     ✔  File /etc/redis/cluster/redis.conf mode should cmp == "0644"
  ✔  redis-rules-03: Redis service status
     ✔  Service redis should be installed
     ✔  Service redis should be enabled
     ✔  Service redis should be running
  ✔  redis-rules-04: Redis port status
     ✔  Port 6379 protocols should include "tcp"
     ✔  Port 6379 addresses should include "0.0.0.0"


Profile Summary: 4 successful controls, 0 control failures, 0 controls skipped
Test Summary: 20 successful, 0 failures, 0 skipped
```

## Author

[Abhishek Dubey](mailto:abhishek.dubey@opstree.com)
