.PHONY: test local build

test:
	busted

local: build
	luarocks make --local moondoc-dev-1.rockspec

build:
	moonc moondoc


