if [ $# -ne 2 ]
then
    echo "Usage: <jra_f_g.root> <1 or 2>"
    exit
fi

FILE=$1
OPTION=$2

if [ "$OPTION" == "1" ]
then
    jet_inspect_graphs_x -inputs $FILE -algs ak4pf -variables RelResVsRefPt:JetEta@0
elif [ "$OPTION" == "2" ]
then
    jet_inspect_graphs_x -inputs $FILE -algs ak4pf -variables RelRspVsRefPt:JetEta@0
else
    echo "Only valid options are 1 and 2 (1 for resolution, 2 for response)"
fi
