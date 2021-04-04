from _ctypes import call_function
import ctypes

KERNEL32 = ctypes.windll.kernel32


def main():
    KERNEL32.GetModuleHandleW.argtypes = [ctypes.c_wchar_p]
    KERNEL32.GetModuleHandleW.restype = ctypes.c_void_p
    KERNEL32.GetProcAddress.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
    KERNEL32.GetProcAddress.restype = ctypes.c_void_p
    handle = KERNEL32.GetModuleHandleW("User32.dll")
    address = KERNEL32.GetProcAddress(handle, b"MessageBoxA")
    call_function(address, (None, b"Test1", b"Test2", 0))


main()
