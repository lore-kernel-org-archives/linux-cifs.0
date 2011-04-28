From: Mike <miked-yxPvCyoe84a+XT7JhA+gdA@public.gmane.org>
Subject: CIFS Not Responding Error On Working System
Date: Thu, 28 Apr 2011 12:27:54 -0700
Message-ID: <4DB9BFBA.3020403@softtalker.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hopefully I am submitting this to the correct email list.  I have been 
doing Google searches and haven't found anyone that has the same string 
in their log file, so I'm looking for help on this issue.

Recently I lost my hard drive and had to reinstall Debian.  I am now 
getting these errors in /var/log/syslog and I can't figure out why:
Apr 28 11:57:05 rockenfield kernel: [1479867.192022] CIFS VFS: Server 
peart has not responded in 300 seconds. Reconnecting...

The weird thing is that there are no problems.  I can view the shares on 
the remote Windows machine (peart is WinXP 64 SP2) with no problems 
whatsoever.  Also my Windows machine can see my samba shares as well, so 
both directions work fine and I'm not sure why these messages are occurring.


Here is my /etc/fstab (samba/cifs mounts only, trimmed to applicable 
content):
//peart/mp3  /mnt/peart/mp3 cifs 
defaults,credentials=/etc/samba/smbpass.peart,_netdev 0 0
//peart/software  /mnt/peart/software cifs 
defaults,credentials=/etc/samba/smbpass.peart,_netdev 0 0
//peart/backup  /mnt/peart/backup cifs 
defaults,credentials=/etc/samba/smbpass.peart,_netdev 0 0
//peart/dvd  /mnt/peart/dvd cifs 
defaults,credentials=/etc/samba/smbpass.peart,_netdev 0 0


Here is my /etc/samba/smb.conf:
[global]
    workgroup = HOME_NETWORK
    netbios name = ROCKENFIELD
    server string = %h server - Debian GNU/Linux
    dns proxy = no
    name resolve order = lmhosts host wins bcast
    interfaces = 192.168.123.0/24 eth1
    bind interfaces only = yes
    hosts allow = 192.168.123.
    log file = /var/log/samba/log.%m
    max log size = 1000
    syslog = 0
    panic action = /usr/share/samba/panic-action %d
    security = user
    encrypt passwords = true
    passdb backend = tdbsam
    obey pam restrictions = yes
    unix password sync = yes
    passwd program = /usr/bin/passwd %u
    passwd chat = *Enter\snew\s*\spassword:* %n\n 
*Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
    pam password change = yes
    socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
[homes]
    comment = Home Directories
    browseable = no
    read only = no
    create mask = 0700
    directory mask = 0700
    valid users = %S
[printers]
    comment = All Printers
    browseable = no
    path = /var/spool/samba
    printable = yes
    guest ok = no
    read only = yes
    create mask = 0700
[print$]
    comment = Printer Drivers
    path = /var/lib/samba/printers
    browseable = yes
    read only = yes
    guest ok = no


I am running Debian wheezy/testing (7.0).  The kernel version is 
2.6.38-2-amd64.  Samba version is 3.5.8~dfsg-1 (obtained from "dpkg -l | 
grep samba").  This is just a home network, so I don't have a Domain 
Controller or anything fancy.  It's just a Debian box and a WinXP box 
and I'm sharing files/directories on each side.

Any help is greatly appreciated.  Thanks!
-MikeD
