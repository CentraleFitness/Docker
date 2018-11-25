#!/bin/sh

mkdir work
cd work

for repo in $(cat "../repo_name.txt"); do
	echo $repo
	git clone "https://github.com/CentraleFitness/$repo"
done
