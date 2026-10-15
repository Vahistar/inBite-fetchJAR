#!/bin/sh
set -e

cd "$(dirname "$0")"

if [ -f logo.txt ]; then
    cat logo.txt
fi

printf 'Enter the URL to fetch: '
read URL

if [ -z "$URL" ]; then
    echo 'No URL provided.'
    exit 1
fi

rm -rf build
mkdir -p build/classes

printf 'url=%s\n' "$URL" > build/config.properties

javac -encoding UTF-8 -d build/classes src/Main.java

cp build/config.properties build/classes/config.properties

jar --create --file server.jar --main-class Main -C build/classes .

echo
echo 'Built server.jar'
