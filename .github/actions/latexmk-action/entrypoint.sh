#!/usr/bin/env bash
latexmk -pdf phd_thesis.tex || exit 1
