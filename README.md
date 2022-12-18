# OSM Redis Setup

OSM Redis Setup is a bundle of roles, playbooks, and inventories to set up different modes of redis like- standalone, sharded cluster, and replicated cluster, along with sentinel to handle fail-over. This ansible automation doesn't restrict to setting up any environment once, but also it can be used for change management, upgrading, and scaling the environment.

## Supported Features

Here the features which are supported by this automation:-

- [Redis standalone setup](https://redis.io/docs/getting-started/)
- [Redis sharded cluster setup](https://redis.io/docs/management/scaling/)
- [Redis replication cluster setup](https://redis.io/docs/management/replication/)
- [Sentinel mode](https://redis.io/docs/management/sentinel/)
- [Redis monitoring with exporter](https://github.com/oliver006/redis_exporter)

Along with these features, the redis ansible automation supports the on-fly scaling and de-scaling of redis cluster with automatic re-sharding.

