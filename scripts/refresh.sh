twitch_stitch_root="${PWD%/*/*}"
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
    echo "emptying sqs ${q}..."
    qurl="https://sqs.us-west-2.amazonaws.com/589344262905/${q}"
    aws sqs purge-queue --queue-url "${qurl}"
done

echo "emptying s3 twitch-stitch-media-dev..."
aws s3 rm s3://twitch-stitch-media-dev --recursive
