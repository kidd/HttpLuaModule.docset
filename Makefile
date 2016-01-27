.PHONY: commit import

import:
	sh ./import.sh

commit:
	sh ./commit.sh

install:
	cp -r HttpLuaModule.docset ~/.docsets
