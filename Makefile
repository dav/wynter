SHELL := /usr/bin/env bash

.PHONY: console deps test format

deps:
	mix deps.get

console:
	iex -S mix

test:
	mix test

format:
	mix format
