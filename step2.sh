#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 <GEN-SIM-data-whatever.root>"
    exit
fi

echo "running on input file $1"

OUTFILE=$(pwd)/$(basename $1 .root)-step3.root

echo "creating and running py script which will produce output file $OUTFILE"

#note: removed --no-exec argument so now it will run python script when invoked

cmsDriver.py step2  --conditions auto:phase2_realistic -s DIGI:pdigi_valid,L1,DIGI2RAW,HLT:@fake2 --datatier GEN-SIM-DIGI-RAW -n -1 --geometry Extended2023D17 --era Phase2C2_timing --eventcontent FEVTDEBUGHLT --customise SLHCUpgradeSimulations/Configuration/aging.customise_aging_1000 --filein file:$1  --fileout file:$OUTFILE  > step2_TTbar_14TeV_Timing+TTbar_14TeV_TuneCUETP8M1_2023D17_GenSimHLBeamSpotFull14_Timing+DigiFull_Timing_2023D17+RecoFullGlobal_Timing_2023D17+HARVESTFullGlobal_Timing_2023D17.log  2>&1

echo "Make sure to make modifications to python script. Check that event limit is set to -1"
