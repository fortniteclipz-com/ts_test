twitch_stitch_root="${PWD%/*/*}"

function test() {
    module_short="$(basename "${1%/*/*}")/${1##*/}"
    echo "start $module_short"

    cd $1
    if [ -d "$1/venv" ]; then
        source venv/bin/activate
        python3 test.py
        echo "done $module_short"
    else
        echo "error: $module_short is not bootstrapped [$module_short]"
    fi

    echo "\n"
}

if [ -z $1 ]; then
    echo "error: no module dir given"
else
    repo="$(cut -d'/' -f1 <<<"$1")"
    module="$(cut -d'/' -f2 <<<"$1")"
    module_dir="$twitch_stitch_root/ts_$repo/modules/$module"
    if [ -d "$module_dir" ]; then
        test $module_dir
    else
        echo "error: $repo $module is not a valid module dir [$repo/$module]"
    fi
fi



