#!/bin/sh
LINES=`git diff master HEAD -- . | wc -l`
echo Lines changed in docs: $LINES
if [ $LINES -gt 1 ]
then
  exit 1;
else
  exit 0;
fi
