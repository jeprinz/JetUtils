if [ $# -ne 3 ]
then
    echo "Usage: $0 <.config> <JRA.root> <out dir name>"
    exit
fi

CONFIG=$1
JRA=$2
DIR=$3

mkdir $DIR
cd $DIR

jet_response_analyzer_x ../$CONFIG -input ../$JRA
jet_response_fitter_x -input jra.root
jet_response_and_resolution_x -input jra_f.root

