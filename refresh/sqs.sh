# purge sqs
ts_env=${1:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "sqs | start | ts_env=$ts_env | $region"

qs=(
    "ts-clip---$ts_env"
    "ts-clip---$ts_env---dead"
    "ts-montage---$ts_env"
    "ts-montage---$ts_env---dead"
    "ts-stream--analyze---$ts_env"
    "ts-stream--analyze---$ts_env---dead"
    "ts-stream--initialize---$ts_env"
    "ts-stream--initialize---$ts_env---dead"
    "ts-stream-segment--analyze---$ts_env"
    "ts-stream-segment--analyze---$ts_env---dead"
    "ts-stream-segment--download---$ts_env"
    "ts-stream-segment--download---$ts_env---dead"
)
for q in ${qs[@]}; do
    echo "sqs | purging | q=$q-$ts_env"
    aws sqs purge-queue --queue-url "https://sqs.$region.amazonaws.com/923755341410/$q" --profile sls-fortniteclipz --region $region
done

echo "sqs | done | ts_env=$ts_env | $region"
