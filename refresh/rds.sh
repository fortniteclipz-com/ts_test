export TS_ENV='dev'
twitch_stitch_root="${PWD%/*/*}"

echo "rds | start | ts-$TS_ENV"
cd $twitch_stitch_root/ts_infra/migrations
if [ ! -d ./venv ]; then
    echo "rds | bootstrapping | ts-$TS_ENV"
    rm -rf ./venv
    rm -rf ./__pycache__
    /usr/local/Cellar/python/3.6.5_1/bin/python3 -m venv ./venv
    source venv/bin/activate
    pip3 install --process-dependency-links -r requirements.txt
    pip3 install --process-dependency-links -e $twitch_stitch_root/ts_shared/ts_config
    deactivate
fi

echo "rds | rebooting | ts-$TS_ENV"
aws rds reboot-db-instance --db-instance-identifier "ts-$TS_ENV"
aws rds wait db-instance-available --db-instance-identifier "ts-$TS_ENV"

echo "rds | remigrating | ts-$TS_ENV"
source venv/bin/activate
alembic downgrade base && alembic upgrade head
