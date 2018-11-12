Role Name
=========

Role is to install Redis and configure it for:
Debian 8 & above (Ubuntu 14/16/18) and RedHat6 & 7 families

Requirements
------------

There are no current pre-requisites

Role Variables
--------------

Defaults are set as below:

ansible_become: yes
redis_path: /opt
redis_version: stable
redis_user: redis
redis_group: redis
port_redis: 6379
redis_logfile: /var/log/redis/redis.log
redis_work_dir: /var/lib/redis
redis_pid: /var/run/redis.pid



Dependencies
------------

There are no dependencies for this role to run.

Example Playbook
----------------



    - hosts: servers
      become: yes
      roles:
         - { role: redis.yml, redis_version: 4.0.11 }

License
-------

BSD

Author Information
------------------

Created By: Anshul Gupta

=======

# osm_redis

