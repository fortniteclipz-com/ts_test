import ts_file

import re
import random
import requests

twitch_users = ts_file.get_json("./stress_test/twitch_users.json")

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

total_clips = 0
for tu in twitch_users:
    tu_id = tu['id']
    tu_login = tu['login']
    videosUrl = f"https://api.twitch.tv/helix/videos?user_id={tu_id}"
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

        for i in range(1, 6):
            random_time = random.randint(0, stream_duration)
            random_duration = random.randint(1, 6)
            time_in = random_time - random_duration
            time_out = random_time + random_duration
            if time_in < 0:
                time_in = 0
            if time_out > stream_duration:
                time_out = stream_duration

            user_clips.append({
                'stream_id': stream_id,
                'time_in': time_in,
                'time_out': time_out,
                'clip_duration': random_duration,
                'stream_duration': stream_duration,
                'twitch_user_id': tu_id,
                'twitch_login': tu_login,
            })

    random.shuffle(user_clips)
    ts_file.save_json(user_clips, f"./stress_test/twitch_clips/{tu_id}-{tu_login}.json")
    total_clips += len(user_clips)

print(total_clips)