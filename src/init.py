#! /bin/python
__author__ = 'wilmeragsgh'

import sys
import struct

filename = str(sys.argv[1])

file = open(filename, mode='rb')
bmpfirm = file.read(2)

fileSize = struct.unpack('<i', file.read(4))[0]

infoHeader = struct.unpack('<IIIIIIIIII',file.read(40))

for k in infoHeader:
    print k

