#!/bin/sh

if [ $# -ne 1 ]; then
  echo "$0 <new class name>"
  exit 1
fi

if [ ! -f "Gemfile" ] || [ ! -f "init.sh" ]; then
  echo "$0: this is not our base sinatra app"
  exit 1
fi

newclass=${1}
newpath=`echo ${1} | tr '[A-Z]' '[a-z]'`

search=0
while [ "${search}" == 0 ]; do
  for file in `find . -name 'appname*' | sort -r` ; do
    newfile=`echo ${file} | sed "s/appname/${newpath}/"`
    git mv ${file} ${newfile} 2>/dev/null
  done

  find . -name 'appname*' | grep -q appname
  search=$?
done

for file in `find . -type f ! -path './.git/*' -exec grep -il appname {} \;` ; do
  sed -i .bak -e "s/appname/${newpath}/g; s/AppName/${newclass}/g" ${file}
  rm -f ${file}.bak
done

git rm run/.keep
git rm -f ${0}