#! /usr/bin/env bash

## delete local tags
git fetch
git tag -d $(git tag -l)

## delete remote tags
git pull
git fetch
git push origin --delete $(git tag -l) # Pushing once should be faster than multiple times