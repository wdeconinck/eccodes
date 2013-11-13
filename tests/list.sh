#!/bin/sh
# Copyright 2005-2013 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# 
# In applying this licence, ECMWF does not waive the privileges and immunities granted to it by
# virtue of its status as an intergovernmental organisation nor does it submit to any jurisdiction.
#

. ./include.sh

cat > list.filter <<EOF
set productDefinitionTemplateNumber=31;
set numberOfContributingSpectralBands=4;
set satelliteSeries={61,61,61,62};
set satelliteNumber={4,4,4,5};
set instrumentType={591,591,591,592};
set scaleFactorOfCentralWaveNumber={3,3,3,4};
set scaledValueOfCentralWaveNumber={26870,9272,8377,22334};
write "test.grib";
EOF

# First create the grib2 file from grib1
gname=reduced_gaussian_model_level
grib1File=${data_dir}/${gname}.grib1
grib2File=${data_dir}/${gname}.grib2
${tools_dir}grib_set -s editionNumber=2 $grib1File $grib2File

file="$grib2File"
${tools_dir}grib_filter  list.filter $file

cat >list.filter<<EOF
print("x.out") "productDefinitionTemplateNumber=[productDefinitionTemplateNumber]";
print("x.out") "numberOfContributingSpectralBands=[numberOfContributingSpectralBands]";
print("x.out") "satelliteSeries={[satelliteSeries',']}";
print("x.out") "satelliteNumber={[satelliteNumber',']}";
print("x.out") "instrumentType={[instrumentType',']}";
print("x.out") "scaleFactorOfCentralWaveNumber={[scaleFactorOfCentralWaveNumber',']}";
print("x.out") "scaledValueOfCentralWaveNumber={[scaledValueOfCentralWaveNumber',']}";
EOF

${tools_dir}grib_filter list.filter test.grib

cat >list.ref<<EOF
productDefinitionTemplateNumber=31
numberOfContributingSpectralBands=4
satelliteSeries={61,61,61,62}
satelliteNumber={4,4,4,5}
instrumentType={591,591,591,592}
scaleFactorOfCentralWaveNumber={3,3,3,4}
scaledValueOfCentralWaveNumber={26870,9272,8377,22334}
EOF

diff x.out list.ref

rm -f x.out list.ref list.filter test.grib $grib2File
