#!/usr/bin/env bash

sw="br-int"
set -e
if [ "$1" ]
then
        echo "GROUPS:";
        sudo ovs-ofctl dump-groups $sw -OOpenFlow13;
        echo;echo "FLOWS:";sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=$1 --rsort=priority
	echo
	printf "Flow count: "
	echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=$1 | wc -l)-1))
else
        printf "No table entered. $sw flow count: ";
        echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 | wc -l)-1))
        printf "\nTable0: PortSecurity:  "; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=0| wc -l)-1))
        printf "\nTable1: IngressNat:    "; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=1| wc -l)-1))
        printf "\nTable2: SourceMapper:  "; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=2| wc -l)-1))
        printf "\nTable3: DestMapper:    "; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=3| wc -l)-1))
        printf "\nTable4: PolicyEnforcer:"; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=4| wc -l)-1))
        printf "\nTable5: EgressNAT:     "; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=5| wc -l)-1))
        printf "\nTable6: External:      "; echo $(($(sudo ovs-ofctl dump-flows $sw -OOpenFlow13 table=6| wc -l)-1))
fi
