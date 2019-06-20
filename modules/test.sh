ts_env=${3:-'dev'}
region=$([ $ts_env == "prod" ] && echo "us-west-2" || echo "us-east-1")
echo "test | start | ts_env=$ts_env | region=$region"


function test() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "test | start | ts_env=$ts_env | region=$region | module=$module_short"
    cd $1
    if [ -d "./venv" ]; then
        source venv/bin/activate
        export AWS_DEFAULT_PROFILE=sls-fortniteclipz
        export TS_ENV=$ts_env
        export AWS_DEFAULT_REGION=$region
        python3 test.py
        echo "test | done | ts_env=$ts_env | region=$region | module=$module_short"
    else
        echo "test | error | not bootstrapped | ts_env=$ts_env | region=$region | module=$module_short"
    fi
}

twitch_stitch_root="${PWD%/*/*}"
cd $twitch_stitch_root
if [ -z $1 ]; then
    echo "test | error | repo and module not specified"
else
    repo=$1
    module=$2
    found=false
    while IFS= read -d " " module_dir; do
        if [[ $module_dir == *$repo* ]] && [[ $module_dir == *$module* ]]; then
            found=true
            test $module_dir
        fi
    done <<< $(find $(pwd) -type d -path "*/modules/*" -maxdepth 3)
    if [ $found = false ]; then
        echo "test | error | invalid | ts_env=$ts_env | region=$region | repo=$repo | module=$module"
    fi
fi



