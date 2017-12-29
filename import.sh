#!/bin/zsh
rm HttpLuaModule.wiki*
rm README.markdown*
rm docSet.dsidx
rm functions.sql
rm categories.sql
rm -fr HttpLuaModule.html
rm -fr HttpLuaModule.docset/

# get the page
wget https://raw.githubusercontent.com/openresty/lua-nginx-module/master/doc/HttpLuaModule.wiki
perl wiki2markdown.pl HttpLuaModule.wiki >HttpLuaModule.markdown
pandoc -o HttpLuaModule.html HttpLuaModule.markdown
ruby parse.rb HttpLuaModule.html

# Create the valid docset structure
mkdir -p HttpLuaModule.docset/Contents/Resources/Documents
mv docSet.dsidx HttpLuaModule.docset/Contents/Resources/
mv HttpLuaModule.html HttpLuaModule.docset/Contents/Resources/Documents/

# Alternative way, using xmlstarlet
# xmlstarlet sel -T -t -m "/html/body/h2/a[@class='anchor']/parent::*"  -v self::h2 -o " => " -m "a" -v @href -n  README.markdown
# xmlstarlet sel -T -t -m "/html/body/h1/a[@class='anchor']/parent::*"  -v self::h1 -o " => " -m "a" -v @href -n  README.markdown
