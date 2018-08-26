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
    r = requests.post("https://5aycqamkj3.execute-api.us-west-1.amazonaws.com/dev/clip",
        data=json.dumps(clip),
        headers={
            'Content-Type': "application/json",
            'x-api-key': "148fWahfDr8P2wd1nWuLf1SrbOsfZdZq3QEFLayp",
        }
    )
    clip_id = r.json()
    count += 1
    print(clip_id, f"{count}/{count_total}")

print("total count", count)

