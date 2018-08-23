import ts_file

import json
import os
import requests

total_count = 0
for f in sorted(os.listdir("./stress_test/twitch_clips")):
    clips = ts_file.get_json(f"./stress_test/twitch_clips/{f}")

    for clip in clips:
        print("clip", clip)
        r = requests.post("https://wpsgbxj1f7.execute-api.us-west-1.amazonaws.com/dev/clip",
            data=json.dumps(clip),
            headers={
                'Content-Type': "application/json",
                'x-api-key': "Cw9LdgfLts9dBclr5m5lM6dDd5Hgmo0h1waLXEtH",
            }
        )
        clip_id = r.json()
        print("clip_id", clip_id)
        total_count += 1
        print("total_count", total_count)
    break

print("total_count", total_count)

