v=$(grep "This document describes" README.markdown | sed -e 's/<[^>]*>//g')
git commit -am "$v"
