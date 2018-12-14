import helpers

csv_users = helpers.get_csv_users()
print("run_users_videos | csv_users | get", len(csv_users))

for cu in csv_users:
    if \
        cu['twitch_videos_count'].isdigit() is True and \
        cu['twitch_fortnite_count'].isdigit() is True and \
        cu['twitch_fortnite_percentage'].isdigit() is True \
    :
        continue

    try:
        print("run_users_videos | user ", cu)
        user_videos = helpers.get_twitch_user_videos(cu)
        print("run_users_videos | user_videos", len(user_videos))
        fortnite_user_videos = list(filter(lambda uv: 'fortnite' in str(uv['game']).lower(), user_videos))
        print("run_users_videos | fortnite_user_videos", len(fortnite_user_videos))
        cu['twitch_videos_count'] = len(user_videos)
        cu['twitch_fortnite_count'] = len(fortnite_user_videos)
        cu['twitch_fortnite_percentage'] = int(cu['twitch_fortnite_count'] / cu['twitch_videos_count'] * 100)
    except Exception as e:
        print("run_users_videos | !!exception!!", e)

print("run_videos | csv_users | save", len(csv_users))
helpers.save_csv_users(csv_users)
