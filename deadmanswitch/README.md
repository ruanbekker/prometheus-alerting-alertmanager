## DeadManSwitch Webservice

- [Credit](https://github.com/jpweber/cole)

Register for a new timer id:

```
$ curl https://deadmanswitch-api.${MY_DOMAIN}/id
{"timerid":"bsq5otk02nrh18cbuu4g"}
```

define alertmanager.yml config:

```
$ cat alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'environment', 'severity', 'job']
  group_wait: 45s
  group_interval: 10m
  repeat_interval: 1h
  receiver: 'default-catchall-slack'
  routes:
  - match:
      alertname: DeadManSwitch
    receiver: critical-deadmanswitch-alert
    group_wait: 0s
    group_interval: 1m
    repeat_interval: 50s

receivers:
- name: 'critical-deadmanswitch-alert'
  webhook_configs:
    - url: 'https://deadmanswitch-api.mydomain.com/ping/bsq5otk02nrh18cbuu4g'
      send_resolved: false
```

define alert in prometheus:

```
$ cat /etc/prometheus/rules/deadmanswitch.rules
groups:
- name: deadmanswitch.rules
  rules:
  # allows us to trigger an alert when our Prometheus cluster is no longer functioning correctly.
  # https://jpweber.io/blog/taking-advantage-of-deadmans-switch-in-prometheus/
  - alert: DeadManSwitch
    expr: vector(1)
    labels:
      severity: warning
      team: devops
    annotations:
      title: "DeadManSwitch"
      summary: Alerting DeadManSwitch
      description: This is a DeadManSwitch meant to ensure that the entire Alerting pipeline is functional.
      impact: Alerting is down
      action: Follow runbook and determine why prometheus isnt working
      dashboard: https://grafana.mydomain.com/d/xxxxxxx/prometheus-alertmanager?orgId=1&refresh=5s
      runbook: https://wiki.mydomain.com/wiki/spaces/TST/pages/xxxxxxxxxx/Runbook+X
```

Include alert in prometheus:

```
$ cat prometheus.yml
cat /etc/prometheus/prometheus.yml
rule_files:
  - '/etc/prometheus/rules/deadmanswitch.rules'
```

with interval=60

```
time="2020-09-30T11:36:44Z" level=info msg="Starting application..."
time="2020-09-30T11:36:44Z" level=info msg="Using ENV Vars for configuration"
time="2020-09-30T11:37:04Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:37:04Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:38:04Z" level=info msg="Sending Alert. Missed deadman switch notification."
time="2020-09-30T11:38:04Z" level=info msg="slack method"
time="2020-09-30T11:38:05Z" level=info msg=ok
time="2020-09-30T11:38:36Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:38:36Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:39:36Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:39:36Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:40:36Z" level=info msg="Sending Alert. Missed deadman switch notification."
time="2020-09-30T11:40:36Z" level=info msg="slack method"
time="2020-09-30T11:40:36Z" level=info msg=ok
```

with interval=300

```
time="2020-09-30T11:40:11Z" level=info msg="Starting application..."
time="2020-09-30T11:40:11Z" level=info msg="Using ENV Vars for configuration"
time="2020-09-30T11:40:36Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:40:36Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:41:36Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:41:36Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:42:36Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:42:36Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:43:36Z" level=info msg="timerID: bsq5otk02nrh18cbuu4g"
time="2020-09-30T11:43:36Z" level=info msg="POST - /ping/bsq5otk02nrh18cbuu4g"
```
