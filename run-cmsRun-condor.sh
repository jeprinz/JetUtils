#!/bin/bash

#This script will take a folder of .root files and also a .py config and run that .py once on each of the .root files.
#It will name the outputs the same as the inputs and place them in the specified folder.

if [ $# -ne 3 ]
then
    echo "Usage: $0 <folder containing .root files> <.sh script to be run> <output folder as xrdcp path>" ; exit
fi

INFOLDER=$1
BASHSCRIPT=$2
OUTFOLDER=$3

BASEDIR=$(dirname "$0") #directory of this script

FILES=$(cd $INFOLDER && ls *.root 2> /dev/null)

#First do a bunch of error checking because these jobs can take a long time to
#Run and we don't want to waste time

if [ -n "$FILES" ] #make sure that there are input foot files and tell them to the user
then
    printf "Running on input files in directory $INFOLDER:\n$FILES\n"
else
    echo "No root files found at $INFOLDER, exiting" ; exit
fi

if [ ! -f "$BASHSCRIPT" ] #make sure python config exists
then
    echo "ERROR: $BASHSCRIPT does not exist, exiting" ; exit
fi

echo "Testing output folder as valid xrdcp path with dummy file"
echo "xrdcp tmp-file $OUTFOLDER && echo worked"
touch tmp-file
DIDITWORK=$(xrdcp tmp-file $OUTFOLDER/tmp-file && echo worked)
rm tmp-file

if [ ! -n "$DIDITWORK" ] #make sure output folder exists
then
    echo "ERROR: $OUTFOLDER is not a valid xrdcp argument."
    echo "Should not be a path, should look like 'root://cmseos.fnal.gov//store/user/username...'" ; exit
fi
echo "Output files will be placed in $OUTFOLDER"
echo "Make sure that this folder does not already have the root files in it. They will not be overridden, and results will be lost"

echo output logs will be located in logs directory

#now actually do things...

for FILE in $FILES ; do
    FOLDER=$(basename condor_job_$FILE .root)
    cp -r $BASEDIR/condor_job_template $FOLDER
    cp $BASHSCRIPT $FOLDER
    #create the condor submit file for each job to be run
    cat >$FOLDER/condor-jobs.jdl <<EOL

universe = vanilla
Executable = cmsRun.sh
Should_Transfer_Files = YES
WhenToTransferOutput = ON_EXIT
Transfer_Input_Files = cmsRun.sh, $(basename $BASHSCRIPT), $(readlink -m $INFOLDER/$FILE)
Output = $(pwd)/condor_job_\$(Cluster)_\$(Process).stdout
Error = $(pwd)/condor_job_\$(Cluster)_\$(Process).stderr
Log = $(pwd)/condor_job_\$(Cluster)_\$(Process).log
Arguments = $(basename $BASHSCRIPT) $OUTFOLDER
Queue 1
EOL
done
