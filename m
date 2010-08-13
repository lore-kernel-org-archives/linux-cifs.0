From: Martin Decker <martin.decker-W6hacnnSDYuikuSvNLsyVV6hYfS7NtTn@public.gmane.org>
Subject: Problems with writing to CIFS share on RHEL5U2
Date: Fri, 13 Aug 2010 10:14:17 +0000 (UTC)
Message-ID: <loom.20100813T121322-55@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Problems with writing to CIFS share on RHEL5U2
Antworten
|
Martin Decker
 an linux-cifs-cli.
	
Details anzeigen 12:06 (Vor 6 Minuten)
	
Dear List,

I am having different kinds of problems when writing Oracle backups to a CIFS
share on RHEL5U2. Server is Windows Server 2003.

cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.50cRH
Active VFS Requests: 1
Servers:

1) Name: 10.1.1.4  Domain: DOM1 Mounts: 2 OS: Windows Server 2003 R2 3790
Service Pack 2
        NOS: Windows Server 2003 R2 5.2 Capability: 0x1f3fd
        SMB session status: 1   TCP status: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 1
MIDs:
State: 2 com: 47 pid: 15478 tsk: ffff81016a30a040 mid 20561


Shares:
1) \\10.1.1.4\Backup$ Uses: 1 Type: NTFS DevInfo: 0x20 Attributes: 0x700ff
PathComponentMax: 255 Status: 1 type: DISK


modinfo cifs
filename:       /lib/modules/2.6.18-92.1.22.el5/kernel/fs/cifs/cifs.ko
version:        1.50cRH


/etc/fstab:
//10.1.1.4/Backup$ /backup cifs
directio,username=WinUser,password=xxx,_netdev,uid=oracle,gid=oinstall 0 0



The errors are

1.

ORA-27041: unable to open file
27041, 00000, "unable to open file"
// *Cause:  open system call returned an error, additional information
//          indicates which function encountered the error
// *Action: check errno

Linux-x86_64 Error: 26: Text file busy
Additional information: 4

2.

ORA-27072: File I/O error
Linux-x86_64 Error: 13: Permission denied
Additional information: 4
Additional information: 33280769
Additional information: -1

// *Cause:  read/write/readv/writev system call returned error, additional
//          information indicates starting block number of I/O
// *Action: check errno


3.
ORA-27072: File I/O error
Linux-x86_64 Error: 9: Bad file descriptor
Additional information: 4
Additional information: 574977
Additional information: 458752

27072, 00000, "File I/O error"
// *Cause:  read/write/readv/writev system call returned error, additional
//          information indicates starting block number of I/O
// *Action: check errno


Any help on how this can be troubleshooted would be greatly appreciated.

Best regards,
Martin






-- 
--
Martin Decker
Dipl.-Ing. (FH)
Oracle 11g Certified Master

+49 (0) 176 787 627 88
Munich, Germany


martin.decker-W6hacnnSDYuikuSvNLsyVV6hYfS7NtTn@public.gmane.org
http://www.ora-solutions.net
Antworten
		
Weiterleiten
		
		
