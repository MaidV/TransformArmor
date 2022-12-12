#!/usr/bin/env bash

versint=$(grep "int version = " Source/Scripts/TA_MCMConfig.psc | awk '{printf "%d",$4;}')
major=$((versint / 10000))
minor=$(((versint / 100) % 100))
patch=$((versint % 100))
version="$major.$minor.$patch"
archive="Transform Armor $version.7z"

echo "Verifying version $version"

diff /mnt/c/games/Steam/steamapps/common/Skyrim\ Special\ Edition/Data/Transform\ Armor.esp Transform\ Armor.esp
if [ $? -eq 0 ]; then
    echo "esp matches game directory"
else
    echo "esp differs from game directory, aborting"
    exit 1
fi

diff build/TransformUtils.dll skse/plugins/TransformUtils.dll
if [ $? -eq 0 ]; then
    echo "dlls match. moving forward"
else
    echo "dlls don't match. rebuild"
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

7zz a "$archive" Source/Scripts/*.psc Scripts skse Transform\ Armor.esp
7zz l "$archive"

rm makelog
