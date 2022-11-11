
export HOME=c:/Users

.PHONY: build_upload build upload sim clean open print

build_upload:
	apio verify
	apio build
	apio upload

#depends on these for upload
#hardware.asc hardware.bin hardware.json

hardware.asc:
	apio build

#thats not right
build: hardware.asc hardware.bin hardware.json
	apio build

upload: build
	apio upload

sim:
	apio sim

clean:
	apio clean

print:
	$(shell cd $(HOME))
