# enable or disable events
action=${1:-'enable'}
ts_env=${2:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "events | start | action=$action | ts_env=$ts_env | region=$region"

aws events list-rules --name-prefix "ts-jobs-$ts_env" --profile sls-fortniteclipz --region $region | jq -c '.Rules[]' | jq -c -r '.Name' | while read name; do
    if [ $action == "disable" ]; then
        echo "events | disabling | $name"
        aws events disable-rule --name $name --profile sls-fortniteclipz --region $region
    else
        echo "events | enabling | $name"
        aws events enable-rule --name $name --profile sls-fortniteclipz --region $region
    fi
done

echo "events | done | action=$action | ts_env=$ts_env | region=$region"
