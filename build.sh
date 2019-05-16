#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# ============LICENSE_START=======================================================
#  Copyright (C) 2018 Sven van der Meer. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================
#-------------------------------------------------------------------------------

##
## Build script for the SKB IPC
## - builds site for distribution
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.7.2
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar


SKB_HOME=$PWD/../skb
export SD_TARGET=/tmp/sd

export SD_LIBRARY_YAML=${SKB_HOME}/data/library
export SD_ACRONYM_YAML=${SKB_HOME}/data/acronyms
export SD_LIBRARY_DOCS=${SKB_HOME}/documents/library
export SD_LIBRARY_URL=https://github.com/vdmeer/skb/tree/master/data/library
export SD_MVN_SITES="$PWD"

export SD_LATEX_AUX=`pwd`/src/main/lcn/postscript/lcn-postscript.aux
export SD_ACRONYM_LATEX_FILE=`pwd`/src/main/lcn/postscript/content/acronym-db.tex
export SD_LIBRARY_BIB_FILE=`pwd`/src/main/lcn/postscript/content/references.bib


##
## also required:
## - SKB_FRAMEWORK_HOME
## - SKB_DASHBOARD
##


TS=$(date +%s.%N)
TIME_START=$(date +"%T")

$SKB_DASHBOARD -B -e clean --sq --lq --task-level debug -- --force
$SKB_DASHBOARD -B -e skb-build-sites --sq --lq --task-level debug -- --build --all --ad --site --stage

TE=$(date +%s.%N)
TIME=$(date +"%T")
RUNTIME=$(echo "($TE-$TS)/60" | bc -l)
printf "started:  $TIME_START\n"
printf "finished: $TIME, in $RUNTIME minutes\n\n"
