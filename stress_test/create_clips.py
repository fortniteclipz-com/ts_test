stop_count = 1000
wait_time = 60

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
    r = requests.post("https://7udj2a8g4m.execute-api.us-west-1.amazonaws.com/dev/clip",
        data=json.dumps(clip),
        headers={
            'Content-Type': "application/json",
            'x-api-key': "sLQLoC7Uny4fkSm5nlL51iVCbQ0xEu3o91KST840",
        }
    )
    body = r.json()
    clip_id = body['clip']['clip_id']

    count += 1
    print(clip_id, f"{count}/{count_total}")
    if count >= stop_count:
        break
    else:
        time.sleep(wait_time)

print("final count", count)

