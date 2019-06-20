# reboot and remigrate
ts_env=${1:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "rds | start | ts_env=$ts_env | region=$region"

twitch_stitch_root=${PWD%/*/*}
cd $twitch_stitch_root/ts_infra/migrations
if [ ! -d ./venv ]; then
    echo "rds | bootstrapping"
    rm -rf ./venv
    rm -rf ./__pycache__
    python3 -m venv ./venv
    source venv/bin/activate
    python3 -m pip install pip==18.1
    pip3 install --process-dependency-links -r requirements.txt
    pip3 install --process-dependency-links -e $twitch_stitch_root/ts_shared/ts_config
    deactivate
fi

echo "rds | rebooting | ts_env=$ts_env | region=$region"
aws rds reboot-db-instance --db-instance-identifier "ts-$ts_env" --profile sls-fortniteclipz --region $region
aws rds wait db-instance-available --db-instance-identifier "ts-$ts_env" --profile sls-fortniteclipz --region $region

echo "rds | remigrating | ts_env=$ts_env | region=$region"
source venv/bin/activate
export TS_ENV=$ts_env
alembic downgrade base && alembic upgrade head

echo "rds | done | ts_env=$ts_env | region=$region"

