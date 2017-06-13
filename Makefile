.PHONY: test local build

test:
	busted

local: build
	luarocks make --local moondoc-dev-1.rockspec

build:
	moonc moondoc.moon moondoc
	echo '#!/usr/bin/env lua' > bin/moondoc
	moonc -p bin/moondoc.moon >> bin/moondoc
	chmod +x bin/moondoc

