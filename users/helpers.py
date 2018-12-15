import csv
import json
import requests

COLUMNS = [
    'twitch_user_id',
    'twitch_user_name',
    'twitch_followers',
    'twitch_videos_percentage_fortnite',
    'instagram',
    'email',
    'twitch_views',
    'twitch_videos_count_total',
    'twitch_videos_count_fortnite',
    'latest_stream_id',
    'latest_stream_view_count',
    'latest_stream_duration',
    'latest_stream_date',
]

HEADERS = {
    'Content-Type': "application/json",
    'Client-ID': "xrept5ig71a868gn7hgte55ky8nbsa",
}

def get_videos():
    url = "https://api.twitch.tv/helix/videos"
    videos = []
    pagination = None
    while len(videos) < 1000:
        print("helpers | get_videos | loop")
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
            url,
            headers=HEADERS,
            params=params,
        )
        if r.status_code != 200:
            break
        body = r.json()
        videos += body['data']
        pagination = body['pagination']['cursor']
    return videos

def get_channel(user):
    url = f"https://api.twitch.tv/kraken/channels/{user['twitch_user_name']}"
    params = {}
    r = requests.get(
        url,
        headers=HEADERS,
        params=params,
    )
    body = r.json()
    channel = body
    return channel

def get_channel_videos(user):
    url = f"https://api.twitch.tv/kraken/channels/{user['twitch_user_name']}/videos"
    params = {
        'broadcast_type': 'archive',
        'limit': '100',
    }
    r = requests.get(
        url,
        headers=HEADERS,
        params=params,
    )
    body = r.json()
    videos = body['videos']
    return videos

def get_users():
    with open('./users.csv', 'a+') as f:
        f.seek(0, 0)
        csv_reader = csv.DictReader(f)
        users = list(csv_reader)
    return users

def save_users(users):
    users.sort(key=lambda u: (
        -__make_int(u.get('twitch_followers', 0)),
        -__make_int(u.get('twitch_videos_percentage_fortnite', 0)),
        -__make_int(u.get('twitch_views', 0)),
        -__make_int(u.get('latest_stream_view_count', 0)),
    ))
    with open('./users.csv', 'w') as f:
        csv_writer = csv.DictWriter(f, fieldnames=COLUMNS)
        csv_writer.writeheader()
        for u in users:
            csv_writer.writerow(u)

def __make_int(s):
    s = str(s).strip()
    return int(s) if s else 0
