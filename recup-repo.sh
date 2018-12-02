#!/bin/sh

rm -rf src

mkdir src

cd src

for repo in $(cat "../repo-name.txt"); do
	echo ${repo}
	git clone "https://github.com/CentraleFitness/$repo"
done
