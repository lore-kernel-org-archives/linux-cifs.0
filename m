From: Johann Spies <johann.spies-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Unable to mount.cifs with 3.x kernels
Date: Thu, 28 Feb 2013 09:49:09 +0200
Message-ID: <CAGZ55DQMYUyiSrPodWtfzRFne1qSC+SJn4A2yw6kx6xV-d0jxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When using a 2.6.38 kernel on Debian I can mount a Windows share with
the following in my /etc/fstab:

//stbstaff.stb.sun.ac.za/dept/let/senis /home/js/mnt/senis cifs
credentials=/etc/credentials,domain=stb,user,uid=1000,gid=1000 0     0

and the command 'mount /home/js/mnt/senis/'

But with  3.x kernels (I have a 3.8 self-compiled kernel from Ubuntu sources at
the moment) I get this:

mount error(13): Permission denied

Is that a bug?

Here is some of the debug information for trying to mount with the 3.x kernel:


[ 6392.964925] FS-Cache: Netfs 'cifs' registered for caching
[ 6392.965071] Key type cifs.spnego registered
[ 6392.965087] Key type cifs.idmap registered
[ 6393.003394] CIFS VFS: Autodisabling the use of server inode numbers
on \\stbstaff.stb.sun.ac.za\dept. This server doesn't seem to support
them properly. Hardlinks will not be recognized on this mount.
Consider mounting with the "noserverino" option to silence this
message.
[ 6859.853377] fs/cifs/cifsfs.c: Devname:
//stbstaff.stb.sun.ac.za/dept/let/senis flags: 0
[ 6859.853402] fs/cifs/connect.c: Domain name set
[ 6859.853409] fs/cifs/connect.c: Username: jspies
[ 6859.853412] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
[ 6859.853481] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 7 with uid: 0
[ 6859.853483] fs/cifs/connect.c: UNC: \\stbstaff.stb.sun.ac.za\dept
[ 6859.853504] fs/cifs/connect.c: Socket created
[ 6859.853506] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
[ 6859.853796] fs/cifs/connect.c: Demultiplex PID: 25447
[ 6859.853798] fs/cifs/fscache.c: cifs_fscache_get_client_cookie:
(0xffff880201d54000/0xffff8802115710a0)
[ 6859.853800] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as
Xid: 8 with uid: 0
[ 6859.853802] fs/cifs/connect.c: Existing smb sess not found
[ 6859.853806] fs/cifs/cifssmb.c: secFlags 0x81
[ 6859.853809] fs/cifs/cifssmb.c: NTLMSSP only mechanism, enable
extended security
[ 6859.853813] fs/cifs/transport.c: For smb_command 114
[ 6859.853815] fs/cifs/transport.c: Sending smb: smb_len=78
[ 6859.854160] fs/cifs/connect.c: RFC1002 header 0xa8
[ 6859.854177] fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
[ 6859.854182] fs/cifs/cifssmb.c: Dialect: 2
[ 6859.854189] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
[ 6859.854197] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
[ 6859.854199] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[ 6859.854202] fs/cifs/asn1.c: Need to call asn1_octets_decode()
function for stbstaff$@STB.SUN.AC.ZA
[ 6859.854204] fs/cifs/cifssmb.c: negprot rc 0
[ 6859.854206] fs/cifs/connect.c: Security Mode: 0x3 Capabilities:
0x8000d3fd TimeAdjust: -7200
[ 6859.854207] fs/cifs/sess.c: sess setup type 3
[ 6859.854209] fs/cifs/sess.c: ntlmssp session setup phase 1
[ 6859.854213] fs/cifs/transport.c: For smb_command 115
[ 6859.854214] fs/cifs/transport.c: Sending smb: smb_len=184
[ 6859.854497] fs/cifs/connect.c: RFC1002 header 0x11c
[ 6859.854515] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
[ 6859.854520] Status code returned 0xc0000016
NT_STATUS_MORE_PROCESSING_REQUIRED
[ 6859.854527] fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to
POSIX err -5
[ 6859.854530] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 6859.854533] fs/cifs/sess.c: UID = 2048
[ 6859.854537] fs/cifs/sess.c: bleft 74
[ 6859.854542] fs/cifs/sess.c: serverOS=Windows 5.0
[ 6859.854546] fs/cifs/sess.c: serverNOS=Windows 2000 LAN Manager
[ 6859.854550] fs/cifs/sess.c: ssetup freeing small buf ffff880205300000
[ 6859.854556] fs/cifs/sess.c: ntlmssp session setup phase 3
[ 6859.854583] fs/cifs/transport.c: For smb_command 115
[ 6859.854584] fs/cifs/transport.c: Sending smb: smb_len=408
[ 6859.857439] fs/cifs/connect.c: RFC1002 header 0x7e
[ 6859.857456] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
[ 6859.857460] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 6859.857464] fs/cifs/sess.c: UID = 2048
[ 6859.857466] fs/cifs/sess.c: bleft 82
[ 6859.857470] fs/cifs/sess.c: serverOS=Windows 5.0
[ 6859.857474] fs/cifs/sess.c: serverNOS=Windows 2000 LAN Manager
[ 6859.857477] fs/cifs/sess.c: serverDomain=STB
[ 6859.857481] fs/cifs/sess.c: ssetup freeing small buf ffff8802052b8e00
[ 6859.857484] fs/cifs/connect.c: CIFS Session Established successfully
[ 6859.857490] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses
(xid = 8) rc = 0
[ 6859.857492] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 9
with uid: 0
[ 6859.857495] fs/cifs/transport.c: For smb_command 117
[ 6859.857496] fs/cifs/transport.c: Sending smb: smb_len=110
[ 6859.857820] fs/cifs/connect.c: RFC1002 header 0x3e
[ 6859.857835] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=4 state=4
[ 6859.857840] fs/cifs/connect.c: disk share connection
[ 6859.857843] fs/cifs/connect.c: nativeFileSystem=NTFS
[ 6859.857846] fs/cifs/connect.c: Tcon flags: 0x1
[ 6859.857849] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid
= 9) rc = 0
[ 6859.857852] fs/cifs/connect.c: Tcon rc = 0
[ 6859.857857] fs/cifs/fscache.c: cifs_fscache_get_super_cookie:
(0xffff8802115710a0/0xffff880201f1d000)
[ 6859.857860] fs/cifs/cifssmb.c: In QFSDeviceInfo
[ 6859.857864] fs/cifs/transport.c: For smb_command 50
[ 6859.857867] fs/cifs/transport.c: Sending smb: smb_len=68
[ 6859.858123] fs/cifs/connect.c: RFC1002 header 0x40
[ 6859.858136] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=5 state=4
[ 6859.858141] fs/cifs/cifssmb.c: In QFSAttributeInfo
[ 6859.858144] fs/cifs/transport.c: For smb_command 50
[ 6859.858147] fs/cifs/transport.c: Sending smb: smb_len=68
[ 6859.858387] fs/cifs/connect.c: RFC1002 header 0x4c
[ 6859.858400] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=6 state=4
[ 6859.858406] fs/cifs/connect.c: build_unc_path_to_root:
full_path=\\stbstaff.stb.sun.ac.za\dept\let\senis
[ 6859.858411] fs/cifs/transport.c: For smb_command 117
[ 6859.858414] fs/cifs/transport.c: Sending smb: smb_len=96
[ 6859.858618] fs/cifs/connect.c: RFC1002 header 0x38
[ 6859.858630] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=7 state=4
[ 6859.858635] fs/cifs/connect.c: Tcon rc = 0 ipc_tid = 65
[ 6859.858638] fs/cifs/cifssmb.c: In GetDFSRefer the path
\stbstaff.stb.sun.ac.za\dept
[ 6859.858643] fs/cifs/transport.c: For smb_command 50
[ 6859.858646] fs/cifs/transport.c: Sending smb: smb_len=128
[ 6859.858842] fs/cifs/connect.c: RFC1002 header 0x23
[ 6859.858848] fs/cifs/smb1ops.c: invalid transact2 word count
[ 6859.858857] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=8 state=4
[ 6859.858861] Status code returned 0xc000000e NT_STATUS_NO_SUCH_DEVICE
[ 6859.858866] fs/cifs/netmisc.c: Mapping smb error code 0xc000000e to
POSIX err -2
[ 6859.858869] fs/cifs/cifssmb.c: Send error in GetDFSRefer = -2
[ 6859.858876] fs/cifs/transport.c: For smb_command 50
[ 6859.858878] fs/cifs/transport.c: Sending smb: smb_len=94
[ 6859.859379] fs/cifs/connect.c: RFC1002 header 0x9a
[ 6859.859386] fs/cifs/misc.c: Calculated size 156 vs length 158
mismatch for mid=9
[ 6859.859395] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=9 state=4
[ 6859.859403] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 7) rc = 0
[ 6859.859424] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 10
with uid: 0
[ 6859.859428] fs/cifs/inode.c: Getting info on
[ 6859.859432] fs/cifs/transport.c: For smb_command 50
[ 6859.859435] fs/cifs/transport.c: Sending smb: smb_len=74
[ 6859.859757] fs/cifs/connect.c: RFC1002 header 0x86
[ 6859.859770] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=10 state=4
[ 6859.859776] fs/cifs/cifssmb.c: In GetSrvInodeNum for
[ 6859.859780] fs/cifs/transport.c: For smb_command 50
[ 6859.859782] fs/cifs/transport.c: Sending smb: smb_len=74
[ 6859.859979] fs/cifs/connect.c: RFC1002 header 0x23
[ 6859.859986] fs/cifs/smb1ops.c: invalid transact2 word count
[ 6859.860002] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=11 state=4
[ 6859.860004] fs/cifs/netmisc.c: Mapping smb error code 0x7c0001 to
POSIX err -95
[ 6859.860005] fs/cifs/cifssmb.c: error -95 in QueryInternalInfo
[ 6859.860007] fs/cifs/inode.c: GetSrvInodeNum rc -95
[ 6859.860009] CIFS VFS: Autodisabling the use of server inode numbers
on \\stbstaff.stb.sun.ac.za\dept. This server doesn't seem to support
them properly. Hardlinks will not be recognized on this mount.
Consider mounting with the "noserverino" option to silence this
message.
[ 6859.860011] fs/cifs/inode.c: looking for uniqueid=110
[ 6859.860021] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 110
[ 6859.860023] fs/cifs/inode.c: cifs_revalidate_cache: inode 110 is new
[ 6859.860026] fs/cifs/cifsfs.c: Get root dentry for \let\senis
[ 6859.860030] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 11 with uid: 0
[ 6859.860032] fs/cifs/dir.c: parent inode = 0xffff880190f40078 name
is: let and dentry = 0xffff88013fc83d80
[ 6859.860033] fs/cifs/dir.c: NULL inode in lookup
[ 6859.860035] fs/cifs/dir.c: Full path: \let inode = 0x          (null)
[ 6859.860036] fs/cifs/inode.c: Getting info on \let
[ 6859.860039] fs/cifs/transport.c: For smb_command 50
[ 6859.860040] fs/cifs/transport.c: Sending smb: smb_len=82
[ 6859.860291] fs/cifs/connect.c: RFC1002 header 0x23
[ 6859.860298] fs/cifs/smb1ops.c: invalid transact2 word count
[ 6859.860307] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=12 state=4
[ 6859.860312] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
[ 6859.860317] fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to
POSIX err -13
[ 6859.860320] fs/cifs/cifssmb.c: Send error in QPathInfo = -13
[ 6859.860324] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 11) rc = -13
[ 6859.860393] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[ 6859.860399] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid:
12 with uid: 0
[ 6859.860403] fs/cifs/cifssmb.c: In tree disconnect
[ 6859.860408] fs/cifs/transport.c: For smb_command 113
[ 6859.860412] fs/cifs/transport.c: Sending smb: smb_len=35
[ 6859.860591] fs/cifs/connect.c: RFC1002 header 0x23
[ 6859.860602] fs/cifs/transport.c: cifs_sync_mid_result: cmd=113 mid=13 state=4
[ 6859.860605] fs/cifs/fscache.c: cifs_fscache_release_super_cookie:
(0xffff880201f1d000)
[ 6859.860609] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[ 6859.860612] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as
Xid: 13 with uid: 0
[ 6859.860613] fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
[ 6859.860616] fs/cifs/transport.c: For smb_command 116
[ 6859.860618] fs/cifs/transport.c: Sending smb: smb_len=39
[ 6859.860834] fs/cifs/connect.c: RFC1002 header 0x27
[ 6859.860844] fs/cifs/transport.c: cifs_sync_mid_result: cmd=116 mid=14 state=4
[ 6859.860851] fs/cifs/fscache.c: cifs_fscache_release_client_cookie:
(0xffff880201d54000/0xffff8802115710a0)


Regards
Johann

--
     "But God commendeth his love toward us, in that, while
      we were yet sinners, Christ died for us."
                                   Romans 5:8
