#!/bin/bash
set -e
./gradlew jar
cp ./build/libs/game.jar "$(dirname "$0")"