twitch_stitch_root="${PWD%/*/*}"

function test() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "$1"
    echo "start $module_short"

    cd $1
    if [ -d "./venv" ]; then
        source venv/bin/activate
        python3 test.py
        echo "done $module_short"
    else
        echo "error: $module_short is not bootstrapped [$module_short]"
    fi

    echo "\n"
}

cd $twitch_stitch_root
if [ -z $1 ]; then

    echo "error: no module dir given"

else

    repo="$(cut -d'/' -f1 <<<"$1")"
    module="$(cut -d'/' -f2 <<<"$1")"
    found=false

    while IFS= read -d " " module_dir; do
        if [[ $module_dir == *$repo* ]] && [[ $module_dir == *$module* ]]; then
            found=true
            test $module_dir
        fi
    done <<< $(find . -path "*/modules/*" -maxdepth 3 -type d)

    if [ $found = false ]; then
        echo "error: $repo $module is not a valid module dir [$repo/$module]"
    fi

fi



