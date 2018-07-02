
#!/bin/bash

if [ -d doc ]; then
  rm -fr doc
fi

for f in `find . -name *.lua`; do
  dir=${f%/*}
  dir=${dir#*/}
  dir=doc/$dir

  name=${f##*/}
  name=${name%%.*}
  name=$dir/$name.html

  mkdir -p $dir
  pygmentize -f html -O full,style=emacs,linenos=1 -l lua -o $name $f
done
