import ts_file

import json
import os
import requests

total_count = 0
for f in sorted(os.listdir("tmp/twitch_user_clips")):
    clips = ts_file.get_json(f"tmp/twitch_user_clips/{f}")

    for clip in clips:
        print("clip", clip)
        r = requests.post("https://arja6lpamg.execute-api.us-west-1.amazonaws.com/dev/clip",
            data=json.dumps(clip),
            headers={
                'Content-Type': "application/json",
                'x-api-key': "c7iRZ569TT7b3BsXbDQBS3Lx7Xrvc8o64zgg5q8r",
            }
        )
        clip_id = r.json()
        print("clip_id", clip_id)
        total_count += 1
        print("total_count", total_count)

print("total_count", total_count)

