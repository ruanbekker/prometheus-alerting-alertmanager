#!/bin/sh

if [ -z ${SLACK_WEBHOOK_URL} ] || [ -z ${ALERTMANAGER_URL} ] || [ -z ${DEVOPS_OPSGENIE_API_KEY} ] || [ -z ${API_GATEWAY_API_URL} ] || [ -z ${API_GATEWAY_API_KEY} ] || [ -z ${DEADMANSWITCH_API_URL} ] ;
  then
    echo "[ERROR] required devops environment variables does not exist"
    exit 1
fi

if [ -z ${SLACK_WEBHOOK_URL} ] || [ -z ${ALERTMANAGER_URL} ] || [ -z ${SUPPORT_OPSGENIE_API_KEY} ] ;
  then
    echo "[ERROR] required support environment variables does not exist"
    exit 1
fi

if [ -z ${SLACK_WEBHOOK_URL} ] || [ -z ${ALERTMANAGER_URL} ] || [ -z ${DATA_OPSGENIE_API_KEY} ] ;
  then
    echo "[ERROR] required data environment variables does not exist"
    exit 1
fi

echo "all environment variables are in place, replacing values in config"

sed -i "s|__SLACK_WEBHOOK_URL__|${SLACK_WEBHOOK_URL}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__ALERTMANAGER_URL__|${ALERTMANAGER_URL}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__DEVOPS_OPSGENIE_API_KEY__|${DEVOPS_OPSGENIE_API_KEY}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__SUPPORT_OPSGENIE_API_KEY__|${SUPPORT_OPSGENIE_API_KEY}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__DATA_OPSGENIE_API_KEY__|${DATA_OPSGENIE_API_KEY}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__API_GATEWAY_API_URL__|${API_GATEWAY_API_URL}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__API_GATEWAY_API_KEY__|${API_GATEWAY_API_KEY}|g" /etc/alertmanager/alertmanager.yml
sed -i "s|__DEADMANSWITCH_API_URL__|${DEADMANSWITCH_API_URL}|g" /etc/alertmanager/alertmanager.yml

echo "config updated, starting service"

/bin/alertmanager \
  --config.file="/etc/alertmanager/alertmanager.yml" \
  --storage.path="/alertmanager" \
  --web.external-url="${ALERTMANAGER_URL}" \
  --web.listen-address=":9093"
