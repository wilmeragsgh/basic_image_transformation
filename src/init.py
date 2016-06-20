#! /bin/python
__author__ = 'wilmeragsgh'

import sys
import struct
from PIL import Image

def bits(f):
    bytes = (ord(b) for b in f.read())
    for b in bytes:
        for i in reversed(xrange(8)):
            yield (b >> i) & 1

filename = str(sys.argv[1])
file = open(filename, mode='rb')

header = {}
header['magicNumber'] = struct.unpack('<H', file.read(2))[0] # bmp firm
header['fileSize']  = struct.unpack('<I', file.read(4))[0] # file size 
header['reserved1'] = struct.unpack('<H', file.read(2))[0] # reserved 1
header['reserved2'] = struct.unpack('<H', file.read(2))[0] # reserved 2
header['offset'] = struct.unpack('<I', file.read(4))[0] # offset 
for entry in header:
    print entry + ' ' + str(header[entry])
print '---'

infoHeader = {}
infoHeader['headerSize'] = struct.unpack('<I', file.read(4))[0] # header size 
infoHeader['width'] = struct.unpack('<i', file.read(4))[0] # image weight
infoHeader['height'] = struct.unpack('<i', file.read(4))[0] # image height
infoHeader['colourPlanes'] = struct.unpack('<H',file.read(2))[0] # number of colour planes
infoHeader['bitsPerPixel'] =  struct.unpack('<H',file.read(2))[0] # number of bits per pixel
infoHeader['compressionType'] = struct.unpack('<I', file.read(4))[0] # compression type
infoHeader['imageSize'] = struct.unpack('<I', file.read(4))[0] # image size in bytes
infoHeader['xresolution'] = struct.unpack('<i', file.read(4))[0] # pixel per meter in x axis 
infoHeader['yresolution'] = struct.unpack('<i', file.read(4))[0] # pixel per meter in y axis
infoHeader['nColours'] = struct.unpack('<I', file.read(4))[0] # number of colours
infoHeader['imColours'] = struct.unpack('<I', file.read(4))[0] # number of important colours 

for entry in infoHeader:
    print entry + ' ' + str(infoHeader[entry])

if infoHeader['bitsPerPixel'] == 1:
    imageMode = '1' 
    if infoHeader['nColours'] > 0:
        imageMode = 'P'

if infoHeader['bitsPerPixel'] == 4:
    imageMode = 'P'
if infoHeader['bitsPerPixel'] == 8:
    imageMode = 'P'
if infoHeader['bitsPerPixel'] == 16:
    imageMode = 'P'
if infoHeader['bitsPerPixel'] == 24:
    imageMode = 'RGB'

if imageMode == 'P':
    ncol = str(infoHeader['nColours']) + 'I'
    nbytes = infoHeader['nColours'] * 4
    infoHeader['palette'] = struct.unpack(ncol,file.read(nbytes))
    #strs = str(infoHeader['width']*infoHeader['height']) + 'H'
    imageData = file.read(infoHeader['width']*infoHeader['height'])

if imageMode == '1':
    imageData = ''
    for it in xrange(infoHeader['width']*infoHeader['height']):
        for bit in bits(file):
            imageData = imageData + str(bit)
if imageMode == 'RGB':
    imageData = ''
    for i in xrange(infoHeader['height']):
        for j in xrange(infoHeader['width']):
            imageData = (file.read(3))[::-1] + imageData
        imageData = imageData[::-1]

if imageMode != 'RGB':
    imageData = imageData[::-1]
if imageMode != 'P':
    img = Image.frombytes(imageMode,(infoHeader['width'],infoHeader['height']),imageData)
if imageMode == 'P':
    img = Image.frombytes(imageMode,(infoHeader['width'],infoHeader['height']),imageData)
 
img.show()
