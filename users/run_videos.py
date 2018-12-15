import helpers

users = helpers.get_users()
print("run_videos | users | get", len(users))

videos = helpers.get_videos()
print("run_videos | videos | before", len(videos))
videos.sort(key=lambda v: v['created_at'], reverse=False)
videos = list({v['user_id']:v for v in videos}.values())
print("run_videos | videos | after", len(videos))

csv_twitch_user_ids = [u['twitch_user_id'] for u in users]
existing_user_videos = [v for v in videos if v['user_id'] in csv_twitch_user_ids]
print("run_videos | existing_user_videos", len(existing_user_videos))
new_user_videos = [v for v in videos if v['user_id'] not in csv_twitch_user_ids]
print("run_videos | new_user_videos", len(new_user_videos))

for euv in existing_user_videos:
    for u in users:
        if u['twitch_user_id'] == euv['user_id']:
            u['twitch_user_name'] = euv['user_name']
            u['latest_stream_id'] = euv['id']
            u['latest_stream_view_count'] = euv['view_count']
            u['latest_stream_duration'] = euv['duration']
            u['latest_stream_date'] = euv['created_at']

for nuv in new_user_videos:
    users.append({
        'twitch_user_id': nuv['user_id'],
        'twitch_user_name': nuv['user_name'],
        'latest_stream_id': nuv['id'],
        'latest_stream_view_count': nuv['view_count'],
        'latest_stream_duration': nuv['duration'],
        'latest_stream_date': nuv['created_at'],
    })

print("run_videos | users | save", len(users))
helpers.save_users(users)
