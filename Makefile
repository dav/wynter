SHELL := /usr/bin/env bash

.PHONY: console deps test

deps:
	mix deps.get

console:
	iex -S mix

test:
	mix test
