####################################
## Python DLL Injector By BleICer ##
####################################

# Imports
from ctypes import *

try:

    # Setting Modules
    MessageBox = windll.User32.MessageBoxA
    OpenProcess = windll.kernel32.OpenProcess
    VirtualAllocEx = windll.kernel32.VirtualAllocEx
    WriteProcessMemory = windll.kernel32.WriteProcessMemory
    GetModuleHandle = windll.kernel32.GetModuleHandleA
    GetProcAddress = windll.kernel32.GetProcAddress
    CreateRemoteThread = windll.kernel32.CreateRemoteThread
    WaitForSingleObject = windll.kernel32.WaitForSingleObject
    VirtualFreeEx = windll.kernel32.VirtualFreeEx
    EnumProcessModules = windll.psapi.EnumProcessModules
    GetModuleFileNameExA = windll.psapi.GetModuleBaseNameA

    # Consts
    PROCESS_QUERY_INFORMATION = 0x0400
    PROCESS_VM_READ = 0x0010
    PROCESS_ALL_ACCESS = 0xFFFF
    MEM_COMMIT = 0x1000
    MEM_DECOMMIT = 0x4000
    MEM_RESERVE = 0x2000
    MEM_RELEASE = 0x8000
    PAGE_EXECUTE_READWRITE = 0x40
    PAGE_READWRITE = 0x04
    WAIT_FAILED = 0xFFFFFFFF
    WAIT_TIMEOUT = 0x00000102
    WAIT_OBJECT_0 = 0x00000000
    WAIT_ABANDONED = 0x00000080
    INFINITE = 0xFFFFFFFF

    # Get handlers
    _hKernel32 = GetModuleHandle('Kernel32.dll')
    _hLoadLibraryA = GetProcAddress(_hKernel32, 'LoadLibraryA')

    print('')
    print('')
    print('      Python DLL Injector')
    print('      By BleICer')
    print('')
    print('')
    print('  [O] kernel32 at: ' + hex(_hKernel32))
    print('  [O] LoadLibraryA at: ' + hex(_hLoadLibraryA))

    # Getting full path of Dll
    print('  [O] Write Dll full path')
    _dll_path = input('  [O] Dll Path: ')

    _dll_name = _dll_path.split("\\")[-1]

    # Getting process id
    print('  [O] Select your process to attach')
    _pid = input('  [O] Process ID: ')

    if _pid[:2] == '0x':
        _pid = eval(_pid)
    else:
        _pid = int(_pid)

    # Get remote process id handler
    _hProcess = OpenProcess(PROCESS_ALL_ACCESS, 0, _pid)
    if _hProcess == 0:
        raise Exception('Error! Trying to attach process\n    Maybe Process ID wrong!.')
    print('  [O] Process Handler: ' + hex(_hProcess))

    # Creating random memory space with read and write permissons
    # Get pointer of new memory space for full path string
    _pDllPath = VirtualAllocEx(_hProcess, 0, len(_dll_path), MEM_COMMIT, PAGE_READWRITE)
    if _pDllPath == 0:
        raise Exception('Error! Trying to create new memory space.')
    print('  [O] New space memory for dll full path create at: ' + hex(_pDllPath))

    # Write dll full path in new memory space
    print('  [O] Writing in memory: ' + hex(_pDllPath))
    r = WriteProcessMemory(_hProcess, _pDllPath, _dll_path, len(_dll_path), 0)
    if r == 0:
        raise Exception('Error! Trying to write in memory space.')
    print('  [O] Writed Done!.')

    # Create remote Thread an execute LoadLibraryA in remote process
    print('  [O] Creating Remote Thread for execute LoadLibraryA.')
    print('  [O] Trying load: ')
    _hRemoteLoadLibraryA = CreateRemoteThread(_hProcess, 0, 0, _hLoadLibraryA, _pDllPath, 0, 0)
    print('  [O] LoadLibraryA thread created correctly')
    if _hRemoteLoadLibraryA == 0:
        raise Exception('Error! Trying to execute LoadLibraryA(' + _dll_path + ') in remote thread.')

    r = WaitForSingleObject(_hRemoteLoadLibraryA, INFINITE)
    if r == (WAIT_FAILED | WAIT_TIMEOUT | WAIT_OBJECT_0 | WAIT_ABANDONED):
        raise Exception('Error! Waiting LoadLibraryA')
    print('  [O] LoadLibraryA process done.')

    r = VirtualFreeEx(_hProcess, _pDllPath, 0, MEM_RELEASE)
    if r == 0:
        raise Exception('Error! Trying free memory of dll full path')
    print('  [O] Memory space for dll full path free!')
    print('')
    print('  [O] Checking is DLL loaded . . .')
    print('')

    # Vars for modules
    _modules = (c_ulong * 1024)()
    _name = c_buffer(100)
    _size = c_ulong()
    _dll_found = False

    r = EnumProcessModules(_hProcess, byref(_modules), sizeof(_modules), byref(_size))
    if r > 0:
        for o in _modules:
            if o == 0:
                continue
            GetModuleFileNameExA(_hProcess, o, _name, sizeof(_name))

            _tmp = '      DLL: ' + _name.value

            if _name.value == _dll_name:
                _dll_found = True
                _tmp = '  --> ' + _tmp[6::]

            print(_tmp)

    print('')
    if _dll_found:
        print('  [O] Dll injected Successful!')
    else:
        print('')
        print('')
        print('  NOTE: IS POSIBLE THAT YOUR DLL DO NOT LOADED CORRECTLY')
        print('  WARNING: WRITE CORRECTLY FULL PATH OF YOUR DLL')
        print('')
        print('')
        print('  DLL PATH: ' + _dll_path)
        print('  DLL NAME: ' + _dll_name)
        print('')
        print('')
        raise Exception('Dll not loaded!')
    print('')
    print('Press enter to exit!')

except Exception as e:
    print('')
    print('  DLL Inject Fail!.')
    print('')
    print('  [X] ' + str(e))

input()
