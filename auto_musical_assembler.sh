#!/bin/bash

if [ "$2" ] 
then
    echo "Writing out to specified output file"
    ./special_musical_assembler < ${1} > ${2}
else
    echo "Writing out to out.obj"
    ./special_musical_assembler < ${1} > out.obj
fi
