PACKER ?= packer

var_file=example.pkrvars.hcl

.PHONY: build

build:
	@echo build $$ENV
	$(PACKER) build -var-file=$(var_file) .	 
