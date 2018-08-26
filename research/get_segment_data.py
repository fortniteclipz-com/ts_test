import ts_aws.dynamodb.stream
import ts_aws.s3
import ts_http
import ts_logger
import ts_media

import os

logger = ts_logger.get(__name__)

segments = [{
    'stream_id': 294393295,
    'segment': 477,
}]

for s in segments:
    segment = s['segment']
    stream_id = s['stream_id']
    dir_base = f"tmp/{stream_id}/{segment}"

    # get stream_segment from dynamodb
    ss = ts_aws.dynamodb.stream.get_stream_segment(stream_id, segment)
    logger.info("stream_segment", stream_segment=ss)
    if ss:
        logger.info("downloading and processing raw segment on mac")
        media_filename = f"{dir_base}/{ss.padded}.ts"
        ts_http.download_file(ss.url_media_raw, media_filename)

        media_filename_video = f"{dir_base}/{ss.padded}_mac_video.ts"
        media_filename_audio = f"{dir_base}/{ss.padded}_mac_audio.ts"
        packets_filename_video = f"{dir_base}/{ss.padded}_mac_video.json"
        packets_filename_audio = f"{dir_base}/{ss.padded}_mac_audio.json"
        ts_media.split_media_video(media_filename, media_filename_video)
        ts_media.split_media_audio(media_filename, media_filename_audio)
        ts_media.probe_media_video(media_filename_video, packets_filename_video)
        ts_media.probe_media_audio(media_filename_audio, packets_filename_audio)

        logger.info("freshing raw segment mac")
        media_filename_video_fresh = f"{dir_base}/{ss.padded}_mac_video_fresh.ts"
        packets_filename_video_fresh = f"{dir_base}/{ss.padded}_mac_video_fresh.json"
        gop = ts_media.calculate_gop(media_filename_video)
        ts_media.fresh_media_video(gop, media_filename_video, media_filename_video_fresh)
        ts_media.probe_media_video(media_filename_video_fresh, packets_filename_video_fresh)

        if ss.is_init_raw():
            logger.info("getting raw segment from s3 for lambda")
            media_filename_video = f"{dir_base}/{ss.padded}_lambda_video.ts"
            media_filename_audio = f"{dir_base}/{ss.padded}_lambda_audio.ts"
            packets_filename_video = f"{dir_base}/{ss.padded}_lambda_video.json"
            packets_filename_audio = f"{dir_base}/{ss.padded}_lambda_audio.json"
            ts_aws.s3.download_file(ss.key_media_video, media_filename_video)
            ts_aws.s3.download_file(ss.key_media_audio, media_filename_audio)
            ts_aws.s3.download_file(ss.key_packets_video, packets_filename_video)
            ts_aws.s3.download_file(ss.key_packets_audio, packets_filename_audio)

        if ss.is_init_fresh():
            logger.info("getting fresh segment from s3 for lambda")
            media_filename_video_fresh = f"{dir_base}/{ss.padded}_lambda_video_fresh.ts"
            packets_filename_video_fresh = f"{dir_base}/{ss.padded}_lambda_video_fresh.json"
            ts_aws.s3.download_file(ss.key_media_video_fresh, media_filename_video_fresh)
            ts_aws.s3.download_file(ss.key_packets_video_fresh, packets_filename_video_fresh)

