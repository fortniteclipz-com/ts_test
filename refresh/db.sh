twitch_stitch_root="${PWD%/*/*}"

# drop and create db
cd $twitch_stitch_root/ts_infra/database
if [ ! -d ./venv ]; then
    rm -rf ./venv
    rm -rf ./__pycache__
    virtualenv ./venv -p /usr/local/bin/python3
    source venv/bin/activate
    pip3 install --process-dependency-links -r requirements.txt
    deactivate
fi
source venv/bin/activate
alembic downgrade base && alembic upgrade head
