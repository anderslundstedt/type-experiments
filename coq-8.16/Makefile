SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


.PHONY: clean type-check

default:

clean:
	rm -vf **/.*.aux
	rm -vf **/*.glob
	rm -vf **/*.vo
	rm -vf **/*.vok
	rm -vf **/*.vos

type-check:
	coqc **/*.v > /dev/null
