#!/bin/bash

# This is a script for converting a batch of one or more DXF files into cookie
# cutter STL files.
#
# Usage:
#     dxf-to-cookie-cutter-stl.sh DXF_FILE...
#
# The outputs will have the same names as the inputs, with the ".dxf" extension
# replaced by ".stl".
#
# See README.md for details on how to create suitable DXF files.

for dxf ; do
    stl="$(basename "$dxf" .dxf).stl"
    echo "$dxf -> $stl"
    (set -x; time openscad -o "$stl" -D 'DXF_FILE="'"$dxf"'"' cookie-cutter.scad)
done
