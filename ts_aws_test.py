import ts_aws.dynamodb.stream
import ts_aws.dynamodb.stream_segment


ss = ts_aws.dynamodb.stream_segment.StreamSegment(
    stream_id=623,
    segment=6,
    padded="006",
    time_duration=17,
    time_in=6,
    time_out=23,
    url_media_raw="www.twitch-stitch.com",
    _status=ts_aws.dynamodb.stream_segment.StreamSegmentStatus.FRESHED
)

freshed = ts_aws.dynamodb.stream_segment.StreamSegmentStatus.FRESHED
downloaded = ts_aws.dynamodb.stream_segment.StreamSegmentStatus.DOWNLOADED
print("downloaded", downloaded)
print("freshed", freshed)
print("downloaded >= freshed", downloaded >= freshed)
print("freshed >= downloaded", freshed >= downloaded)

print("ss", ss.__dict__)
