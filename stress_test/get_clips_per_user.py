import ts_file

import re
import random
import requests

twitch_users = ts_file.get_json("tmp/twitch_users_partial.json")

def get_video_duration(duration_string):
    digits = re.findall('\d+|\D+', duration_string)
    seconds = 0
    for number, unit in zip(digits[::2], digits[1::2]):
        if unit == "h":
            multiplier = 3600
        elif unit == "m":
            multiplier = 60
        elif unit == "s":
            multiplier = 1
        else:
            multiplier = 0
        seconds += (int(number) * multiplier)
    return seconds

for tu in twitch_users:
    tuid = tu['user_id']
    tulogin = tu['login']
    videosUrl = f"https://api.twitch.tv/helix/videos?user_id={tuid}"
    r = requests.get(videosUrl, headers={
        'Content-Type': "application/json",
        'Client-ID': "xrept5ig71a868gn7hgte55ky8nbsa"
    })
    videos = r.json()['data']

    user_clips = []
    for v in videos:
        stream_duration = get_video_duration(v['duration'])
        stream_id = int(v['id'])
        print("stream_id", stream_id)
        print("stream_duration", stream_duration)
        clip_time_in = 0
        while clip_time_in < stream_duration:
            clip_duration = random.randint(5, 30)
            clip_time_end = clip_time_in + clip_duration
            user_clips.append({
                'stream_id': stream_id,
                'time_in': clip_time_in,
                'time_out': clip_time_end,
                'clip_duration': clip_duration,
                'stream_duration': stream_duration,
                'twitch_user_id': tuid,
                'twitch_login': tulogin,
            })
            clip_time_in = clip_time_end

    ts_file.save_json(user_clips, f"tmp/twitch_user_clips/{tuid}-{tulogin}.json")
