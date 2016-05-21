#!/bin/bash
find . -iname '*.elm' | entr ./make.sh
