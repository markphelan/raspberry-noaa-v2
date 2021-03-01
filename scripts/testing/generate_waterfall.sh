#!/bin/bash
#
# Purpose: Create a heatmap from a csv generated by rtl_power.
#
# Inputs:
#    1. Input file containing the CSV data
#
# Example:
#   ./generate_waterfall.sh scan.csv.gz

[ $# -lt 1 ] && echo "usage: $0 inputfile" && exit -1
scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

infile=$1
outfile=$1.png

echo "generating $outfile from $infile.
This may take a while, maybe get a coffee?"
$scriptpath/heatmap.py --ytick 60m $infile $outfile
