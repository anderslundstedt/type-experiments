SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY:\
    readme \
    update-flakes \
    clean          clean-mac-os-junk      clean-coq \
    type-check                       type-check-coq

default:


# README

readme:
	cat readme-parts/*.* > README.md


# UPDATE-FLAKE

update-flake:
	nix flake update


# CLEAN

clean: clean-direnv clean-mac-os-junk clean-coq

clean-direnv:
	rm -rvf .direnv

clean-mac-os-junk:
	rm -rvf **/.DS_Store

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
