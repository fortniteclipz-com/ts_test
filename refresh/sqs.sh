# purge sqs
ts_env=${1:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "sqs | start | ts_env=$ts_env | $region"

qs=(
    "ts-clip-dead"
    "ts-clip"
    "ts-montage-dead"
    "ts-montage"
    "ts-stream--analyze-dead"
    "ts-stream--analyze"
    "ts-stream--initialize-dead"
    "ts-stream--initialize"
    "ts-stream-segment--analyze-dead"
    "ts-stream-segment--analyze"
    "ts-stream-segment--download-dead"
    "ts-stream-segment--download"
)
for q in ${qs[@]}; do
    echo "sqs | purging | q=$q-$ts_env"
    aws sqs purge-queue --queue-url "https://sqs.$region.amazonaws.com/923755341410/$q-$ts_env" --profile sls-fortniteclipz --region $region
done

echo "sqs | done | ts_env=$ts_env | $region"
