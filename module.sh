twitch_stitch_root="$(dirname $PWD)"

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

    echo "done bootstrappin $2\n"
}

function test() {
    echo "\ntestin $2"

    cd $1
    source venv/bin/activate
    python3 test.py

    echo "done testin $2\n"
}

fn="$1"
function run() {
    echo "run | $fn | $1 | $2"
    if [ $fn == "bootstrap" ]; then
        bootstrap $1 $2
    elif [ $fn == "test" ]; then
        test $1 $2
    fi
    exit 1
}

# ---------------------------

if  ( [ $1 != "bootstrap" ] && [ $1 != "test" ] ) ||
    ( [ $1 == "test" ] && [ -z $2 ] ) ||
    ( [ $1 != "bootstrap" ] && [ $2 == "ts_test" ] )
then
    echo "invalid command"
    exit 0
fi

if [ -z $2 ]; then
    cd $twitch_stitch_root
    find . -name "venv" -exec rm -rf '{}' +
    find . -name "__pycache__" -exec rm -rf '{}' +
    find $(pwd) -type f -not -path "*.serverless*" -iname "requirements.txt" -print0 | while IFS= read -r -d $'\0' file; do
        dir=$(dirname $file)
        module=$(basename $dir)
        run $dir $module
    done
else
    repo="$(cut -d'/' -f1 <<<"$2")"
    module="$(cut -d'/' -f2 <<<"$2")"
    echo $repo
    echo $module
    dir_module="$twitch_stitch_root/ts_$repo/modules/$module"
    dir_repo="$twitch_stitch_root/$repo"
    if [ -d "$dir_module" ]; then
        run $dir_module $module
    elif [ -d "$dir_repo" ]; then
        run $dir_repo $repo
    else
        echo "no valid dir for: $repo $module"
    fi
fi



