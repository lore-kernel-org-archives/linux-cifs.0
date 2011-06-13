From: Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mount.cifs failed with Mac OS X 10.7 (LION, Preview 4)
Date: Mon, 13 Jun 2011 19:32:32 +0000 (UTC)
Message-ID: <loom.20110613T211710-599@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Server: Mac OS X 10.7 (LION, Preview 4)
Apple replaces samba with their own smbx which speaks SMB1 and SMB2.
[In an earlier post, I was wrong by stating Apple's smbx only speaks smb2.]

client: ubuntu 11.04 32-bit
I moved the original mount.cifs (version 4.5) to mount.cifs.old, and installed
mount.cifs version 5.0.

$ uname -r
2.6.38-8-generic
$ /sbin/mount.cifs -V
mount.cifs version: 5.0
$ /sbin/mount.cifs.old -V
mount.cifs version: 4.5

$ /sbin/mount.cifs -v -o user=administrator,pass=YYYY //192.168.77.244/Misc mnt
mount.cifs kernel mount options:
ip=192.168.77.244,unc=\\192.168.77.244\Misc,,ver=1,user=administrator,pass=****
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

The debugging output ("echo 7 > /proc/fs/cifs/cifsFYI"):
[ 3770.285371] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c: 
Devname: //192.168.77.244/Misc flags: 0 
[ 3770.288473] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: in cifs_mount as Xid: 136 with uid: 0
[ 3770.288501] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Username: administrator
[ 3770.288521] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
UNC:\\192.168.77.244\Misc ip: 192.168.77.244
[ 3770.288556] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Socket created
[ 3770.299030] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
[ 3770.308263] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: in cifs_get_smb_ses as Xid: 137 with uid: 0
[ 3770.308283] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Existing smb sess not found
[ 3770.308308] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
secFlags 0x7
[ 3770.308328] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
For smb_command 114
[ 3770.308352] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
Sending smb: total_len 82
[ 3770.308592] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Demultiplex PID: 3241
[ 3770.309134] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
rfc1002 length 0x29
[ 3770.309188] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
sync_mid_result: cmd=114 mid=1 state=4
[ 3770.309246] Status code returned 0xc00000bb NT_STATUS_NOT_SUPPORTED
[ 3770.309295] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
Mapping smb error code 0xc00000bb to POSIX err -22
[ 3770.309324] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
negprot rc -22
[ 3770.309377] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: leaving cifs_get_smb_ses (xid = 137) rc = -22
[ 3770.309412] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: leaving cifs_mount (xid = 136) rc = -22
[ 3770.309422] CIFS VFS: cifs_mount failed w/return code = -22

The smbx on Mac logged the following:
192.168.77.244 SMB client not supported - Unicode, NT Errors, Long names and
Extended Security are required

$ /sbin/mount.cifs.old -v -o user=administrator,pass=YYYY
//192.168.77.244/Misc mnt
mount.cifs kernel mount options:
ip=192.168.77.244,unc=\\192.168.77.244\Misc,,ver=1,user=administrator,pass=****
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

The debugging output ("echo 7 > /proc/fs/cifs/cifsFYI"):
[ 4121.323128] /build/buildd/linux-2.6.38/fs/cifs/cifsfs.c:
Devname://192.168.77.244/Misc/ flags: 64 
[ 4121.325289] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: in cifs_mount as Xid: 138 with uid: 0
[ 4121.325302] /build/buildd/linux-2.6.38/fs/cifs/connect.c: 
Username: administrator
[ 4121.325307] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
UNC:\\192.168.77.244\Misc ip: 192.168.77.244
[ 4121.325329] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Socket created
[ 4121.326135] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
[ 4121.326236] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: in cifs_get_smb_ses as Xid: 139 with uid: 0
[ 4121.326240] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Existing smb sess not found
[ 4121.326252] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
secFlags 0x7
[ 4121.326261] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
For smb_command 114
[ 4121.326265] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
Sending smb: total_len 82
[ 4121.326384] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
Demultiplex PID: 3333
[ 4121.327110] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
rfc1002 length 0x29
[ 4121.327180] /build/buildd/linux-2.6.38/fs/cifs/transport.c:
sync_mid_result:cmd=114 mid=1 state=4
[ 4121.327186] Status code returned 0xc00000bb NT_STATUS_NOT_SUPPORTED
[ 4121.327191] /build/buildd/linux-2.6.38/fs/cifs/netmisc.c:
Mapping smb error code 0xc00000bb to POSIX err -22
[ 4121.327202] /build/buildd/linux-2.6.38/fs/cifs/cifssmb.c:
negprot rc -22
[ 4121.327209] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: leaving cifs_get_smb_ses (xid = 139) rc = -22
[ 4121.327220] /build/buildd/linux-2.6.38/fs/cifs/connect.c:
CIFS VFS: leaving cifs_mount (xid = 138) rc = -22
[ 4121.327225] CIFS VFS: cifs_mount failed w/return code = -22

The smbx on Mac logged the following:
192.168.77.244 SMB client not supported - Unicode, NT Errors, Long names and
Extended Security are required


* I can mount a share on the same mac from Win2003 or Win2008 client.
* the same command works with prior version of Mac OS X (which uses Samba).

Any suggestions?

Thanks.

Kong
