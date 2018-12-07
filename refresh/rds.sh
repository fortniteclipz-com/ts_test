export ts_env='dev'
twitch_stitch_root="${PWD%/*/*}"

echo "rds | resetting | twitch-stitch-$ts_env"
cd $twitch_stitch_root/ts_infra/migrations
if [ ! -d ./venv ]; then
    echo "rds | bootstrapping | twitch-stitch-$ts_env"
    rm -rf ./venv
    rm -rf ./__pycache__
    virtualenv ./venv -p /usr/local/bin/python3
    source venv/bin/activate
    pip3 install --process-dependency-links -r requirements.txt
    cd $twitch_stitch_root/ts_shared
    pip3 install --process-dependency-links -e ./ts_config
    deactivate
fi

echo "rds | rebooting | twitch-stitch-$ts_env"
cd $twitch_stitch_root/ts_infra/migrations
aws rds reboot-db-instance --db-instance-identifier "twitch-stitch-$ts_env"
aws rds wait db-instance-available --db-instance-identifier "twitch-stitch-$ts_env"

echo "rds | remigrating | twitch-stitch-$ts_env"
source venv/bin/activate
alembic downgrade base && alembic upgrade head
