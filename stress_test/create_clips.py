stop_count = 1

import ts_file

import json
import os
import random
import requests
import time

clips = []
for i, f in enumerate(sorted(os.listdir("./stress_test/twitch_clips"))):
    clips +=  ts_file.get_json(f"./stress_test/twitch_clips/{f}")

random.shuffle(clips)

count = 0
count_total = len(clips)
print("count_total", count_total)
for clip in clips:
    print("---------------------------------")
    print(clip)
    r = requests.post("https://2inrogtf64.execute-api.us-west-1.amazonaws.com/dev/clip",
        data=json.dumps(clip),
        headers={
            'Content-Type': "application/json",
            'x-api-key': "esCRou33IB6OpbrgTtnWT3VLkJ4QlCyl3JzVW5jE",
        }
    )
    body = r.json()
    clip_id = body['clip']['clip_id']
    print(clip_id, f"{count}/{count_total}")

    count += 1
    if count >= stop_count:
        break
    else:
        time.sleep(60)

print("final count", count)

