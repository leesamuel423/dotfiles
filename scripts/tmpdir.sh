#!/bin/bash

# Temp directory that is automatically removed on exit

dir=$(mktemp -d)
pushd $dir
$SHELL
popd
rm -rf $dir
