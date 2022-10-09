#!/bin/sh
echo -ne '\033c\033]0;CAPY\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CAPY.x86_64" "$@"
