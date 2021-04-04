# john the ripper
unshadow passwd shadow > password.txt 
john --wordlist=rockyou.txt password.txt

# hashcat
hashcat -m 0 -a 0 -o cracked.txt target_hashes.txt /usr/share/wordlists/rockyou.txt

# medusa
medusa -h 192.168.0.123 -U /root/Documents/user_list.txt -p password -M ftp
medusa -h 192.168.0.123 -u username -P /root/Documents/password_list.txt -M ssh

Available Medusa Modules:
    afp.mod : Brute force module for AFP sessions
    cvs.mod : Brute force module for CVS sessions
    ftp.mod : Brute force module for FTP/FTPS sessions
    http.mod : Brute force module for HTTP
    imap.mod : Brute force module for IMAP sessions
    mssql.mod : Brute force module for MSSQL sessions
    mysql.mod : Brute force module for MySQL sessions
    nntp.mod : Brute force module for NNTP sessions
    pcanywhere.mod : Brute force module for PcAnywhere sessions
    pop3.mod : Brute force module for POP3 sessions
    postgres.mod : Brute force module for PostgreSQL sessions
    rdp.mod : Brute force module for RDP (Microsoft Terminal Server) sessions
    rexec.mod : Brute force module for REXEC sessions
    rlogin.mod : Brute force module for RLOGIN sessions
    rsh.mod : Brute force module for RSH sessions
    smbnt.mod : Brute force module for SMB (LM/NTLM/LMv2/NTLMv2) sessions
    smtp-vrfy.mod : Brute force module for verifying SMTP accounts (VRFY/EXPN/RCPT TO)
    smtp.mod : Brute force module for SMTP Authentication with TLS
    snmp.mod : Brute force module for SNMP Community Strings
    ssh.mod : Brute force module for SSH v2 sessions
    svn.mod : Brute force module for Subversion sessions
    telnet.mod : Brute force module for telnet sessions
    vmauthd.mod : Brute force module for the VMware Authentication Daemon
    vnc.mod : Brute force module for VNC sessions
    web-form.mod : Brute force module for web form
    wrapper.mod : Generic Wrapper Module
End of list