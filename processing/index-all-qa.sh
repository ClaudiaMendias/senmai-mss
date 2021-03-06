#!/usr/bin/env bash

# Command arguments
# $1 = Optional mode:
#           Append 'force' to disable checking for data issues and push to Solr without prompting
#           Append 'noindex' to generate the files and do the checking but not push to Solr

if [ ! "$1" == "force" ]; then
    # Give up if any one index fails or is abandoned
    set -e
fi

# Re-index manuscripts (includes rebuilding customized manuscript HTML pages, which must be run first)
./generate-html.sh && ./generate-solr-document.sh manuscripts.xquery manuscripts_index.xml manuscript solr01-qa.bodleian.ox.ac.uk $1

# Reindex works
./generate-solr-document.sh works.xquery works_index.xml work solr01-qa.bodleian.ox.ac.uk $1

# Reindex people
./generate-solr-document.sh persons.xquery persons_index.xml person solr01-qa.bodleian.ox.ac.uk $1

# Senmai TEI files do not currently support a fourth index
