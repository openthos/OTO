# OTO
openthos based on android-x86 

## Establishing a Build Environment
First, follow the AOSP page "[Establishing a Build Environment](http://source.android.com/source/initializing.html)" to configure your build environment.

## Downloading the Source
```
git clone https://github.com/openthos/OTO.git
cd OTO
export PATH=$PATH:$PWD

mkdir WORK_DIR
cd WORK_DIR
repo init -u https://github.com/openthos/OTO.git -b $branch
#eg: repo init -u https://github.com/openthos/OTO.git -b multiwindow
repo sync
```
Where $branch is any branch name described in the list below.
<p>
We have created different branches based on lollipop-x86 (required openjdk7):
 - lollipop-x86
 - multiwindow
 - singlewindow

## Building openthos
```
cd WORK_DIR
source build/envsetup.sh
lunch $target_build
#eg: lunch android_x86_64-eng
m iso_img -j$P
#out directory: out/target/product/
```
