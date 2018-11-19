twitch_stitch_root="${PWD%/*/*}"

function bootstrap() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "start $module_short"

    cd $1
    rm -rf ./venv
    virtualenv ./venv -p /usr/local/bin/python3
    source venv/bin/activate
    pip3 install --process-dependency-links -r requirements.txt

    cd $twitch_stitch_root/ts_shared
    pip3 install --process-dependency-links -e ./ts_aws
    pip3 install --process-dependency-links -e ./ts_config
    pip3 install --process-dependency-links -e ./ts_file
    pip3 install --process-dependency-links -e ./ts_http
    pip3 install --process-dependency-links -e ./ts_libs
    pip3 install --process-dependency-links -e ./ts_logger
    pip3 install --process-dependency-links -e ./ts_model
    pip3 install --process-dependency-links -e ./ts_model2

    echo "done $module_short"
    echo "\n"
}

if [ -z $1 ]; then
    cd $twitch_stitch_root
    # find . -name "venv" -exec rm -rf '{}' +
    # find . -name "__pycache__" -exec rm -rf '{}' +
    find $(pwd) -type f -path "*/modules/*" -not -path "*.serverless*" -iname "requirements.txt" -print0 | while IFS= read -r -d $'\0' file; do
        module_dir=$(dirname $file)
        bootstrap $module_dir
    done
else
    repo="$(cut -d'/' -f1 <<<"$1")"
    module="$(cut -d'/' -f2 <<<"$1")"
    module_dir="$twitch_stitch_root/ts_$repo/modules/$module"
    if [ -d "$module_dir" ]; then
        bootstrap $module_dir
    else
        echo "error: $repo $module is not a valid module dir [$repo/$module]"
    fi
fi



