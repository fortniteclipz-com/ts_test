import ts_file

import json
import os
import requests

total_count = 0
for i, f in enumerate(sorted(os.listdir("./stress_test/twitch_clips"))):
    if i < 1:
        continue
    clips = ts_file.get_json(f"./stress_test/twitch_clips/{f}")

    for i, clip in enumerate(clips):

        print("clip", clip)
        r = requests.post("https://f5reyk0okj.execute-api.us-west-1.amazonaws.com/dev/clip",
            data=json.dumps(clip),
            headers={
                'Content-Type': "application/json",
                'x-api-key': "WrWSNRXYQP1zlK5vWFcmz6a4uF2za6876YHBSgy5",
            }
        )
        clip_id = r.json()
        total_count += 1
        print("clip_id", clip_id, total_count)
        # break
    break

print("total total_count", total_count)

