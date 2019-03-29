#! /bin/bash

PROJECT=mercy
VERSION=$(grep VERSION lib/$PROJECT/version.rb  | sed -e "s/.*'\(.*\)'/\1/g")

echo grep https://www.rubydoc.info/gems/$PROJECT/$VERSION README.md
