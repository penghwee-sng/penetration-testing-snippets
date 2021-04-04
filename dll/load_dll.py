import os
import ctypes
import pefile

DLL1_NAME = "msgbox.dll"
DLL1_ENTRYPOINT = "?MyExport@@YAXXZ"


def fix_dlls():
    # dll = pefile.PE(DLL1_NAME)
    # dll.parse_data_directories()
    # for entry in dll.DIRECTORY_ENTRY_IMPORT:
    #     for imp in entry.imports:
    #         if imp.name == b'OutputDebugStringB':
    #             imp.name = b'OutputDebugStringA'
    # dll.write("mydll1-fixed.dll")
    pass


########### Changes from here and below are not allowed ###########

def main():
    fix_dlls()

    dll = ctypes.cdll.LoadLibrary(os.path.join(os.path.dirname(os.path.realpath(__file__)), DLL1_NAME))
    f = dll[DLL1_ENTRYPOINT]
    f.restype = None

    # The following line should print "Success" to the debug stream
    f()


if __name__ == "__main__":
    main()
