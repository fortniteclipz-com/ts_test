twitch_stitch_root="${PWD%/*/*}"

function test() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "test | start | module=$module_short"
    cd $1
    if [ -d "./venv" ]; then
        source venv/bin/activate
        python3 test.py
        echo "test | done | module=$module_short"
    else
        echo "test | error | not bootstrapped | module=$module_short"
    fi
}

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
        echo "test | error | invalid | repo=$repo | module=$module"
    fi
fi



