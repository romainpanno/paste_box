#!/bin/bash

SHELL_NAME=$(which $SHELL)

function file_exist() {
    if [ -f $1 ]; then
        echo "done"
    else
        echo "error"
    fi
}

function get_file_numbers() {
    local file_numbers=$(ls /tmp/paste_box | grep -e "" -c)

    echo "$file_numbers"
}

function get_all_files() {
    local file_list="$(ls /tmp/paste_box | grep -e "")"
    local file_array=(`echo $file_list | tr '\n' ' '`)

    echo "${file_array[@]}"
}

function display_begin_one_file() {
    local prefixe="/tmp/paste_box/"
    local file_name="$prefixe$1"

    echo "-----------------------------------------"
    echo "              ==> $1 <=="
    echo "$(head -n 10 $prefixe$1)"
    echo "-----------------------------------------"
}

function display_begin_files() {
    local file_numbers=$(get_file_numbers)
    local file_array=$(get_all_files)

    echo -e "listing [$file_numbers] files :\n"
    for i in $file_array; do
        display_begin_one_file "$i"
    done
    echo -e "\nfinished"
}

function add_into_new_file() {
    echo "Adding $1 into $2"
    echo "$1" >> /tmp/paste_box/$2

    file_exist "/tmp/paste_box/$2"
}

if [[ ! -d /tmp/paste_box ]]; then
    echo "Creating directory /tmp/paste_box\n"
    mkdir /tmp/paste_box
fi
echo -e "USAGE [
    - a : add to paste_box
    - l : list paste_box
    - g [number of paste / 'last' for last paste] : get content of pasted_file
    - c : clear all files
    - q or other : quit
    ]\n"

echo -n "Enter parameter : "
read answer

if [ "$answer" = "l" ]; then
    display_begin_files
elif [ "$answer" = "a" ]; then
    file_name=""

    echo -n "Enter file name : "
    read file_name
    echo ""
    while [[ ! -z "$(echo "$file_name" | grep "\"\|\ ")" || "$file_name" == "" ]]; do
        echo -n "bad file_name retry without \"\"\" | \" \": "
        read file_name
    done
    echo "Paste the content to stock"
    nano -L /tmp/paste_box/$file_name
    file_exist "/tmp/paste_box/$file_name"
elif [ "$answer" = "g" ]; then
    echo -n "enter file name (or 'last' for last paste) : "
    read file_name
    while [[ "$file_name" != "" ]] && [[ "$file_name" != "last" ]] && [[ ! -f "/tmp/paste_box/$file_name" ]]; do
        echo -n "file doesn't exist retry : "
        read file_name
    done
    if [[ "$file_name" == "" || "$file_name" == "last" ]]; then
        file_name=$(ls --time=creation /tmp/paste_box/ | head -n 1)
    fi
    cat "/tmp/paste_box/$file_name" | xclip -i -selection clipboard
    echo "==> $file_name <== :"
    echo "$(head -n 10 /tmp/paste_box/$file_name)"
    echo "pasted into your clipboard"
elif [ "$answer" = "c" ]; then
    echo -n "are you shure ? (y/n) : "
    read answer
    if [ "$answer" = "y" ]; then
        rm -rf /tmp/paste_box/*
    fi
else
    echo "Ok, bye"
fi