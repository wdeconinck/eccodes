#!/bin/sh
# Copyright 2005-2014 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# 
# In applying this licence, ECMWF does not waive the privileges and immunities granted to it by
# virtue of its status as an intergovernmental organisation nor does it submit to any jurisdiction.

. ./include.sh

[ -z "$GRIB_DEFINITION_PATH" ] | GRIB_DEFINITION_PATH=`${tools_dir}grib_info -d`

touch tmp$$
for file in `find $GRIB_DEFINITION_PATH -name '*.def' -print`
do
  ${tools_dir}grib_list_keys $file >> tmp$$  
done

cat >keys <<EOF
%{
#include "grib_api_internal.h"
%}
struct grib_keys_hash { char* name; int id;};
%%
EOF
cat tmp$$ | sort | uniq | awk 'BEGIN{x=0;}{print $1","++x}' >> keys
#cat tmp$$ | sort | uniq  >> keys
rm -f tmp$$

