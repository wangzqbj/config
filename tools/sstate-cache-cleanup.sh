#!/bin/bash
############################################################################
##
## Copyright (C) 2017 The Qt Company Ltd.
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Boot to Qt meta layer.
##
## $QT_BEGIN_LICENSE:GPL$
## Commercial License Usage
## Licensees holding valid commercial Qt licenses may use this file in
## accordance with the commercial license agreement provided with the
## Software or, alternatively, in accordance with the terms contained in
## a written agreement between you and The Qt Company. For licensing terms
## and conditions see https://www.qt.io/terms-conditions. For further
## information use the contact form at https://www.qt.io/contact-us.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
## $QT_END_LICENSE$
##
############################################################################

set -e
if [ $# -lt 1 ]; then
    echo "Usage: $0 <sstate-cache-dir(s)>"
    echo "Remove all old files from <sstate-cache-dir(s)>"
    exit 1
fi
DAYS_TO_KEEP=7
NOW=$(date +%s)
for cachedir in $@; do
  if [ ! -d $cachedir ]; then
    echo "$cachedir: No such directory"
    continue
  fi
  # find the most recently modified file's timestamp
  LATEST=$(find $cachedir -type f -printf '%T@\n' | sort -n | tail -1 | cut -f 1 -d'.')
  # calculate days
  TIMEOUT=$(( ($NOW - $LATEST) / 3600 / 24 + $DAYS_TO_KEEP ))
  # delete all files older
  find ${cachedir} -type f -atime +${TIMEOUT} -delete
done
