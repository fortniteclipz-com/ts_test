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
    del clip['time_in']
    print(clip)
    r = requests.post("https://kum99llac4.execute-api.us-west-1.amazonaws.com/dev/clip",
        data=json.dumps(clip),
        headers={
            'Content-Type': "application/json",
            'x-api-key': "tbGNMmxCg95rPHZOn66664ffSq0CLrnbaNVytGDI",
        }
    )
    body = r.json()
    count += 1
    print(body['clip']['clip_id'], f"{count}/{count_total}")
    break

print("total count", count)

