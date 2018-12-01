action=${1:-'enable'}
echo "event | $action"

aws events list-rules --name-prefix ts-jobs-dev | jq -c '.Rules[]' | jq -c -r '.Name' | while read name; do
    if [ $action == "disable" ]; then
        echo "event | disabling | $name"
        aws events disable-rule --name $name
    else
        echo "event | enabling | $name"
        aws events enable-rule --name $name
    fi
done
