#THIS FILE IS NO LONGER BEING USED
#This file runs a specific command meant to get the unique VM ID for a linux machine, converts the endianness, and then passes the value to createxml.py

import os
import subprocess

#This func runs a specific command meant to get the unique VM ID for a linux machine, converts the endianness, and then passes the value to main

def convertEndian(curr):
    ba = bytearray.fromhex(curr)
    ba.reverse()
    s = ''.join(format(x, '02x') for x in ba)
    finalStr = s.upper()
    return finalStr

if __name__ == '__main__':
    x =  subprocess.check_output("sudo dmidecode | grep UUID", stderr=subprocess.STDOUT, shell=True)
    x = x.decode("utf-8")
    #print(x)
    x = x.split(':')
    x = x[1].strip()
    x = x.split('-')
    for i in range(3):
        x[i] = convertEndian(x[i])

    x = "-".join(x)
    vmId = x
