# enable or disable events
action=${1:-'enable'}
echo "event | ts-jobs-dev | $action"

aws events list-rules --name-prefix ts-jobs-dev --profile sls-fortniteclipz --region us-east-1| jq -c '.Rules[]' | jq -c -r '.Name' | while read name; do
    if [ $action == "disable" ]; then
        echo "event | ts-jobs-dev | disabling | $name"
        aws events disable-rule --name $name --profile sls-fortniteclipz --region us-east-1
    else
        echo "event | ts-jobs-dev | enabling | $name"
        aws events enable-rule --name $name --profile sls-fortniteclipz --region us-east-1
    fi
done
