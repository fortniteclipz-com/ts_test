# bootstrap
twitch_stitch_root="${PWD%/*/*}"

function bootstrap() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "bootstrap | start | module=$module_short"
    cd $1
    rm -rf ./venv
    rm -rf ./__pycache__
    python3 -m venv ./venv
    source venv/bin/activate
    python3 -m pip install pip==18.1
    pip3 install --process-dependency-links -r requirements.txt
    cd $twitch_stitch_root/ts_shared
    pip3 install --process-dependency-links -e ./ts_aws
    pip3 install --process-dependency-links -e ./ts_config
    pip3 install --process-dependency-links -e ./ts_file
    pip3 install --process-dependency-links -e ./ts_http
    pip3 install --process-dependency-links -e ./ts_logger
    pip3 install --process-dependency-links -e ./ts_model
    deactivate
    echo "bootstrap | done | module=$module_short"
}

cd $twitch_stitch_root
if [ -z $1 ]; then
    find . -type d -path "*/modules/*" -name "venv" -maxdepth 4 -exec rm -rf '{}' +
    find . -type d -path "*/modules/*" -name "__pycache__" -maxdepth 4 -exec rm -rf '{}' +
    echo "bootstrap | found all | ↓"
    find $(pwd) -type d -path "*/modules/*" -maxdepth 3
    echo "bootstrap | found all | ↑"
    find $(pwd) -type d -path "*/modules/*" -maxdepth 3 -print0 | while IFS= read -r -d $'\0' module_dir; do
        bootstrap $module_dir
    done
else
    repo=$1
    module=$2
    found=false
    while IFS= read -d " " module_dir; do
        if [[ $module_dir == *$repo* ]] && [[ $module_dir == *$module* ]]; then
            found=true
            bootstrap $module_dir
        fi
    done <<< $(find $(pwd) -type d -path "*/modules/*" -maxdepth 3)
    if [ $found = false ]; then
        echo "bootstrap | error | $repo $module is not valid"
    fi
fi



