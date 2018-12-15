import helpers

users = helpers.get_users()
print("run_channels | users | get", len(users))

for u in users:
    print("= = = = = = = = = =")
    if \
        u['twitch_views'].isdigit() is not True or \
        u['twitch_followers'].isdigit() is not True \
    :
        print("- - - - - - - - - -")
        try:
            print("run_channels | channel | user ", u)
            channel = helpers.get_channel(u)
            print("run_channels | channel | channel ", channel)
            u['twitch_views'] = channel['views']
            u['twitch_followers'] = channel['followers']
        except Exception as e:
            print("\nrun_channels | channel | error", e, "\n")

    if \
        u['twitch_videos_count_total'].isdigit() is not True or \
        u['twitch_videos_count_fortnite'].isdigit() is not True or \
        u['twitch_videos_percentage_fortnite'].isdigit() is not True \
    :
        print("- - - - - - - - - -")
        try:
            print("run_channels | videos | user ", u)
            videos = helpers.get_channel_videos(u)
            print("run_channels | videos | videos", len(videos))
            fortnite_videos = list(filter(lambda uv: 'fortnite' in str(uv['game']).lower(), videos))
            print("run_channels | videos | fortnite_videos", len(fortnite_videos))
            u['twitch_videos_count_total'] = len(videos)
            u['twitch_videos_count_fortnite'] = len(fortnite_videos)
            u['twitch_videos_percentage_fortnite'] = int(u['twitch_videos_count_fortnite'] / u['twitch_videos_count_total'] * 100)
        except Exception as e:
            print("\nrun_channels | videos | error", e, "\n")

print("run_channels | users | save", len(users))
helpers.save_users(users)
