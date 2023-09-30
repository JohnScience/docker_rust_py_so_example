from ctypes import *
import sys

so = sys.argv[1]
cdll = cdll.LoadLibrary(so)
cdll.hello()
