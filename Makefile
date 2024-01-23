SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY:\
    readme \
    preview-readme \
    update-flakes \
    clean          clean-mac-os-junk      clean-coq      clean-python \
    type-check                       type-check-coq type-check-python

default:


# README

readme:
	cat readme-parts/*.* > README.md


# PREVIEW-README

user ?= anderslundstedt
preview-readme:
	grip --user='${user}' --pass '${pass}'


# UPDATE-FLAKE

update-flake:
	nix flake update


# CLEAN

clean: clean-direnv clean-mac-os-junk clean-coq clean-python

clean-direnv:
	rm -rvf .direnv

clean-mac-os-junk:
	rm -rvf **/.DS_Store

clean-coq:
	cd coq-8.16
	make clean
	cd -

clean-python:
	cd python-3.12
	make clean
	cd -


# TYPE-CHECK

type-check: type-check-python type-check-coq

type-check-coq:
	cd coq-8.16
	make type-check
	cd -

type-check-python:
	cd python-3.12
	make type-check
	cd -
