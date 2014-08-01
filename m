From: =?UTF-8?B?SmF2aWVyIE1hcnTDrSBNb25mb3J0ZQ==?= <marti_javmon-S9K+yDyl5s4@public.gmane.org>
Subject: Mount fileshare with prefixpath [mount error(2): No such file or
 directory]
Date: Fri, 01 Aug 2014 10:42:56 +0200
Message-ID: <53DB5310.5060701@gva.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello list,

I have a problem with mounting a cifs share with prefix path, I run 
ubuntu 12.04 Precise Pangolin and I have updated mount.cifs package to 
cifs-utils Version: 2:6.0-1ubuntu2

The command:
# sudo mount -t cifs \\\\machine.server.es\\datos\\13908 
/home/myuser/mountpoint -o "username=myuser,uid=489689328,gid=489685505" 
--verbose

mount.cifs kernel mount options: 
ip=172.27.194.152,unc=\\machine.server.es\datos,uid=489689328,gid=489685505,user=d24399776l,prefixpath=13908,pass=********
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)


The results:

# uname -r
3.2.0-67-generic

# mount.cifs -V
mount.cifs version: 6.0

And a dmesg with debugging activated:

[72758.230822] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Devname: 
\\machine.server.es\datos\13908 flags: 0
[72758.230835] /build/buildd/linux-3.2.0/fs/cifs/connect.c: prefix path 
/13908
[72758.230839] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username: 
d24399776l
[72758.230845] /build/buildd/linux-3.2.0/fs/cifs/connect.c: file mode: 
0x1ed  dir mode: 0x1ed
[72758.230918] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_mount as Xid: 2668 with uid: 0
[72758.230922] /build/buildd/linux-3.2.0/fs/cifs/connect.c: UNC: 
\\machine.server.es\datos ip: 172.27.194.152
[72758.230928] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing tcp 
session with server found
[72758.230932] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_get_smb_ses as Xid: 2669 with uid: 0
[72758.230936] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing smb 
sess found (status=1)
[72758.230940] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_get_smb_ses (xid = 2669) rc = 0
[72758.230944] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Found match 
on UNC path
[72758.230947] /build/buildd/linux-3.2.0/fs/cifs/connect.c: 
cifs_put_smb_ses: ses_count=2
[72758.230949]
[72758.230951] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSDeviceInfo
[72758.230958] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.230962] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 72
[72758.231651] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x4a
[72758.231682] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=137 state=4
[72758.231688] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In 
QFSAttributeInfo
[72758.231692] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.231696] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 72
[72758.232463] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x4c
[72758.232485] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=138 state=4
[72758.232492] /build/buildd/linux-3.2.0/fs/cifs/connect.c: 
build_unc_path_to_root: full_path=\\machine.server.es\datos\13908
[72758.232520] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In 
GetDFSRefer the path \machine.server.es\datos
[72758.232527] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.232530] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 148
[72758.233686] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x140
[72758.233709] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=139 state=4
[72758.233714] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Decoding 
GetDFSRefer response BCC: 265  Offset 56
[72758.233718] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: 
num_referrals: 1 dfs flags: 0x3 ...
[72758.233720]
[72758.233736] /build/buildd/linux-3.2.0/fs/cifs/dns_resolve.c: 
dns_resolve_server_name_to_ip: resolved: machine.server.es to 172.27.194.152
[72758.233752] /build/buildd/linux-3.2.0/fs/cifs/connect.c: prefix path 
/\13908
[72758.233755] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username: 
d24399776l
[72758.233758] /build/buildd/linux-3.2.0/fs/cifs/connect.c: 
cifs_put_tcon: tc_count=2
[72758.233760]
[72758.233763] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_mount (xid = 2668) rc = 0
[72758.233767] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_mount as Xid: 2670 with uid: 0
[72758.233770] /build/buildd/linux-3.2.0/fs/cifs/connect.c: UNC: 
\\machine.server.es\datos ip: 172.27.194.152
[72758.233774] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing tcp 
session with server found
[72758.233778] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_get_smb_ses as Xid: 2671 with uid: 0
[72758.233782] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing smb 
sess found (status=1)
[72758.233785] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_get_smb_ses (xid = 2671) rc = 0
[72758.233789] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Found match 
on UNC path
[72758.233791] /build/buildd/linux-3.2.0/fs/cifs/connect.c: 
cifs_put_smb_ses: ses_count=2
[72758.233793]
[72758.233795] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSDeviceInfo
[72758.233799] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.233802] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 72
[72758.234429] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x4a
[72758.234443] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=140 state=4
[72758.234448] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In 
QFSAttributeInfo
[72758.234452] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.234455] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 72
[72758.235508] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x4c
[72758.235521] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=141 state=4
[72758.235528] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.235532] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 166
[72758.236337] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0xde
[72758.236358] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=142 state=4
[72758.236366] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_mount (xid = 2670) rc = 0
[72758.236382] /build/buildd/linux-3.2.0/fs/cifs/inode.c: CIFS VFS: in 
cifs_root_iget as Xid: 2672 with uid: 0
[72758.236385] /build/buildd/linux-3.2.0/fs/cifs/inode.c: Getting info on
[72758.236389] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.236392] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 78
[72758.237078] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x86
[72758.237092] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=143 state=4
[72758.237098] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In 
GetSrvInodeNum for
[72758.237102] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.237105] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 78
[72758.237773] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x23
[72758.237778] /build/buildd/linux-3.2.0/fs/cifs/connect.c: invalid 
transact2 word count
[72758.237789] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=144 state=4
[72758.237792] Status code returned 0xc0000001 NT_STATUS_UNSUCCESSFUL
[72758.237798] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping smb 
error code 0xc0000001 to POSIX err -5
[72758.237802] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: error -5 in 
QueryInternalInfo
[72758.237805] /build/buildd/linux-3.2.0/fs/cifs/inode.c: GetSrvInodeNum 
rc -5
[72758.237809] CIFS VFS: Autodisabling the use of server inode numbers 
on \\machine.server.es\datos. This server doesn't seem to support them 
properly. Hardlinks will not be recognized on this mount. Consider 
mounting with the "noserverino" option to silence this message.
[72758.237815] /build/buildd/linux-3.2.0/fs/cifs/inode.c: looking for 
uniqueid=7310
[72758.237821] /build/buildd/linux-3.2.0/fs/cifs/inode.c: 
cifs_revalidate_cache: revalidating inode 7310
[72758.237824] /build/buildd/linux-3.2.0/fs/cifs/inode.c: 
cifs_revalidate_cache: inode 7310 is new
[72758.237828] /build/buildd/linux-3.2.0/fs/cifs/inode.c: inode 
0xffff880072b4ad10 old_time=0 new_time=4313081855
[72758.237834] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Get root 
dentry for \\machine.server.es\datos\\13908
[72758.237840] /build/buildd/linux-3.2.0/fs/cifs/dir.c: CIFS VFS: in 
cifs_lookup as Xid: 2673 with uid: 0
[72758.237844] /build/buildd/linux-3.2.0/fs/cifs/dir.c: parent inode = 
0xffff880072b4ad10 name is: machine.server.es and dentry = 
0xffff8800a3f59900
[72758.237849] /build/buildd/linux-3.2.0/fs/cifs/dir.c: NULL inode in lookup
[72758.237853] /build/buildd/linux-3.2.0/fs/cifs/dir.c: Full path: 
\\machine.server.es\datos\machine.server.es inode = 0x (null)
[72758.237857] /build/buildd/linux-3.2.0/fs/cifs/inode.c: Getting info 
on \\machine.server.es\datos\machine.server.es
[72758.237863] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For 
smb_command 50
[72758.237866] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending 
smb:  total_len 212
[72758.238723] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 
header 0x23
[72758.238728] /build/buildd/linux-3.2.0/fs/cifs/connect.c: invalid 
transact2 word count
[72758.238738] /build/buildd/linux-3.2.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=145 state=4
[72758.238742] Status code returned 0xc0000034 
NT_STATUS_OBJECT_NAME_NOT_FOUND
[72758.238747] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping smb 
error code 0xc0000034 to POSIX err -2
[72758.238751] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Send error 
in QPathInfo = -2
[72758.238755] /build/buildd/linux-3.2.0/fs/cifs/dir.c: CIFS VFS: 
leaving cifs_lookup (xid = 2673) rc = 0
[72758.238844] /build/buildd/linux-3.2.0/fs/cifs/connect.c: 
cifs_put_tcon: tc_count=2
[72758.238846]

Anyone can help?

Thank you
