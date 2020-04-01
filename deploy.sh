#!/usr/bin/env bash

versint=$(grep "int version = " Source/Scripts/SA_MCMConfig.psc | awk '{printf "%d",$4;}')
major=$((versint / 10000))
minor=$(((versint / 100) % 100))
patch=$((versint % 100))
version="$major.$minor.$patch"
archive="SluttifyArmor $version.7z"

echo "Verifying version $version"

diff /mnt/c/games/Steam/steamapps/common/Skyrim\ Special\ Edition/Data/Sluttify\ Armor.esp Sluttify\ Armor.esp
if [ $? -eq 0 ]; then
    echo "esp matches game directory"
else
    echo "esp differs from game directory, aborting"
    exit 1
fi

echo "Building..."
make &> makelog
grep "0 failed" makelog
success=$?

if [ $success -eq 0 ] ; then
    echo "Build successful"
else
    echo "Build failed"
    cat makelog
    echo "Aborting"
    exit 1
fi

echo "Version $version verified, deploying"

7z a "$archive" Source/Scripts/*./psc Scripts skse Sluttify\ Armor.esp
7z l "$archive"

rm makelog
