From: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Subject: Problem mounting Windows Server 2012 R2 share with newer cifs version
Date: Tue, 6 Oct 2015 12:46:33 +0200
Message-ID: <5613A689.1040303@fu-berlin.de>
References: <CAH2r5mtH9W+3PWBZzSCPwuwN-uaVKwx2KuX8g2p=sW009CAyhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtH9W+3PWBZzSCPwuwN-uaVKwx2KuX8g2p=sW009CAyhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear all,
I have a problem mounting a Windows 2012 R2 share with any newer version
of cifs.
I discovered that it works with version 1.61 (Ubuntu 10.04) but does not
on 2.02, 2.06 and 2.07.
The error I get is "Permission denied".

This is the content of /proc/fs/cifs/DebugData on the old machine where
mounting works:

Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.61
Active VFS Requests: 2
Servers:
[...]
3) Name: 10.32.39.171  Domain: CHARITE Uses: 1 OS: Windows Server 2012
R2 Standard 9600
    NOS: Windows Server 2012 R2 Standard 6.3    Capability: 0x1e3fc
    SMB session status: 1    TCP status: 1
    Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
    Shares:
    1) \\server\share$ Mounts: 1 Type: NTFS DevInfo: 0x60020 Attributes:
0xc700ff
PathComponentMax: 255 Status: 0x1 type: DISK

    MIDs:

On the machine where it doesn't work:
$ mount.cifs -V
mount.cifs version: 6.0
$ uname -r
4.3.0-040300rc4-generic

Below is a log I captured some time ago with an older kernel but the
symptoms are completely unchanged:

