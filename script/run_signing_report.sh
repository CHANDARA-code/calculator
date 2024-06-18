#!/bin/bash
cd ..
cd "$(dirname "$0")/android" || exit
./gradlew signingreport
