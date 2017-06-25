#!/bin/bash

cmsDriver.py step3  --conditions auto:phase2_realistic -n 10 --era Phase2C2_timing --eventcontent FEVTDEBUGHLT,MINIAODSIM --runUnscheduled  -s RAW2DIGI,L1Reco,RECO,PAT --datatier GEN-SIM-RECO,MINIAODSIM --geometry Extended2023D17 --customise SLHCUpgradeSimulations/Configuration/aging.customise_aging_1000 --no_exec --filein file:step2.root  --fileout file:step3.root
