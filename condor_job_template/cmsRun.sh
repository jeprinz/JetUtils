#!/bin/bash

#This script gets run inside of the condor job. It will create a CMSSW environment, and execute the user specified script.

SCRIPT=$1
OUTDIR=$2

echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node

echo "ls:"
STARTDIR=$(pwd)
ls


source /cvmfs/cms.cern.ch/cmsset_default.sh  ## if a tcsh script, use .csh instead of .sh
export SCRAM_ARCH=slc6_amd64_gcc530
eval `scramv1 project CMSSW CMSSW_9_1_1_patch1`
cd CMSSW_9_1_1_patch1/src/
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo "CMSSW: "$CMSSW_BASE
echo "Going to run on following root files:"
ls $STARTDIR/*.root
FILES=$(ls $STARTDIR/*.root)
echo "Running $SCRIPT"
bash $STARTDIR/$SCRIPT $FILES #note that this wont work yet for more than one file TODO
### Now that the cmsRun is over, there is one or more root files created
echo "List all root files = "
ls *.root
echo "List all files"
ls 
echo "*******************************************"
echo "xrdcp output for condor"
for FILE in *.root
do
  echo "xrdcp -f ${FILE} ${OUTDIR}/${FILE}"
  xrdcp -f ${FILE} ${OUTDIR}/${FILE} 2>&1
  XRDEXIT=$?
  if [[ $XRDEXIT -ne 0 ]]; then
    rm *.root
    echo "exit code $XRDEXIT, failure in xrdcp"
    exit $XRDEXIT
  fi
  rm ${FILE}
done
