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