rm README.markdown*
rm docSet.dsidx
rm functions.sql
rm categories.sql
rm -fr HttpLuaModule.html
rm -fr HttpLuaModule.docset/

# get the page
wget https://github.com/openresty/lua-nginx-module/blob/master/README.markdown

#clean it
sed -i '1,/mainContentOfPage/d' README.markdown

# Prepare valid html page
echo '<html><body>' > HttpLuaModule.html
cat README.markdown >>HttpLuaModule.html

# Create docset db
sqlite3 docSet.dsidx  'create table searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);  CREATE UNIQUE INDEX anchr  ON searchIndex (name, type, path);'


# Fetch functions and categories
grep 'class="anchor"' README.markdown| grep h2 | sed -e 's!^.*href="\([^"]*\).*</a>\(.*\)</h2>!sqlite3 docSet.dsidx "insert into searchIndex(name,type,path) VALUES (\\"\2\\", \\"Function\\", \\"HttpLuaModule.html\1\\" )"!' > functions.sql
grep 'class="anchor"' README.markdown| grep h1 | sed -e 's!^.*href="\([^"]*\).*</a>\(.*\)</h1>!sqlite3 docSet.dsidx "insert into searchIndex(name,type,path) VALUES (\\"\2\\", \\"Category\\", \\"HttpLuaModule.html\1\\" )"!' > categories.sql

# Insert into sqlite db
sh functions.sql
sh categories.sql

# Create the valid docset structure
mkdir -p HttpLuaModule.docset/Contents/Resources/Documents
mv docSet.dsidx HttpLuaModule.docset/Contents/Resources/
mv HttpLuaModule.html HttpLuaModule.docset/Contents/Resources/Documents/
