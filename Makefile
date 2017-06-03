.PHONY: test local build

test:
	busted

local: build
	luarocks make --local moondoc-dev-1.rockspec

build:
	moonc moondoc.moon moondoc
	moonc -o bin/moondoc bin/moondoc.moon 
	chmod +x bin/moondoc

