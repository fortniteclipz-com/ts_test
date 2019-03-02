twitch_stitch_root="${PWD%/*/*}"

function bootstrap() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "start $module_short"

    cd $1
    rm -rf ./venv
    rm -rf ./__pycache__
    virtualenv ./venv --python=/usr/local/bin/python3
    source venv/bin/activate
    pip3 install pip==10.0.1
    pip3 install --process-dependency-links -r requirements.txt

    cd $twitch_stitch_root/ts_shared
    pip3 install --process-dependency-links -e ./ts_aws
    pip3 install --process-dependency-links -e ./ts_config
    pip3 install --process-dependency-links -e ./ts_file
    pip3 install --process-dependency-links -e ./ts_http
    pip3 install --process-dependency-links -e ./ts_libs
    pip3 install --process-dependency-links -e ./ts_logger
    pip3 install --process-dependency-links -e ./ts_model

    echo "done $module_short"
    echo "\n"
}

cd $twitch_stitch_root
if [ -z $1 ]; then

    find . -path "*/modules/*" -name "venv" -maxdepth 4 -exec rm -rf '{}' +
    find . -path "*/modules/*" -name "__pycache__" -maxdepth 4 -exec rm -rf '{}' +
    find $(pwd) -type f -path "*/modules/*" -not -path "*.serverless*" -maxdepth 4 -iname "requirements.txt" -print0 | while IFS= read -r -d $'\0' file; do
        module_dir=$(dirname $file)
        bootstrap $module_dir
    done

else

    repo="$(cut -d'/' -f1 <<<"$1")"
    module="$(cut -d'/' -f2 <<<"$1")"
    found=false

    while IFS= read -d " " module_dir; do
        if [[ $module_dir == *$repo* ]] && [[ $module_dir == *$module* ]]; then
            found=true
            bootstrap $module_dir
        fi
    done <<< $(find . -path "*/modules/*" -maxdepth 3 -type d)

    if [ $found = false ]; then
        echo "error: $repo $module is not a valid module dir [$repo/$module]"
    fi

fi



