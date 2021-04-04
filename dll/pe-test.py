import pefile
import sys

if len(sys.argv) != 2:
    print("Usage: pe-test.py <file>")
else:
    file = pefile.PE(sys.argv[1])
    if file.is_dll():
        print("File is a DLL.")
    elif file.is_exe():
        print("File is an EXE.")
    else:
        print("File is not a PE.")
