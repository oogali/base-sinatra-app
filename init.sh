#!/bin/sh

if [ $# -ne 1 ]; then
  echo "$0 <new class name>"
  exit 1
fi

# make sure we're running in project root
if [ ! -f "Gemfile" ] || [ ! -f "init.sh" ]; then
  echo "$0: this is not our base sinatra app"
  exit 1
fi

# get new class, generate new directory name
newclass=${1}
newpath=`echo ${1} | tr '[A-Z]' '[a-z]'`

# recursively rename all files that contain the placeholder
search=0
while [ "${search}" == 0 ]; do
  for file in `find . -name 'appname*' | sort -r` ; do
    newfile=`echo ${file} | sed "s/appname/${newpath}/"`
    git mv ${file} ${newfile} 2>/dev/null
  done

  find . -name 'appname*' | grep -q appname
  search=$?
done

# recursively search and replace the placeholder class name
for file in `find . -type f ! -path './.git/*' -exec grep -il appname {} \;` ; do
  sed -i .bak -e "s/appname/${newpath}/g; s/AppName/${newclass}/g" ${file}
  rm -f ${file}.bak
done

# delete old origin
git remote rm origin

# delete placeholders, readme, and this init script
git rm run/.keep
git rm -f README.md
git rm -f ${0}

# symlink the development configuration
ln -s config_development.yml config.yml

# truncate git history, and perform initial commit
git branch -m master initial
git checkout --orphan master
git commit -a -m "Initial creation of ${newclass}"

# delete old temporary branch, and display git log
git branch -D initial
git log
