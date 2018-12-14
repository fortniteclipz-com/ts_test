import helpers

csv_users = helpers.get_csv_users()
print("run_videos | csv_users | get", len(csv_users))

twitch_videos = helpers.get_twitch_videos()
print("run_videos | twitch_videos | before", len(twitch_videos))
twitch_videos.sort(key=lambda v: v['created_at'], reverse=False)
twitch_videos = list({v['user_id']:v for v in twitch_videos}.values())
print("run_videos | twitch_videos | after", len(twitch_videos))

csv_twitch_user_ids = [cu['twitch_user_id'] for cu in csv_users]
existing_user_videos = [v for v in twitch_videos if v['user_id'] in csv_twitch_user_ids]
print("run_videos | existing_user_videos", len(existing_user_videos))
new_user_videos = [v for v in twitch_videos if v['user_id'] not in csv_twitch_user_ids]
print("run_videos | new_user_videos", len(new_user_videos))

for euv in existing_user_videos:
    for cu in csv_users:
        if cu['twitch_user_id'] == euv['user_id']:
            cu['twitch_user_name'] = euv['user_name']
            cu['latest_stream_id'] = euv['id']
            cu['latest_stream_view_count'] = euv['view_count']
            cu['latest_stream_duration'] = euv['duration']
            cu['latest_stream_date'] = euv['created_at']

for nuv in new_user_videos:
    csv_users.append({
        'twitch_user_id': nuv['user_id'],
        'twitch_user_name': nuv['user_name'],
        'latest_stream_id': nuv['id'],
        'latest_stream_view_count': nuv['view_count'],
        'latest_stream_duration': nuv['duration'],
        'latest_stream_date': nuv['created_at'],
    })

print("run_videos | csv_users | save", len(csv_users))
helpers.save_csv_users(csv_users)
