#!/bin/python

from sys import stdin

for line in stdin:
    parts = line.strip().split('m')
    parts[1] = parts[1].strip('s')
    print str((float(parts[0]) * 60) + float(parts[1]))
