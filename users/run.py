import csv
import json
import requests

print("start")
videos = []
pagination = None

while len(videos) < 1000:
    twitch_url = "https://api.twitch.tv/helix/videos"
    headers = {
        'Content-Type': "application/json",
        'Client-ID': "xrept5ig71a868gn7hgte55ky8nbsa",
    }
    params = {
        'game_id': '33214',
        'period': 'day',
        'sort': 'views',
        'language': 'en',
        'type': 'archive',
        'first': '100',
        'after': pagination,
    }
    r = requests.get(
        twitch_url,
        headers=headers,
        params=params,
    )
    if r.status_code != 200:
        break
    videos += r.json()['data']
    pagination = r.json()['pagination']['cursor']

videos.sort(key=lambda v: v['created_at'], reverse=False)
videos = list({v['user_id']:v for v in videos}.values())

with open('./users.csv', 'a+') as f:
    f.seek(0, 0)
    csv_reader = csv.DictReader(f)
    users = list(csv_reader)

user_ids = [u['user_id'] for u in users]
existing = [v for v in videos if v['user_id'] in user_ids]
new = [v for v in videos if v['user_id'] not in user_ids]

for e in existing:
    for u in users:
        if u['user_id'] == e['user_id']:
            u['user_name'] = e['user_name']
            u['latest_stream_id'] = e['id']
            u['latest_stream_view_count'] = e['view_count']
            u['latest_stream_duration'] = e['duration']
            u['latest_stream_date'] = e['created_at']

for n in new:
    users.append({
        'user_id': n['user_id'],
        'user_name': n['user_name'],
        'latest_stream_id': n['id'],
        'latest_stream_view_count': n['view_count'],
        'latest_stream_duration': n['duration'],
        'latest_stream_date': n['created_at'],
    })

users.sort(key=lambda u: int(u['latest_stream_view_count']), reverse=True)
with open('./users.csv', 'w') as f:
    fieldnames = ['user_id', 'user_name', 'instagram', 'email', 'latest_stream_id', 'latest_stream_view_count', 'latest_stream_duration', 'latest_stream_date']
    csv_writer = csv.DictWriter(f, fieldnames=fieldnames)
    csv_writer.writeheader()
    for u in users:
        csv_writer.writerow(u)

print("end")
