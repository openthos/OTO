# android-x86-openthos
openthos based on android-x86 
<p>
First, follow the AOSP page "Establishing a Build Environment" to configure your build environment. Then
```
mkdir WORK_DIR
cd WORK_DIR
repo init -u https://github.com/openthos/android-x86-openthos.git -b $branch
repo sync
```
Where $branch is any branch name described in the list below.
<p>
We have created different branches based on lollipop-x86:
 - lollipop-x86
 - multiwindow
 - singlewindow

