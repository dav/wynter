SHELL := /usr/bin/env bash

.PHONY: console deps

deps:
	mix deps.get

console:
	iex -S mix
