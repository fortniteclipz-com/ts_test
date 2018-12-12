import helpers

csv_users = helpers.get_csv_users()
print("run_users | csv_users | get", len(csv_users))

filtered_csv_users = list(filter(lambda u: u['twitch_view_count'].isdigit() is not True, csv_users))
print("run_users | filtered_csv_users", len(filtered_csv_users))
twitch_users = helpers.get_twitch_users(filtered_csv_users)
print("run_users | twitch_users", len(twitch_users))

for tu in twitch_users:
    for cu in csv_users:
        if cu['twitch_user_id'] == tu['id']:
            cu['twitch_login'] = tu['login']
            cu['twitch_view_count'] = tu['view_count']

print("run_users | csv_users | save", len(csv_users))
helpers.save_csv_users(csv_users)
