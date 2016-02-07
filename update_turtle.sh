#!/bin/bash
read -p 'Please enter turtle number: ' turtleid

endloc="/home/timothy/.minecraft/saves/tests/computer/$turtleid"

if [ -d "$endloc" ]; then
	rm -r "$endloc"
fi

mkdir "$endloc"
cp ./* "$endloc"
