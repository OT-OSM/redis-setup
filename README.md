# OSM Redis Setup

OSM Redis Setup is a bundle of roles, playbooks, and inventories to set up different modes of redis like- standalone, sharded cluster, and replicated cluster, along with sentinel to handle fail-over. This ansible automation doesn't restrict to setting up any environment once, but also it can be used for change management, upgrading, and scaling the environment.

## Supported Features

Here the features which are supported by this automation:

- [Redis standalone setup](https://redis.io/docs/getting-started/)
- [Redis sharded cluster setup](https://redis.io/docs/management/scaling/)
- [Redis replication cluster setup](https://redis.io/docs/management/replication/)
- [Sentinel mode](https://redis.io/docs/management/sentinel/)
- [Redis monitoring with exporter](https://github.com/oliver006/redis_exporter)

Along with these features, the redis ansible automation supports the on-fly scaling and de-scaling of redis cluster with automatic re-sharding.

## Supported Platforms

- Debian 10.X
- Ubuntu 18.04
- Ubuntu 20.04
- Ubuntu 22.04
- RedHat and Centos 7
- RedHat and Centos 8

## Important Role Variables

| **Variable Name**        | **Default Value** | **Description**                                                           |
|--------------------------|-------------------|---------------------------------------------------------------------------|
| redis_password           | Opstree@1234      | The redis password for authentication purpose                             |
| redis_monitoring_enabled | true              | To enable redis monitoring with the redis-exporter                        |
| setup_mode               | sharded           | Setup mode for redis cluster, possible values - `replicated` or `sharded` |
| leader_redis_port        | 6379              | The listen port of redis leader to listen traffic                         |
| follower_redis_port      | 6380              | The listen port of redis follower to listen traffic                       |
| redis_sentinel_port      | 23679             | The redis sentinel port to listen traffic                                 |

The defined variables in the table are not only variables in the automation. There are other optional environment variables that can be configured or changed as per the user's requirement. The other environment variables are:

- [Redis Variables](roles/redis/defaults)
- [Redis Cluster Variables](roles/redis-cluster/defaults)
- [Redis Sentinel Variables](roles/sentinel/defaults)

### Default Properties

#### Ports

| **Port** | **Description**                  |
|----------|----------------------------------|
| 6379     | Redis standalone and leader port |
| 6380     | Redis follower port              |
| 26379    | Redis sentinel port              |

#### Directories and files

| **Directory and Files**                  | **Description**                                             |
|------------------------------------------|-------------------------------------------------------------|
| `/etc/redis/redis.conf`                  | Redis standalone configuration file                         |
| `/opt/redis/data`                        | Data directory for storing rdb files for redis standalone   |
| `/var/log/redis/redis.log`               | Log file where redis standalone service logs will be stored |
| `/etc/redis/cluster/leader/redis.conf`   | Redis leader configuration file                             |
| `/var/log/redis/leader/redis.log`        | Log file for redis leader service logs                      |
| `/var/lib/redis/leader`                  | Data directory for storing rdb files for redis leader       |
| `/etc/redis/cluster/follower/redis.conf` | Redis follower configuration file                           |
| `/var/log/redis/follower/redis.log`      | Log file for redis follower service logs                    |
| `/var/lib/redis/follower`                | Data directory for storing rdb files for redis follower     |

#### Systemd services

| **Service Name**                | **Description**                           |
|---------------------------------|-------------------------------------------|
| redis.service                   | Redis standalone systemd service          |
| redis-exporter.service          | Redis exporter standalone systemd service |
| redis-leader.service            | Redis leader systemd service              |
| redis-follower.service          | Redis follower systemd service            |
| redis-sentinel.service          | Redis sentinel systemd service            |
| redis-leader-exporter.service   | Redis exporter leader systemd service     |
| redis-follower-exporter.service | Redis exporter follower systemd service   |

