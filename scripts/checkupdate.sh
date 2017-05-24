#!/bin/bash
# based on git log info

if [ "$1"x = "help"x ];then
        echo -e "Usage: $0 <command>"
	echo -e ""
	echo -e "$0"
	echo -e "$0 help"
	echo -e "$0 check_github_multi"
	echo -e "$0 projects_update"
	echo -e "$0 up2github"

	exit 2
fi

up2="$1" #up2github
#git config --global credential.helper cache

android_repo_path="/opt/git/lollipop-x86"
Repo="/home/xly/repository/bin/repo"

dirname_path=$(cd `dirname $0`; pwd)

manifest_dir="/home/chyyuu/github/manifest"
prj_multi_xml="/tmp/github_multiwindow.xml"

name2path="/home/xly/sh/proj_name2path.sh"

#check_all_projects_update
if [ "$1"x = "projects_update"x ];then
	update_flag=0
	md_file="projects_update.md"
	echo '# multiwindow projects update' > /tmp/$md_file
	echo $(date -R) >> /tmp/$md_file

	cd $manifest_dir
	git checkout master

fi
#check_all_projects_update

if [ "$1"x = "check_github_multi"x ];then
	cd $manifest_dir
	git checkout github_multiwindow
	cp -f default.xml $prj_multi_xml
fi

cd $android_repo_path

oto_proj=$(ls -d platform/packages/apps/Oto* | sed s/\.git//)
oto_proj+=" platform/packages/apps/Printer
platform/external/p7zip
platform/packages/apps/ExternalApp
platform/external/Uitest
platform/external/lkp
platform/vendor/openthos
platform/hardware/intel/common/vaapi "

#oto_proj+=" platform/vendor/intel/houdini " #No need to update houdini,google

mr_proj=" platform/external/libmpeg2
platform/external/libavc
platform/external/libhevc "
#####
all_projects=$($Repo list | awk '$3 !~ /^(git-repo|manifest)/ {print $3}') #$name
all_projects+=" $oto_proj "
echo $all_projects > /tmp/all_projects.txt

for prj_ in $all_projects 
do
	cd $android_repo_path

	#echo $prj_
	cd "${prj_}.git"
	if [ $? -ne 0 ]; then
		echo -e "\033[31m$prj_\033[0m"
		echo '------------------------------'
		continue
	fi

	multi_loginfo=(` git log multiwindow -1 --pretty=format:"%h %cd %ae \"%an\"" --date=iso `)

	base_branch=" "
	if [[ $oto_proj =~ $prj_ ]]; then
		base_loginfo=("null")
	else
		if [[ $mr_proj =~ $prj_ ]]; then
			base_branch="marshmallow-mr2-release"
		fi

		base_loginfo=(` git log $base_branch -1 --pretty=format:"%h %cd %ae \"%an\"" --date=iso `)
		if [ ! -n "${base_loginfo[5]}" ]; then
			echo -e "\033[31m$prj_\033[0m"
			echo '------------------------------'
			continue
		fi


		if [ "${base_loginfo[0]}"x = "${multi_loginfo[0]}"x ]
		then
			continue
		fi
	fi

	#check_all_projects_update
	if [ "$1"x = "projects_update"x ];then

		grep "${multi_loginfo[0]}"  $manifest_dir/$md_file
		if [ $? -ne 0 ]; then
			echo -e "\033[31m $prj_ ${multi_loginfo[0]} needs to be updated github!\033[0m"
			update_flag=1
		fi

		multi_loginfo_tmp=$(echo ${multi_loginfo[@]})
		printf "\x2D %50s $multi_loginfo_tmp \n" $prj_ >> /tmp/$md_file
		continue
	fi
	#check_all_projects_update

	#check if github manifest have updated the project
	if [ "$1"x = "check_github_multi"x ];then
		echo -e "\033[32m$prj_\033[0m"

		#project name --> path
		prj_path=""
		github_name=""
		eval `/bin/bash $name2path $prj_ `
		if [ ! -n "$prj_path" ]; then
		echo -e "\033[31mNo found project: $prj_\033[0m"
		continue
		fi

		prj_multi=$github_name

		#PS. exclude kernel/common
		#prj_multi=$( echo $prj_ | sed "s/^platform\///g" ) 
		#grep "path=\"$prj_multi\"" $prj_multi_xml | grep "revision=\"multiwindow\""

		grep "openthos\/$prj_multi" $prj_multi_xml > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo -e "\033[31mNo found < path=\"$prj_path\" name=\"openthos/$prj_multi\" remote=\"github\" revision=\"multiwindow\" > in github manifest\033[0m"
		fi
		continue
	fi #check_github_multi

	#up2
	if [ "$up2"x = "up2github"x ];then
		sleep 1
		echo -e "\033[32m$prj_\033[0m"

		git remote -v | grep  "github.com/openthos" > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo -e "\033[31m$prj_ git remote github.com/openthos ERROR!\033[0m"
			continue
		fi

###new git remote
#	new_gitremote=$( git remote -v | awk ' /github.com\/openthos/ { gsub(/openthos_/,"oto_",$2); print $2; exit}')
#	sudo git remote remove github
#	sudo git remote add github $new_gitremote
###new git remote

		git push github multiwindow
		if [ $? -ne 0 ]; then
			echo -e "\033[31mPush $prj_ ERROR!\033[0m"
		fi

	

		continue
	fi #up2

	echo -e "\033[32m$prj_\033[0m"
	echo -e "               \033[1m${base_loginfo[@]}\033[0m"
	echo -e "multiwindow  : ${multi_loginfo[@]}"
	echo '------------------------------'

done

#update_flag=1
#check_all_projects_update
if [ "$1"x = "projects_update"x ];then
	if [ "$update_flag" -eq 1 ];then
		echo -e "\033[32mCOPY $md_file\033[0m"

		cp /tmp/$md_file "${manifest_dir}/"

		#sleep 1
		cd $manifest_dir
		git commit -a -m "projects update $(date -R)" 2>&1 > /tmp/manifest.log
		git push github master 2>&1 >> /tmp/manifest.log

		#push update to github
		/bin/bash $dirname_path/checkupdate.sh up2github 2>&1 > /tmp/push.log

	fi
fi
