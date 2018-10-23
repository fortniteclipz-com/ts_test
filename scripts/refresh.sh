qs=(
    "ts-clip"
    "ts-clip-dead"
    "ts-montage"
    "ts-montage-dead"
    "ts-stream--analyze"
    "ts-stream--analyze-dead"
    "ts-stream--initialize"
    "ts-stream--initialize-dead"
    "ts-stream-segment--analyze"
    "ts-stream-segment--analyze-dead"
    "ts-stream-segment--download"
    "ts-stream-segment--download-dead"
)
for q in ${qs[@]}; do
    echo "emptying sqs ${q}..."
    qurl="https://sqs.us-west-1.amazonaws.com/589344262905/${q}"
    aws sqs purge-queue --queue-url "${qurl}"
done

echo "emptying s3 twitch-stitch-main..."
aws s3 rm s3://twitch-stitch-main --recursive
