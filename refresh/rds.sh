export TS_ENV='dev'
echo "rds | start | ts-dev"

twitch_stitch_root="${PWD%/*/*}"
cd $twitch_stitch_root/ts_infra/migrations
if [ ! -d ./venv ]; then
    echo "rds | bootstrapping | ts-dev"
    rm -rf ./venv
    rm -rf ./__pycache__
    /usr/local/Cellar/python/3.6.5_1/bin/python3 -m venv ./venv
    source venv/bin/activate
    pip3 install --process-dependency-links -r requirements.txt
    pip3 install --process-dependency-links -e $twitch_stitch_root/ts_shared/ts_config
    deactivate
fi

echo "rds | rebooting | ts-dev"
aws rds reboot-db-instance --db-instance-identifier "ts-dev" --profile sls-fortniteclipz --region us-east-1
aws rds wait db-instance-available --db-instance-identifier "ts-dev" --profile sls-fortniteclipz --region us-east-1

echo "rds | remigrating | ts-dev"
source venv/bin/activate
alembic downgrade base && alembic upgrade head
