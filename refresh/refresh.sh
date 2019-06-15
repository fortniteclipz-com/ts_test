ts_env=${1:-'dev'}

./event.sh disable $ts_env
./sqs.sh $ts_env
./s3.sh $ts_env
./rds.sh $ts_env
./event.sh enable $ts_env

