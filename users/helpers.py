import csv
import json
import requests

COLUMNS = [
    'twitch_user_id',
    'twitch_login',
    'twitch_user_name',
    'twitch_view_count',
    'latest_stream_id',
    'latest_stream_view_count',
    'latest_stream_duration',
    'latest_stream_date',
    'instagram',
    'twitter',
    'email',
]

def get_twitch_videos():
    twitch_url = "https://api.twitch.tv/helix/videos"
    headers = {
        'Content-Type': "application/json",
        'Client-ID': "xrept5ig71a868gn7hgte55ky8nbsa",
    }
    videos = []
    pagination = None
    while len(videos) < 1000:
        print("helpers | get_twitch_videos | loop")
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
    return videos

def get_twitch_users(csv_users):
    twitch_url = "https://api.twitch.tv/helix/users"
    headers = {
        'Content-Type': "application/json",
        'Client-ID': "xrept5ig71a868gn7hgte55ky8nbsa",
    }
    twitch_users = []
    start = 0
    while start < len(csv_users):
        print("helpers | get_twitch_users | loop", start)
        params = {
            'id': list(map(lambda u: u['twitch_user_id'], csv_users[start:start+100]))
        }
        r = requests.get(
            twitch_url,
            headers=headers,
            params=params,
        )
        twitch_users += r.json()['data']
        start += 100
    return twitch_users

def get_csv_users():
    with open('./users.csv', 'a+') as f:
        f.seek(0, 0)
        csv_reader = csv.DictReader(f)
        csv_users = list(csv_reader)
    return csv_users

def save_csv_users(csv_users):
    csv_users.sort(key=lambda u: (
        -__make_int(u.get('twitch_view_count', 0)),
        -__make_int(u.get('latest_stream_view_count', 0)),
    ))
    with open('./users.csv', 'w') as f:
        csv_writer = csv.DictWriter(f, fieldnames=COLUMNS)
        csv_writer.writeheader()
        for u in csv_users:
            csv_writer.writerow(u)

def __make_int(s):
    s = str(s).strip()
    return int(s) if s else 0
