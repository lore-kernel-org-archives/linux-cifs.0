From: Bill Marshall <wm.marshall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Can you mount/map to a dfsroot and then cd into the directories
Date: Mon, 16 Apr 2012 13:39:39 -0500
Message-ID: <CALzeim_2e3feNqMX8GEFHqZUnRnF1vOPTwXetrM9=+dacZwfqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have lots of DFS links setup on samba servers. They are mostly
served from SLES w/ Samba 3.0.36

Under windows I can map to a dfs root called \\server\admin and then I
see several "directories" which are symlinks on the samba server. When
I cd into a directory, Samba gives the client a dfs redirect and off I
go to another server.

When I do this from RH 6.2 (mount.cifs 4.8.1) the I get things like:

$ ls
ls: cannot read symbolic link cfengine: Object is remote
ls: cannot read symbolic link cron: Object is remote

then if I try:
$ cd cfengine
-bash: cd: cfengine: Not a directory

I disabled unix extensions on the dfs server, but it doesn't seem to matter.

It works w/ CIFS if I map/mount to \\server\admin\cfengine directly,
but I'm used to connecting to the higher level directory.

Should this work? Could this work?

CIFS debug generates:

fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 15308 with uid: 500
fs/cifs/inode.c: Revalidate: //server/admin inode 0xffff8801461f0328
count 2 dentry: 0xffff88011015e180 d_time 72057589759737855 jiffies
4320580305
fs/cifs/inode.c: Getting info on //server/admin
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path //server/admin
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 104
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=148 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 147927
fs/cifs/inode.c: cifs_revalidate_cache: inode 147927 is unchanged
fs/cifs/inode.c: inode 0xffff8801461f0328 old_time=4320519230
new_time=4320580322
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 15308) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 15309 with uid: 500
fs/cifs/inode.c: Revalidate: //server/admin/cron inode
0xffff8801461f0af0 count 1 dentry: 0xffff8801101a0ec0 d_time 0 jiffies
4320580322
fs/cifs/inode.c: Getting info on //server/admin/cron
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path //server/admin/cron
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 114
fs/cifs/connect.c: rfc1002 length 0x27
fs/cifs/connect.c: invalid transact2 word count
fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=149 state=4
Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
fs/cifs/cifssmb.c: Send error in QPathInfo = -66
fs/cifs/inode.c: creating fake fattr for DFS referral
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 147930
fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 147930 mapping
fs/cifs/inode.c: inode 0xffff8801461f0af0 old_time=4320511879
new_time=4320580325
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 15309) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 15310 with uid: 500
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 15310) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 15311 with uid: 500
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 15311) rc = 0


Bill Marshall
