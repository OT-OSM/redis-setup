# Redis Standalone

Redis standalone is a single process of redis on a virtual machine. Different applications and services can connect to it. To setup standalone redis, we need to prepare an inventory like this:

```ini
[redis]
redis-server ansible_ssh_host=172.31.53.97
```

Reference can be found [here](../inventory/standalone.ini)

## Sample Playbook

A sample playbook for standalone setup can be referred like this:

```yaml
---
- hosts: redis
  vars:
    redis_monitoring_enabled: true
  roles:
    - { role: redis, tags: ["preinstall", "redis"] }
```

By default, the redis monitoring is enabled and if your setup doesn't require the redis exporter as part of monitoring setup. Disable the setup from [vars/main.yml](../roles/redis/vars/main.yml) or command line option.

```shell
ansible-playbook -i inventory/standalone.ini standalone.yml \
  -e redis_monitoring_enabled=false -e redis_password="StrongPassword"
```
