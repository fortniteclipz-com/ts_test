action=${1:-'enable'}
ts_env=${2:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "lamda | start | action=$action | ts_env=$ts_env | region=$region"

aws lambda list-event-source-mappings --profile sls-fortniteclipz --region $region | jq -c '.EventSourceMappings[]' | jq -c -r '.UUID' | while read uuid; do
    if [ $action == "disable" ]; then
        echo "lamda | disabling | $uuid"
        aws lambda update-event-source-mapping --uuid $uuid --no-enabled --profile sls-fortniteclipz --region $region
    else
        echo "lamda | enabling | $uuid"
        aws lambda update-event-source-mapping --uuid $uuid --enabled --profile sls-fortniteclipz --region $region
    fi
done

echo "lamda | done | action=$action | ts_env=$ts_env | region=$region"
