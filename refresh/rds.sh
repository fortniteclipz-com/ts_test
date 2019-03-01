export TS_ENV='dev'
twitch_stitch_root="${PWD%/*/*}"

echo "rds | resetting | twitch-stitch-$TS_ENV"
cd $twitch_stitch_root/ts_infra/migrations
if [ ! -d ./venv ]; then
    echo "rds | bootstrapping | twitch-stitch-$TS_ENV"
    rm -rf ./venv
    rm -rf ./__pycache__
    virtualenv ./venv -p /usr/local/bin/python3
    source venv/bin/activate
    pip3 install -r requirements.txt
    cd $twitch_stitch_root/ts_shared
    pip3 install -e ./ts_config
    deactivate
fi

echo "rds | rebooting | twitch-stitch-$TS_ENV"
cd $twitch_stitch_root/ts_infra/migrations
aws rds reboot-db-instance --db-instance-identifier "twitch-stitch-$TS_ENV"
aws rds wait db-instance-available --db-instance-identifier "twitch-stitch-$TS_ENV"

echo "rds | remigrating | twitch-stitch-$TS_ENV"
source venv/bin/activate
alembic downgrade base && alembic upgrade head
