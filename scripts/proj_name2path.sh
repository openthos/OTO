#!/bin/bash

if [ $# -lt 1 ]; then
        echo -e "Usage: $0 project_name \n\t$0 platform/frameworks/base"
	exit 2
fi

#android_x86_dir="/opt/git/lollipop-x86"
manifest_dir="/home/chyyuu/github/manifest"

tmp_xml="/tmp/local_multiwindow.xml"

if [ ! -f "$tmp_xml" ]; then
	cd $manifest_dir
	git checkout local_multiwindow > /dev/null 2>&1
	cp -f default.xml $tmp_xml
fi

path=""
eval $( grep "name=\"$1\"" $tmp_xml | awk '{print $2}' )

if [ ! $path ];then
	if [ ! $2 ];then
		echo -e "\033[31m Invalid Project Name ! \033[0m"
		exit 2
	else
		path="$2"
	fi
fi


repo_path=$path
echo "prj_path=$repo_path ;"

github_name="oto_$(echo $repo_path |sed "s/\//_/g")"

#echo -e "\033[32m$github_name\033[0m"
echo "github_name=$github_name"
