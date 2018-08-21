twitch_stitch_root="/Users/Sachin/code/businesses/twitch_stitch"

function bootstrap() {
    echo "\nbootstrappin $2"

    cd $1
    rm -rf ./venv
    deactivate
    virtualenv ./venv -p /usr/local/bin/python3
    source venv/bin/activate
    pip3 install --process-dependency-links -r requirements.txt

    cd $twitch_stitch_root/ts_shared
    pip3 install --process-dependency-links -e ./ts_aws
    pip3 install --process-dependency-links -e ./ts_config
    pip3 install --process-dependency-links -e ./ts_file
    pip3 install --process-dependency-links -e ./ts_http
    pip3 install --process-dependency-links -e ./ts_logger
    pip3 install --process-dependency-links -e ./ts_media
    pip3 install --process-dependency-links -e ./ts_twitch

    echo "done bootstrappin $2\n"
}

function test() {
    echo "\ntestin $2"
    cd $1

    echo "$PWD"

    source venv/bin/activate
    python3 test.py

    echo "done testin $2\n"
}

cd $twitch_stitch_root
# find . -name "venv" -exec rm -rf '{}' +
# find . -name "__pycache__" -exec rm -rf '{}' +
find $(pwd) -type f -not -path "*.serverless*" -iname "requirements.txt" -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname $file)
    module_name=$(basename $dir)
    echo "checking $module_name..."
    if [ -z $2 ] || [ $module_name == $2 ]; then
        if [ $1 == "bootstrap" ]; then
            bootstrap $dir $module_name
        fi

        if [ $1 == "test" ]; then
            test $dir $module_name
        fi
    fi
done
