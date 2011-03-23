From: real mz <realmz6@gmail.com>
Subject: cifs: read dir issue on no-mmu platform
Date: Wed, 23 Mar 2011 18:30:13 +0800
Message-ID: <AANLkTi=hcR-Kt32PNt7pbmTo0Jaco9QPvfOZQ8BpyKaZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: sfrench@us.ibm.com, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Guys,
I've got a read dir error on no-mmu platform. After mount cifs to
/mnt, enter /mnt, mkdir aa then enter aa, mkdir bb, it said "File
exists", but actually it's a empty dir.
This issue will never happen on arm platform, is there any clues to debug it?

//10.99.29.111/temp on /mnt type cifs
(rw,mand,relatime,unc=\\10.99.29.111\temp,username=steven,uid=0,noforceuid,gid=0,noforcegid,addr=10.99.29.111,posixpaths,acl,rsize=16384,wsize=57344,actimeo=1)

root:/mnt> ls
bt_settings.tar.gz  doc
root:/mnt> mkdir aa
root:/mnt> cd aa/
root:/mnt/aa> ls
root:/mnt/aa> mkdir bb
mkdir: can't create directory 'bb': File exists

root:/mnt/aa> cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.71
Features: lanman posix xattr acl
Active VFS Requests: 0
Servers:
1) Name: 10.99.29.111  Domain: WORKGROUP Uses: 1 OS: Unix
	NOS: Samba 3.2.5	Capability: 0x80f3fd
	SMB session status: 1	TCP status: 1
	Local Users To Server: 1 SecMode: 0x2 Req On Wire: 0
	Shares:
	1) \\10.99.29.111\temp Mounts: 1 Type: NTFS DevInfo: 0x0 Attributes: 0x1002f
PathComponentMax: 255 Status: 0x1 type: 0

	MIDs:

I enabled the cifsFYI and get the following trace logs:

fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58725 with uid: 0
fs/cifs/inode.c: Revalidate:  inode 0x02c27dec count 1 dentry:
0x029b22b4 d_time 0 jiffies 965567
fs/cifs/inode.c: Getting info on
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 78
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1163 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 4549328
fs/cifs/inode.c: cifs_revalidate_cache: inode 4549328 is unchanged
fs/cifs/inode.c: inode 0x02c27dec old_time=962297 new_time=965567
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58725) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58726 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58726) rc = 0
fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 58727 with uid: 0
fs/cifs/readdir.c: Full path:  start at: 0
fs/cifs/cifssmb.c: In FindFirst for
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 88
fs/cifs/connect.c: rfc1002 length 0x234
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1164 state=4
fs/cifs/readdir.c: initiate cifs search rc 0
fs/cifs/readdir.c: end of search
fs/cifs/readdir.c: found entry - pos_in_buf 0
fs/cifs/readdir.c: entry 2 found
fs/cifs/readdir.c: loop through 4 times filling dir for net buf 02eda5c0
fs/cifs/readdir.c: new entry 02eda678 old entry 02eda608
fs/cifs/readdir.c: new entry 02eda6ec old entry 02eda678
fs/cifs/readdir.c: For bt_settings.tar.gz
fs/cifs/readdir.c: new entry 02eda780 old entry 02eda6ec
fs/cifs/readdir.c: For doc
fs/cifs/readdir.c: last entry in buf at pos 6 doc
fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 58727) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58728 with uid: 0
fs/cifs/inode.c: Revalidate: /bt_settings.tar.gz inode 0x02c27c94
count 1 dentry: 0x029b2334 d_time 0 jiffies 965569
fs/cifs/inode.c: Getting info on /bt_settings.tar.gz
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /bt_settings.tar.gz
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 116
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1165 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 4550080
fs/cifs/inode.c: cifs_revalidate_cache: inode 4550080 is unchanged
fs/cifs/inode.c: inode 0x02c27c94 old_time=962299 new_time=965569
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58728) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58729 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58729) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58730 with uid: 0
fs/cifs/inode.c: Revalidate: /doc inode 0x02c2707c count 1 dentry:
0x029b2534 d_time 0 jiffies 965569
fs/cifs/inode.c: Getting info on /doc
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /doc
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 86
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1166 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 4697120
fs/cifs/inode.c: cifs_revalidate_cache: inode 4697120 is unchanged
fs/cifs/inode.c: inode 0x02c2707c old_time=962299 new_time=965569
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58730) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58731 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58731) rc = 0
fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 58732 with uid: 0
fs/cifs/readdir.c: end of search
fs/cifs/readdir.c: index not in buffer - could not findnext into it
fs/cifs/readdir.c: could not find entry
fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 58732) rc = 0
fs/cifs/file.c: Closedir inode = 0x02c27dec
fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 58733 with uid: 0
fs/cifs/file.c: Freeing private data in close dir
fs/cifs/file.c: closedir free smb buf in srch struct
fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 58733) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58734 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58734) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58735 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58735) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58736 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58736) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58737 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58737) rc = 0
fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 58738 with uid: 0
fs/cifs/dir.c: parent inode = 0x02c27dec name is: aa and dentry = 0x02044594
fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 58738) rc = 0
fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ff inode = 0x02c27dec
fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 58739 with uid: 0
fs/cifs/cifssmb.c: In POSIX Create
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 104
fs/cifs/connect.c: rfc1002 length 0xb0
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1167 state=4
fs/cifs/cifssmb.c: copying inode info
fs/cifs/inode.c: looking for uniqueid=507
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 507
fs/cifs/inode.c: cifs_revalidate_cache: inode 507 is new
fs/cifs/inode.c: inode 0x02c281f4 old_time=0 new_time=968813
fs/cifs/inode.c: instantiated dentry 02044594 aa to inode 02c281f4
fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 58739) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58740 with uid: 0
fs/cifs/inode.c: Revalidate:  inode 0x02c27dec count 1 dentry:
0x029b22b4 d_time 0 jiffies 969022
fs/cifs/inode.c: Getting info on
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 78
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1168 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 4549328
fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 4549328 mapping
fs/cifs/inode.c: inode 0x02c27dec old_time=965567 new_time=969022
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58740) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58741 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58741) rc = 0
fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 58742 with uid: 0
fs/cifs/readdir.c: Full path:  start at: 0
fs/cifs/cifssmb.c: In FindFirst for
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 88
fs/cifs/connect.c: rfc1002 length 0x2a8
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1169 state=4
fs/cifs/readdir.c: initiate cifs search rc 0
fs/cifs/readdir.c: end of search
fs/cifs/readdir.c: found entry - pos_in_buf 0
fs/cifs/readdir.c: entry 2 found
fs/cifs/readdir.c: loop through 5 times filling dir for net buf 02eda600
fs/cifs/readdir.c: new entry 02eda6b8 old entry 02eda648
fs/cifs/readdir.c: new entry 02eda72c old entry 02eda6b8
fs/cifs/readdir.c: For bt_settings.tar.gz
fs/cifs/readdir.c: new entry 02eda7c0 old entry 02eda72c
fs/cifs/readdir.c: For doc
fs/cifs/readdir.c: new entry 02eda834 old entry 02eda7c0
fs/cifs/readdir.c: For aa
fs/cifs/inode.c: looking for uniqueid=510
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 510
fs/cifs/inode.c: cifs_revalidate_cache: inode 510 is new
fs/cifs/inode.c: inode 0x02c281f4 old_time=0 new_time=969024
fs/cifs/readdir.c: last entry in buf at pos 7 aa
fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 58742) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58743 with uid: 0
fs/cifs/inode.c: Revalidate: /bt_settings.tar.gz inode 0x02c27c94
count 1 dentry: 0x029b2334 d_time 0 jiffies 969024
fs/cifs/inode.c: Getting info on /bt_settings.tar.gz
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /bt_settings.tar.gz
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 116
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1170 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 4550080
fs/cifs/inode.c: cifs_revalidate_cache: inode 4550080 is unchanged
fs/cifs/inode.c: inode 0x02c27c94 old_time=965569 new_time=969024
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58743) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58744 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58744) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58745 with uid: 0
fs/cifs/inode.c: Revalidate: /doc inode 0x02c2707c count 1 dentry:
0x029b2534 d_time 0 jiffies 969024
fs/cifs/inode.c: Getting info on /doc
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /doc
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 86
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1171 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 4697120
fs/cifs/inode.c: cifs_revalidate_cache: inode 4697120 is unchanged
fs/cifs/inode.c: inode 0x02c2707c old_time=965569 new_time=969026
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58745) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58746 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58746) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58747 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58747) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58748 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58748) rc = 0
fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 58749 with uid: 0
fs/cifs/readdir.c: end of search
fs/cifs/readdir.c: index not in buffer - could not findnext into it
fs/cifs/readdir.c: could not find entry
fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 58749) rc = 0
fs/cifs/file.c: Closedir inode = 0x02c27dec
fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 58750 with uid: 0
fs/cifs/file.c: Freeing private data in close dir
fs/cifs/file.c: closedir free smb buf in srch struct
fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 58750) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58751 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58751) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58752 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58752) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58753 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58753) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58754 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58754) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58755 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58755) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58756 with uid: 0
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58756) rc = 0
fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 58757 with uid: 0
fs/cifs/inode.c: Revalidate: /aa inode 0x02c281f4 count 1 dentry:
0x02044214 d_time 0 jiffies 978604
fs/cifs/inode.c: Getting info on /aa
fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /aa
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 84
fs/cifs/connect.c: rfc1002 length 0xa4
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1172 state=4
fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 510
fs/cifs/inode.c: cifs_revalidate_cache: inode 510 is unchanged
fs/cifs/inode.c: inode 0x02c281f4 old_time=969024 new_time=978604
fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 58757) rc = 0
fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 58758 with uid: 0
fs/cifs/dir.c: parent inode = 0x02c281f4 name is: bb and dentry = 0x02044594
fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 58758) rc = 0
fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ff inode = 0x02c281f4
fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 58759 with uid: 0
fs/cifs/cifssmb.c: In POSIX Create
fs/cifs/transport.c: For smb_command 50
fs/cifs/transport.c: Sending smb:  total_len 104
fs/cifs/connect.c: rfc1002 length 0x27
fs/cifs/connect.c: invalid transact2 word count
fs/cifs/transport.c: sync_mid_result: cmd=50 mid=1173 state=4
fs/cifs/netmisc.c: Mapping smb error code 0xc0000035 to POSIX err -17
fs/cifs/cifssmb.c: Posix create returned -17
fs/cifs/inode.c: posix mkdir returned 0xffffffef
fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 58759) rc = -17
