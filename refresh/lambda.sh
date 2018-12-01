action=${1:-'enable'}
echo "lamda | $action"

aws lambda list-event-source-mappings | jq -c '.EventSourceMappings[]' | jq -c -r '.UUID' | while read uuid; do
    if [ $action == "disable" ]; then
        echo "lamda | disabling | $uuid"
        aws lambda update-event-source-mapping --uuid $uuid --no-enabled
    else
        echo "lamda | enabling | $uuid"
        aws lambda update-event-source-mapping --uuid $uuid --enabled
    fi
done
