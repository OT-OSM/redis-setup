Redis
=========
Introduction
-------------
The role is to deploy a redis cluster across multiple machines.<br />
Compatible with most versions of RHEL/CentOS 6.x 7.x

Dependencies
------------
No-Dependencies

Contents
------------

Installation <br />
Getting Started <br />
Redis Cluster<br />
Single Redis node -- Pending<br />
Master-Slave Replication -- Pending<br />
Redis Sentinel -- Pending<br />
Role Variables<br />

Installation
-------------
```
ansible-playbook test.yml
```

Operating System Supported
---------------------------
Compatible with most versions of RHEL/CentOS 6.x 7.x

Getting Started
----------------

Below are a few example playbooks and configurations for deploying a variety of Redis architectures.
This role expects to be run as root or as a user with sudo privileges.

Redis Cluster
-------------

Example Playbook
----------------
Here, we are creating groups, one for defining nodes on which redis is going to install and other group in which we define redis instance which is going to connect all redis instances using redis-cli command.
```
[redis-nodes]
#13.232.126.40 ansible_user=ec2-user ansible_ssh_private_key_file=/home/opstree/Downloads/rediskeys.pem
node1 ansible_ssh_host=192.168.0.185 ansible_user=vagrant ansible_ssh_pass=vagrant
node2 ansible_ssh_host=192.168.0.186 ansible_user=vagrant ansible_ssh_pass=vagrant
node3 ansible_ssh_host=192.168.0.187 ansible_user=vagrant ansible_ssh_pass=vagrant
node4 ansible_ssh_host=192.168.0.188 ansible_user=vagrant ansible_ssh_pass=vagrant
node5 ansible_ssh_host=192.168.0.176 ansible_user=vagrant ansible_ssh_pass=vagrant
node6 ansible_ssh_host=192.168.0.191 ansible_user=vagrant ansible_ssh_pass=vagrant

[link-cluster]
node1
```
And Example playbook: 
```
---
- hosts: redis-nodes
  vars:
   redis_nodeip_port_list: "{{ groups['redis-nodes'] | map('extract', hostvars, ['ansible_ssh_host']) | join(':7000 ') }}:7000"
   redis_cluster_replicas: 0
  gather_facts: true
  become: true
  roles:
    - osm_redis

  post_tasks:
   - name: Link the cluster together
     command: "redis-cli --cluster create {{redis_nodeip_port_list}}  --cluster-replicas {{redis_cluster_replicas}}"
     args:
        stdin: "yes"
     when: inventory_hostname in groups['link-cluster']
```
Note: Here we use redis_cluster_replicas variable for define replication/slaves of master nodes.

Use Cases for redis_cluster_replicas:
1. If you are using 3 instances then 
Set redis_cluster_replicas: 0 because redis cluster require minimum master nodes

2. If you are using 6 instances then 
Setting redis_cluster_replicas: 0 Causes 6 master nodes
Setting redis_cluster_replicas: 0 Causes 3 master nodes with 3 slaves, where each master have there specific 1 slave.




Role Variables
--------------

```
############## redis.conf variable###################

##### GENERAL CONFIGURATION
redis_supervised: "no"
redis_always_show_logo: "yes"
redis_daemonize: "no"
redis_pidfile: "/var/run/redis-{{- redis_port -}}.pid"
# Number of databases to allow
redis_databases: 16
redis_loglevel: notice
# Logging
redis_logfile: "/var/log/redis/redis.log"

##### CLUSTER
redis_cluster_enabled: "yes"
# redis_cluster_replicas: 0
redis_cluster_node_timeout: 5000
redis_cluster_config_file: /etc/redis/cluster/nodes.conf
#############################################

##### SNAPSHOTTING
# How frequently to snapshot the database to disk
# e.g. "900 1" => 900 seconds if at least 1 key changed
redis_save:
  - 900 1
  - 300 10
  - 60 10000
redis_stop_writes_on_bgsave_error: "yes"
redis_rdbcompression: "yes"
redis_rdbchecksum: "yes"
# the file name for the RDB Backup
redis_db_filename: "dump.rdb"
redis_dir: "/var/lib/redis"



#### SLOW LOGS
# Log queries slower than this many milliseconds. -1 to disable
redis_slowlog_log_slower_than: 10000
# Maximum number of slow queries to save
redis_slowlog_max_len: 128

##### APPENDONLY MODE
redis_appendonly: "no"
redis_appendfilename: "appendonly.aof"
redis_appendfsync: "everysec"
redis_no_appendfsync_on_rewrite: "no"
redis_auto_aof_rewrite_percentage: "100"
redis_auto_aof_rewrite_min_size: "64mb"

##### CLIENTS
# Max connected clients at a time
redis_maxclients: 10000


###### MEMORY MANAGEMENT 
redis_maxmemory: false
redis_maxmemory_policy: noeviction

###### NETWORKING/CONNECTION OPTIONS
redis_bind: "{{ ansible_ssh_host }}"
redis_port: 7000
redis_tcp_backlog: 511
redis_tcp_keepalive: 0
redis_protected_mode: "no"
redis_timeout: 0
# Socket options
# Set socket_path to the desired path to the socket. E.g. /var/run/redis/{{ redis_port }}.sock
redis_socket_path: false
redis_socket_perm: 755


############## redis.conf variable###################
redis_conf_file_location: /etc/redis/cluster
redis_runtime_directory: redis

# EPEL REPO
epel_repo_url: "https://dl.fedoraproject.org/pub/epel/epel-release-latest-{{ ansible_distribution_major_version }}.noarch.rpm"
epel_repo_gpg_key_url: "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-{{ ansible_distribution_major_version }}"
epel_repofile_path: "/etc/yum.repos.d/epel.repo"

## REMI REPO
remi_repo_url: "http://rpms.remirepo.net/enterprise/remi-release-{{ ansible_distribution_major_version }}.rpm"
```

Variables in var/main.yml
-----------------
To override, default value of variables defined in default/main.yml <br />
| Varibale | Value |
| :------- | :---: |
|redis_port | 7000  |
|redis_bind | ansible_ssh_host |
|redis_conf_file_location| /etc/redis/cluster |
|redis_logfile| /var/log/redis/redis.log |
|redis_runtime_directory| redis |
|redis_dir| /var/lib/redis |
|redis_slowlog_log_slower_than| 10000 |
|redis_maxmemory_policy| noeviction |

Author Information
------------------
Name: Arpeet Gupta <br />
Email: arpeet.gupta@opstree.com
