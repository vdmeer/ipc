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
## - builds all artifacts for distributions
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.7.2
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar

GO_AHEAD=true

RELEASE_VERSION="$(cat src/main/version.txt)"
##TOOL_VERSION="${RELEASE_VERSION}"

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


if [[ -z "${SKB_FRAMEWORK_HOME:-}" ]]; then
    printf "\n\nPlease set SKB_FRAMEWORK_HOME\n\n"
    GO_AHEAD=false
fi
if [[ -z "${SKB_DASHBOARD:-}" ]]; then
    printf "\n\nPlease set SKB_DASHBOARD\n\n"
    GO_AHEAD=false
fi



help(){ 
    printf "\nusage: build [targets]\n"
    printf "\n  targets:"
    printf "\n    all       - build all target in the right order"
    printf "\n    clean     - remove all built artifacts (gradle, maven)"
    printf "\n    dist      - build framework artifacts and then distributions (gradle)"
    printf "\n    lcnps     - build LCN postscript document"
#    printf "\n    tool      - build IPC Framework Tool (gradle)"
    printf "\n    site      - build the Maven site (maven)"
    printf "\n    versions  - set file versions in comments"
    printf "\n"
    printf "\n Requirements:"
    printf "\n - SKB Dashboard   - to build artifacts, requires SKB Framework"
    printf "\n - lualatex        - to build LCN postscript"
    printf "\n - latexmk         - to build LCN postscript"
    printf "\n - gradle          - to build the the distributions"
#    printf "\n - JDK8            - to build the tool"
    printf "\n - Apache Ant      - to set file versions"
    printf "\n - Apache Maven    - to build the site"
#    printf "\n - asciidoctor     - to build some targets for the manual"
#    printf "\n - asciidoctor-pdf - to build the PDF manual"
#    printf "\n - coderay         - for syntax highlighting in ADOC files"
    printf "\n Most requirements are not tested, build will simply fail"
    printf "\n\n"
}


if [[ -z "${1:-}" ]]; then
    printf "\n\nNo target given, try '-h' or '--help' for information\n\n"
    GO_AHEAD=false
fi


if [[ ${GO_AHEAD} == false ]]; then
    exit 1
fi


##
## function: clean - cleans all artifacts
##
clean(){ 
    printf "%s\n\n" "clean"

    ./gradlew clean
    mvn clean
    $SKB_DASHBOARD -B -e clean --sq --lq --task-level debug -- --force

    (cd src/main/lcn/postscript/; latexmk -C)

    printf "\n\n"
}



##
## function: versions - uses ANT to set file versions in comments
##
versions(){
    printf "%s\n\n" "set file versions"
    ant -f ant/build.xml -DmoduleVersion=${RELEASE_VERSION} -DmoduleDir=../
}



##
## function: distro - builds framework artifacts and distributions
##
distro(){ 
    if [[ ! -f "./src/main/lcn/guide/lcn-guide.pdf" ]]; then
        printf "Missing distribution file: ./src/main/lcn/guide/lcn-guide.pdf\n"
        GO_AHEAD=false
    fi 
    if [[ ! -f "./src/main/lcn/layouts/lcn-layouts.pdf" ]]; then
        printf "Missing distribution file: ./src/main/lcn/layouts/lcn-layouts.pdf\n"
        GO_AHEAD=false
    fi 
    if [[ ! -f "./src/main/lcn/postscript/lcn-postscript.pdf" ]]; then
        printf "Missing distribution file: ./src/main/lcn/postscript/lcn-postscript.pdf\n"
        GO_AHEAD=false
    fi 

    if [[ $GO_AHEAD == false ]]; then
        return
    fi

    printf "%s\n\n" "building distributions"
    ./gradlew build
    printf "\n\n"
    printf "%s\n" "distributions in ./build/distributions"
    ls -l ./build/distributions
    printf "\n\n"
}



##
## function: site - builds the Maven site
##
site(){
    printf "%s\n\n" "building site"
    $SKB_DASHBOARD -B -e skb-build-sites --sq --lq --task-level debug -- --build --all --ad --site --stage
}



##
## function: lcn_ps - builds LCN Postscript PDF file
##
lcn_ps(){
    printf "%s\n\n" "building LCN Postscript"
    (cd src/main/lcn/postscript/; lualatex lcn-postscript)
    $SKB_DASHBOARD -e acronyms-latex --sq --lq --task-level debug
    (cd src/main/lcn/postscript/; latexmk -lualatex -bibtex)
    (cd src/main/lcn/postscript/; rm *.fls; rm *.run.xml)
}



while [[ $# -gt 0 ]]; do
    case "$1" in
        all)
            T_CLEAN=true
            T_DIST=true
            T_LCN_PS=true
            T_SITE=true
            T_VERSIONS=true
            shift
            ;;
        clean)
            T_CLEAN=true
            shift
            ;;
        dist)
            T_DIST=true
            shift
            ;;
        lcnps)
            T_LCN_PS=true
            shift
            ;;
        site)
            T_SITE=true
            shift
            ;;
        versions)
            T_VERSIONS=true
            shift
            ;;
        -h | --help)
            help
            exit 0
            ;;
        *)
            printf "\nunknown target '$1'\n\n"
            help
            exit 2
            ;;
    esac
done



TS=$(date +%s.%N)
TIME_START=$(date +"%T")
export SF_MVN_SITES=$PWD

if [[ ${T_VERSIONS:-} == true ]]; then
    versions
fi

if [[ ${T_CLEAN:-} == true ]]; then
    clean
fi

if [[ ${T_LCN_PS:-} == true ]]; then
    lcn_ps
fi

if [[ ${T_DIST:-} == true ]]; then
    distro
fi
if [[ ${T_SITE:-} == true ]]; then
    site
fi


TE=$(date +%s.%N)

TIME=$(date +"%T")
RUNTIME=$(echo "($TE-$TS)/60" | bc -l)
printf "started:  $TIME_START\n"
printf "finished: $TIME, in $RUNTIME minutes\n\n"
