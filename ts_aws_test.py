import ts_aws.dynamodb.stream


stream_segments = ts_aws.dynamodb.stream.get_stream_segments(285219394)


# print("\n\n")
# for ss in stream_segments:
#     print(ss.__dict__)
#     print("\n")


print("len(ss)", len(stream_segments))
