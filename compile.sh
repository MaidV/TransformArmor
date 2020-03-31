#!/usr/bin/env bash
echo $(date)

skyrim="C:\games\Steam\steamapps\common\Skyrim Special Edition"
skyrimdata="${skyrim}\Data"
outputpath="C:\Users\Bobiert\Documents\Projects\SluttifyArmor\Scripts"
scriptpath="C:\Users\Bobiert\Documents\Projects\SluttifyArmor\Source\Scripts"
source="$scriptpath;${skyrimdata}\Source;${skyrimdata}\Source\Scripts;${skyrimdata}\Scripts\Source"
papyrus="/mnt/c/games/Steam/steamapps/common/Skyrim Special Edition/Papyrus Compiler/PapyrusCompiler.exe"

if [ "$1" == "--all" ]; then
    "$papyrus" "$scriptpath" -f="TESV_Papyrus_Flags.flg" -i="${source}" -o="${outputpath}" -op -all
else
    for srcfile in "$@"; do
        "$papyrus" "$srcfile" -f="TESV_Papyrus_Flags.flg" -i="${source}" -o="${outputpath}" -op
    done
fi
echo ""

