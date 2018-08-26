import ts_file

import json
import os
import random
import requests

clips = []
for i, f in enumerate(sorted(os.listdir("./stress_test/twitch_clips"))):
    clips +=  ts_file.get_json(f"./stress_test/twitch_clips/{f}")

random.shuffle(clips)

count = 0
count_total = len(clips)
for clip in clips:
    print("---------------------------------")
    print(clip)
    r = requests.post("https://7fr5hm1jl3.execute-api.us-west-1.amazonaws.com/dev/clip",
        data=json.dumps(clip),
        headers={
            'Content-Type': "application/json",
            'x-api-key': "nue0J5muSj41s74xV3VB23ypl3BQC1El3oxxDudk",
        }
    )
    body = r.json()
    count += 1
    print(body['clip']['clip_id'], f"{count}/{count_total}")
    break

print("total count", count)

