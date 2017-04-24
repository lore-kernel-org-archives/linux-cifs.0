From: =?UTF-8?Q?Miloslav_H=c5=afla?= <miloslav.hula-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mout.cifs - No such file or directory/Permission denied
Date: Mon, 24 Apr 2017 12:59:06 +0200
Message-ID: <0e877de6-0d85-d185-aaa9-f64b058e19b6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I'm trying to mount NetApp CIFS share, but without success. Connecting 
it as a network drive or accessing it directly by pasting path into 
explorer in Windows 8/10 works. smbclient works too.

NAS is NetApp ONTAP 9 connected to domain.

I'm accessing the shared folder as 'AI-3DLab' user. He is not member of 
any group.

Path to desired folder
======================
\\local.tld\Shares\K129\Private\www\3dlab\www

Persmissions
============
User AI-3DLab has no permission for full path.
\Shares - yes
        \K129\Private\www - no
                         \3dlab\www - yes

Full permissions description follows. I'm using acronyms:
- TF = This folder
- S  = Subfolders
- F  = Files

=====
Shares (Share)
     - Authenticated Users - Full Control

Shares (NTFS)
     - NasAdmins - Full Control - TF,S,F
     - Authenticated Users - List folder, Traverse folder - TF

Shares\K129 (NTFS)
     - (inherited)

Shares\K129\Private (NTFS)
     - (inherited)

Shares\K129\Private\www (NTFS)
     - (inherited)

Shares\K129\Private\www\3dlab (NTFS)
     - (inherited)
     - AI-3DLab - Traverse folder, List folder, Read attributes, Read 
extended attributes, Read permissions - TF,S,F

Shares\K129\Private\www\3dlab\www (NTFS)
     - (inherited)
=====


Mount works if I'm mounting "root" Shares forder:
# mount -t cifs '\\local.tld\Shares' /mnt -o credentials=/cred

The mount is successful. But accessing the folder failed:
# cd /mnt/K129/Private/www/3dlab/www
bash: cd: /mnt/K129/Private/www/3dlab/www: Permission denied

# ls /mnt/K129/Private/www/3dlab/www
ls: cannot access /mnt/K129/Private/www/3dlab/www: Permission denied

 From the tcpdump sniff during 'ls' or 'cd' I can see:
=====================================================
Request, QUERY_PATH_INFO, Query File All Info, Path: \\local.tld\Shares
Response, Query_PATH_INFO
Request, QUERY_PATH_INFO, Query File All Info, Path: \\local.tld\Shares\K129
Response, Query_PATH_INFO
Request, QUERY_PATH_INFO, Query File All Info, Path: 
\\local.tld\Shares\K129\Private
Response, Query_PATH_INFO, Error: STATUS_ACCESS_DENIED

The error is correct, user AI-3DLab has no access to folder 
Shares\K129\Private.


When I use vers=3.0 (or 2.0+), there is a different error in sniffs,
# mount -t cifs '\\local.tld\Shares' /mnt -o credentials=/cred,vers=3.0

Again, the mount is successful, but accessing the folder failed. Result 
of the 'cd' or 'ls' commands is the same, Permission denied.

In sniffs
=========
Create Request File: K129
Create Response File: K129
GetInfo FILE_INFO/SMB2_FILE_ALL_INFO File: K129
GetInfo Response
Close Request File: K129
Close Response
Create Request File: K129\Private (Access Mask: 0x80 - READ ATTRIBUTES)
Create Response, Error: STATUS_ACCESS_DENIED

The error is correct, user AI-3DLab has no access to folder 
Shares\K129\Private.


When I'm trying to mount subfolder directly, mount fails
========================================================
# mount -t cifs '\\local.tld\Shares\K129\Private\www\3dlab\www' /mnt -o 
credentials=/cred
mount error(2): No such file or directory

# mount -t cifs '\\local.tld\Shares\K129\Private\www\3dlab\www' /mnt -o 
credentials=/cred,vers=3.0
mount error(13): Permission denied

In sniffs, there are the same errors as above, corresponding to SMBv1 or 
SMBv3.


 From my point of view, NTFS permissions are correct. Access by 
Explorer, Total Commander or smbclient works.

Is there some explanation, why mount.cifs performs access to 
intermediate folders?


When I add permission
=====================
Shares\K129 (NTFS)
     - (inherited)
     - AI-3DLab - Read attributes - TF,S,F  <==== this is new

mount works fine. For us, it is a workaround. We have a strict policy on 
NTFS permissions.


Some system info follows
========================
# modinfo /lib/modules/3.16.0-4-amd64/kernel/fs/cifs/cifs.ko
filename:       /lib/modules/3.16.0-4-amd64/kernel/fs/cifs/cifs.ko
version:        2.03
description:    VFS to access servers complying with the SNIA CIFS 
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
alias:          fs-cifs
srcversion:     F20B9C568CAD501A7B7FAAE
depends:        fscache,dns_resolver
intree:         Y
vermagic:       3.16.0-4-amd64 SMP mod_unload modversions
parm:           CIFSMaxBufSize:Network buffer size (not including 
header). Default: 16384 Range: 8192 to 130048 (uint)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 
1 to 64 (uint)
parm:           cifs_min_small:Small network buffers in pool. Default: 
30 Range: 2 to 256 (uint)
parm:           cifs_max_pending:Simultaneous requests to server. 
Default: 32767 Range: 2 to 32767. (uint)
parm:           enable_oplocks:Enable or disable oplocks. Default: y/Y/1 
(bool)

# dpkg -l | grep cifs
ii  cifs-utils  2:6.4-1  amd64

OS is Debian Jessie.


Thank you. Kind regards, Milo
