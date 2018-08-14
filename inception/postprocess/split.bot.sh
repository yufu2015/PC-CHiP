
input=$1
outDir=$2

awk -v outDir=$outDir -v i=$field '{print $0 >> outDir "/" substr($1, 1, 23) ".txt"; close(outDir "/" substr($1, 1, 23) ".txt")}' $input


