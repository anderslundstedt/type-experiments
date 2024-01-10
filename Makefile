SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: readme clean clean-coq type-check type-check-coq

default:


# README

readme:
	cat readme-parts/*.* > README.md


# CLEAN

clean: clean-coq

clean-coq:
	cd coq-8.16
	make clean
	cd -


# TYPE-CHECK

type-check: type-check-coq

type-check-coq:
	cd coq-8.16
	make type-check
	cd -
