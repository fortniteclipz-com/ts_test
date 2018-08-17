import ts_aws


stream = ts_aws.dynamodb.stream.get_stream(285219394)
print("dynamodb.stream.get_stream | stream", stream.__dict__)
