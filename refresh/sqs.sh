# purge sqs
echo "sqs | start | twitch-stitch-media-dev"
qs=(
    "ts-clip-dead-dev"
    "ts-clip-dev"
    "ts-montage-dead-dev"
    "ts-montage-dev"
    "ts-stream--analyze-dead-dev"
    "ts-stream--analyze-dev"
    "ts-stream--initialize-dead-dev"
    "ts-stream--initialize-dev"
    "ts-stream-segment--analyze-dead-dev"
    "ts-stream-segment--analyze-dev"
    "ts-stream-segment--download-dead-dev"
    "ts-stream-segment--download-dev"
)
for q in ${qs[@]}; do
    echo "sqs | purging | ${q}"
    qurl="https://sqs.us-east-2.amazonaws.com/589344262905/${q}"
    aws sqs purge-queue --queue-url "${qurl}"
done
