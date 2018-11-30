aws events disable-rule --name `aws events list-rules --name-prefix ts-jobs-dev | jq -r '.Rules[0].Name'`
./sqs.sh
./s3.sh
./rds.sh
aws events enable-rule --name `aws events list-rules --name-prefix ts-jobs-dev | jq -r '.Rules[0].Name'`

