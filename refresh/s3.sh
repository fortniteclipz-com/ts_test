# empty s3
ts_env=${1:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "s3 | start | ts_env=$ts_env | $region"
aws s3 rm "s3://ts-media-$ts_env" --recursive --profile sls-fortniteclipz --region $region