|[111049.530197] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifsfs.c:
Devname: //SERVERNAME\share$\SHARENAME flags: 0 [111049.530215]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Username:
USERNAME [111049.530218]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: file mode:
0x1ed dir mode: 0x1ed [111049.530262]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: CIFS VFS: in
cifs_mount as Xid: 2899 with uid: 0 [111049.530263]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: UNC:
\\SERVERNAME\share$ [111049.530270]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Socket created
[111049.530272] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6 [111049.534361]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/fscache.c:
cifs_fscache_get_client_cookie: (0xffff8800a3ab7000/0xffff88023182b9f8)
[111049.534365] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
CIFS VFS: in cifs_get_smb_ses as Xid: 2900 with uid: 0 [111049.534366]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Existing smb
sess not found [111049.534372]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: Requesting
extended security. [111049.534375]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 114 [111049.534376]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=78 [111049.534379]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Demultiplex
PID: 15832 [111049.535577]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0xcd [111049.535586]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0xd1, smb_buf_length: 0xcd [111049.535630]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=114 mid=1 state=4 [111049.535634]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: Dialect: 2
[111049.535637] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/asn1.c:
OID len = 10 oid = 0x1 0x3 0x6 0x1 [111049.535639]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/asn1.c: OID len = 7 oid =
0x1 0x2 0x348 0xbb92 [111049.535641]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/asn1.c: OID len = 7 oid =
0x1 0x2 0x348 0x1bb92 [111049.535642]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/asn1.c: OID len = 8 oid =
0x1 0x2 0x348 0x1bb92 [111049.535644]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/asn1.c: OID len = 10 oid =
0x1 0x3 0x6 0x1 [111049.535645]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: negprot rc 0
[111049.535647] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
Security Mode: 0x7 Capabilities: 0x8001e3fc TimeAdjust: -7200
[111049.535649] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c:
sess setup type 4 [111049.535654]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: ntlmssp session
setup phase 1 [111049.535656]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 115 [111049.535657]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=208 [111049.536864]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x18f [111049.536868]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x193, smb_buf_length: 0x18f [111049.536882]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=115 mid=2 state=4 [111049.536884] Status code
returned 0xc0000016 NT_STATUS_MORE_PROCESSING_REQUIRED [111049.536887]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/netmisc.c: Mapping smb
error code 0xc0000016 to POSIX err -5 [111049.536891]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: Null buffer passed
to cifs_small_buf_release [111049.536895]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: UID = 45059
[111049.536897] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c:
bleft 145 [111049.536900]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: serverOS=Windows
Server 2012 R2 Standard 9600 [111049.536903]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: serverNOS=Windows
Server 2012 R2 Standard 6.3 [111049.536906]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: ssetup freeing
small buf ffff8800b3bc4700 [111049.536908]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: ntlmssp session
setup phase 3 [111049.536933]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 115 [111049.536934]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=466 [111049.548253]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0xbd [111049.548258]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0xc1, smb_buf_length: 0xbd [111049.548317]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=115 mid=3 state=4 [111049.548320]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: Null buffer passed
to cifs_small_buf_release [111049.548321]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: UID = 45059
[111049.548323] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c:
bleft 145 [111049.548325]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: serverOS=Windows
Server 2012 R2 Standard 9600 [111049.548327]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: serverNOS=Windows
Server 2012 R2 Standard 6.3 [111049.548329]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: ssetup freeing
small buf ffff8800b2483800 [111049.548330]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/sess.c: CIFS session
established successfully [111049.548332]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: CIFS VFS:
leaving cifs_get_smb_ses (xid = 2900) rc = 0 [111049.548335]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: CIFS VFS: in
cifs_get_tcon as Xid: 2901 with uid: 0 [111049.548338]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 117 [111049.548339]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=84 [111049.549807]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x3e [111049.549811]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x42, smb_buf_length: 0x3e [111049.549871]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=117 mid=4 state=4 [111049.549875]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: disk share
connection [111049.549877]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
nativeFileSystem=NTFS [111049.549878]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Tcon flags: 0x1
[111049.549880] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
CIFS VFS: leaving cifs_get_tcon (xid = 2901) rc = 0 [111049.549881]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Tcon rc = 0
[111049.549883] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/fscache.c:
cifs_fscache_get_super_cookie: (0xffff88023182b9f8/0xffff8800b83b1688)
[111049.549885] /build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c:
In QFSDeviceInfo [111049.549887]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 50 [111049.549888]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=68 [111049.552343]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x40 [111049.552347]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x44, smb_buf_length: 0x40 [111049.552402]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=50 mid=5 state=4 [111049.552406]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: In
QFSAttributeInfo [111049.552408]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 50 [111049.552410]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=68 [111049.553408]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x4c [111049.553412]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x50, smb_buf_length: 0x4c [111049.553455]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=50 mid=6 state=4 [111049.553460]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
build_unc_path_to_root: full_path=\\SERVERNAME\share$\SHARENAME
[111049.553462]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 117 [111049.553464]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=90 [111049.554429]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x38 [111049.554434]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x3c, smb_buf_length: 0x38 [111049.554477]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=117 mid=7 state=4 [111049.554481]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: Tcon rc = 0
ipc_tid = 24579 [111049.554482]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: In GetDFSRefer
the path \SERVERNAME\share$ [111049.554485]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 50 [111049.554486]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=102 [111049.555224]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x23 [111049.555228]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x27, smb_buf_length: 0x23 [111049.555229]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/smb1ops.c: invalid
transact2 word count [111049.555271]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=50 mid=8 state=4 [111049.555275] Status code
returned 0xc000019c NT_STATUS_FS_DRIVER_REQUIRED [111049.555277]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/netmisc.c: Mapping smb
error code 0xc000019c to POSIX err -5 [111049.555279]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: Send error in
GetDFSRefer = -5 [111049.555283]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 50 [111049.555285]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=94 [111049.556415]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x98 [111049.556418]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x9c, smb_buf_length: 0x98 [111049.556442]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=50 mid=9 state=4 [111049.556446]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: CIFS VFS:
leaving cifs_mount (xid = 2899) rc = 0 [111049.556456]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/inode.c: CIFS VFS: in
cifs_root_iget as Xid: 2902 with uid: 0 [111049.556458]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/inode.c: Getting info on
[111049.556460]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 50 [111049.556462]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=74 [111049.559115]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x23 [111049.559120]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x27, smb_buf_length: 0x23 [111049.559121]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/smb1ops.c: invalid
transact2 word count [111049.559185]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=50 mid=10 state=4 [111049.559188] Status code
returned 0xc0000022 NT_STATUS_ACCESS_DENIED [111049.559193]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/netmisc.c: Mapping smb
error code 0xc0000022 to POSIX err -13 [111049.559195]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: Send error in
QPathInfo = -13 [111049.559197] CIFS VFS: cifs_read_super: get root
inode failed [111049.559201]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: cifs_put_tcon:
tc_count=1 [111049.559203]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: CIFS VFS: in
cifs_put_tcon as Xid: 2903 with uid: 0 [111049.559204]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: In tree
disconnect [111049.559206]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 113 [111049.559207]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=35 [111049.559923]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x23 [111049.559926]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x27, smb_buf_length: 0x23 [111049.559974]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=113 mid=11 state=4 [111049.559978]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/fscache.c:
cifs_fscache_release_super_cookie: (0xffff8800b83b1688) [111049.559981]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c:
cifs_put_smb_ses: ses_count=1 [111049.559983]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: CIFS VFS: in
cifs_put_smb_ses as Xid: 2904 with uid: 0 [111049.559984]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/cifssmb.c: In SMBLogoff
for session disconnect [111049.559986]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: For
smb_command 116 [111049.559987]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c: Sending smb:
smb_len=39 [111049.560839]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/connect.c: RFC1002 header
0x27 [111049.560843]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/misc.c: checkSMB Length:
0x2b, smb_buf_length: 0x27 [111049.560855]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=116 mid=12 state=4 [111049.560861]
/build/buildd/linux-lts-utopic-3.16.0/fs/cifs/fscache.c:
cifs_fscache_release_client_cookie: (0xffff8800a3ab7000/0xffff88023182b9f8)|
