From: =?UTF-8?B?SmF2aWVyIE1hcnTDrSBNb25mb3J0ZQ==?= <marti_javmon-S9K+yDyl5s4@public.gmane.org>
Subject: Re: Mount fileshare with prefixpath [mount error(2): No such file
 or directory]
Date: Mon, 04 Aug 2014 11:32:14 +0200
Message-ID: <53DF531E.7020200@gva.es>
References: <53DB5310.5060701@gva.es> <004e01cfadaa$0d82b870$28882950$@balsover.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004e01cfadaa$0d82b870$28882950$@balsover.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi and thank you to answer,

in effect is a DFS in a MS Server, and the log I have attached is for a=
=20
machine, If I try to mount directly to the DFS sometimes does not work=20
and it has paused with the message:

# sudo mount -t cifs \\\\domain.local\\data\\13908 mountPoint -o=20
"username=3DmyUser,uid=3D489689328,gid=3D489685505,nounix,noserverino" =
--verbose
Password for myUser@\\domain.local\data\13908:
mount.cifs kernel mount options:=20
ip=3D172.27.194.67,unc=3D\\domain.local\data,nounix,noserverino,uid=3D4=
89689328,gid=3D489685505,user=3DmyUser,prefixpath=3D13908,pass=3D******=
**
mount error(115): Operation now in progress
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

and sometimes it says:


# sudo mount -t cifs \\\\domain.local\\data\\13908 mountPoint -o=20
"username=3DmyUser,uid=3D489689328,gid=3D489685505,nounix,noserverino" =
--verbose
Password for myUser@\\domain.local\data\13908:
mount.cifs kernel mount options:=20
ip=3D172.27.194.132,unc=3D\\domain.local\data,nounix,noserverino,uid=3D=
489689328,gid=3D489685505,user=3DmyUser,prefixpath=3D13908,pass=3D*****=
***
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

with the log


[244388.448854] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Devname:=20
\\domain.local\data\13908 flags: 0
[244388.448871] /build/buildd/linux-3.2.0/fs/cifs/connect.c: prefix pat=
h=20
/13908
[244388.448875] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:=20
myUser
[244388.448881] /build/buildd/linux-3.2.0/fs/cifs/connect.c: file mode:=
=20
0x1ed  dir mode: 0x1ed
[244388.448954] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_mount as Xid: 2274 with uid: 0
[244388.448958] /build/buildd/linux-3.2.0/fs/cifs/connect.c: UNC:=20
\\domain.local\data ip: 172.27.194.132
[244388.448977] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Socket cre=
ated
[244388.448981] /build/buildd/linux-3.2.0/fs/cifs/connect.c: sndbuf=20
16384 rcvbuf 87380 rcvtimeo 0x6d6
[244388.450494] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_get_smb_ses as Xid: 2275 with uid: 0
[244388.450499] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Demultiple=
x=20
PID: 14419
[244388.450504] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing=20
smb sess not found
[244388.450512] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: secFlags 0=
x7
[244388.450517] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 114
[244388.450521] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 82
[244388.451274] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x79
[244388.451297] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D114 mid=3D1 state=3D4
[244388.451302] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Dialect: 2
[244388.451305] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: negprot rc=
 0
[244388.451309] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Security=20
Mode: 0xf Capabilities: 0x1f3fd TimeAdjust: -7200
[244388.451313] /build/buildd/linux-3.2.0/fs/cifs/sess.c: sess setup ty=
pe 1
[244388.451341] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 115
[244388.451344] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 252
[244388.453454] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0xcd
[244388.453477] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D115 mid=3D2 state=3D4
[244388.453482] /build/buildd/linux-3.2.0/fs/cifs/misc.c: Null buffer=20
passed to cifs_small_buf_release
[244388.453485] /build/buildd/linux-3.2.0/fs/cifs/sess.c: UID =3D 2048
[244388.453488] /build/buildd/linux-3.2.0/fs/cifs/sess.c: bleft 163
[244388.453494] /build/buildd/linux-3.2.0/fs/cifs/sess.c:=20
serverOS=3DWindows Server 2003 R2 3790 Service Pack 2
[244388.453498] /build/buildd/linux-3.2.0/fs/cifs/sess.c:=20
serverNOS=3DWindows Server 2003 R2 5.2
[244388.453502] /build/buildd/linux-3.2.0/fs/cifs/sess.c:=20
serverDomain=3DDOMAIN
[244388.453506] /build/buildd/linux-3.2.0/fs/cifs/sess.c: ssetup freein=
g=20
small buf ffff8800a538ca80
[244388.453509] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS=20
Session Established successfully
[244388.453513] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_smb_ses (xid =3D 2275) rc =3D 0
[244388.453518] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_get_tcon as Xid: 2276 with uid: 0
[244388.453523] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 117
[244388.453528] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 108
[244388.454392] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x23
[244388.454404] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D117 mid=3D3 state=3D4
[244388.454412] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVE=
RED
[244388.454417] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping sm=
b=20
error code 0xc0000257 to POSIX err -66
[244388.454421] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_tcon (xid =3D 2276) rc =3D -66
[244388.454425] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS Tcon=20
rc =3D -66
[244388.454429] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
build_unc_path_to_root: full_path=3D\\domain.local\data\13908
[244388.454435] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 117
[244388.454439] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 98
[244388.455251] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x38
[244388.455272] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D117 mid=3D4 state=3D4
[244388.455278] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS Tcon=20
rc =3D 0 ipc_tid =3D 38912
[244388.455281] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
GetDFSRefer the path \domain.local\data
[244388.455286] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.455290] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 126
[244388.456159] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x134
[244388.456170] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D5 state=3D4
[244388.456178] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Decoding=20
GetDFSRefer response BCC: 253  Offset 56
[244388.456183] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c:=20
num_referrals: 2 dfs flags: 0x3 ...
[244388.456185]
[244388.456202] /build/buildd/linux-3.2.0/fs/cifs/dns_resolve.c:=20
dns_resolve_server_name_to_ip: resolved: SIIS073522 to 172.27.194.65
[244388.456221] /build/buildd/linux-3.2.0/fs/cifs/connect.c: prefix pat=
h=20
/\13908
[244388.456225] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:=20
myUser
[244388.456230] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_smb_ses: ses_count=3D1
[244388.456232]
[244388.456235] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_put_smb_ses as Xid: 2277 with uid: 0
[244388.456240] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
SMBLogoff for session disconnect
[244388.456245] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 116
[244388.456249] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 43
[244388.457139] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x27
[244388.457160] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D116 mid=3D6 state=3D4
[244388.457176] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_mount (xid =3D 2274) rc =3D -66
[244388.457180] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_mount as Xid: 2278 with uid: 0
[244388.457184] /build/buildd/linux-3.2.0/fs/cifs/connect.c: UNC:=20
\\SIIS073522\data ip: 172.27.194.65
[244388.457195] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Socket cre=
ated
[244388.457199] /build/buildd/linux-3.2.0/fs/cifs/connect.c: sndbuf=20
16384 rcvbuf 87380 rcvtimeo 0x6d6
[244388.458594] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_get_smb_ses as Xid: 2279 with uid: 0
[244388.458598] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Demultiple=
x=20
PID: 14420
[244388.458602] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing=20
smb sess not found
[244388.458608] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: secFlags 0=
x7
[244388.458611] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 114
[244388.458614] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 82
[244388.459483] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x7b
[244388.459495] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D114 mid=3D1 state=3D4
[244388.459499] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Dialect: 2
[244388.459502] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: negprot rc=
 0
[244388.459506] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Security=20
Mode: 0xf Capabilities: 0x1f3fd TimeAdjust: -7200
[244388.459509] /build/buildd/linux-3.2.0/fs/cifs/sess.c: sess setup ty=
pe 1
[244388.459530] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 115
[244388.459533] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 252
[244388.462417] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0xcd
[244388.462451] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D115 mid=3D2 state=3D4
[244388.462455] /build/buildd/linux-3.2.0/fs/cifs/misc.c: Null buffer=20
passed to cifs_small_buf_release
[244388.462459] /build/buildd/linux-3.2.0/fs/cifs/sess.c: UID =3D 20482
[244388.462462] /build/buildd/linux-3.2.0/fs/cifs/sess.c: bleft 163
[244388.462468] /build/buildd/linux-3.2.0/fs/cifs/sess.c:=20
serverOS=3DWindows Server 2003 R2 3790 Service Pack 2
[244388.462473] /build/buildd/linux-3.2.0/fs/cifs/sess.c:=20
serverNOS=3DWindows Server 2003 R2 5.2
[244388.462477] /build/buildd/linux-3.2.0/fs/cifs/sess.c:=20
serverDomain=3DDOMAIN
[244388.462481] /build/buildd/linux-3.2.0/fs/cifs/sess.c: ssetup freein=
g=20
small buf ffff8800a64f9c00
[244388.462484] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS=20
Session Established successfully
[244388.462488] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_smb_ses (xid =3D 2279) rc =3D 0
[244388.462493] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_get_tcon as Xid: 2280 with uid: 0
[244388.462501] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 117
[244388.462507] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 92
[244388.463490] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x3e
[244388.463501] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D117 mid=3D3 state=3D4
[244388.463507] /build/buildd/linux-3.2.0/fs/cifs/connect.c: disk share=
=20
connection
[244388.463511] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
nativeFileSystem=3DNTFS
[244388.463514] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Tcon flags=
:=20
0x3
[244388.463517] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_tcon (xid =3D 2280) rc =3D 0
[244388.463520] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS Tcon=20
rc =3D 0
[244388.463524] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
QFSDeviceInfo
[244388.463528] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.463532] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 72
[244388.464887] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x40
[244388.464898] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D4 state=3D4
[244388.464905] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
QFSAttributeInfo
[244388.464909] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.464913] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 72
[244388.465616] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x4c
[244388.465626] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D5 state=3D4
[244388.465636] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.465640] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 128
[244388.466502] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x23
[244388.466507] /build/buildd/linux-3.2.0/fs/cifs/connect.c: invalid=20
transact2 word count
[244388.466514] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D6 state=3D4
[244388.466522] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVE=
RED
[244388.466526] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping sm=
b=20
error code 0xc0000257 to POSIX err -66
[244388.466530] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Send error=
=20
in QPathInfo =3D -66
[244388.466534] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
build_unc_path_to_root: full_path=3D\\SIIS073522\data\\13908
[244388.466539] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 117
[244388.466543] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 96
[244388.467249] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x38
[244388.467259] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D117 mid=3D7 state=3D4
[244388.467265] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS Tcon=20
rc =3D 0 ipc_tid =3D 12289
[244388.467269] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
GetDFSRefer the path \SIIS073522\data\\13908
[244388.467273] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.467277] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 124
[244388.468784] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x11c
[244388.468797] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D8 state=3D4
[244388.468805] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Decoding=20
GetDFSRefer response BCC: 229  Offset 56
[244388.468809] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c:=20
num_referrals: 1 dfs flags: 0x2 ...
[244388.468811]
[244388.468827] /build/buildd/linux-3.2.0/fs/cifs/dns_resolve.c:=20
dns_resolve_server_name_to_ip: resolved: machine1.domain.local to=20
172.27.194.152
[244388.468849] /build/buildd/linux-3.2.0/fs/cifs/connect.c: prefix pat=
h=20
/13908
[244388.468852] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:=20
myUser
[244388.468856] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_tcon: tc_count=3D1
[244388.468858]
[244388.468861] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_put_tcon as Xid: 2281 with uid: 0
[244388.468864] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In tree=20
disconnect
[244388.468868] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 113
[244388.468872] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 39
[244388.469694] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x23
[244388.469704] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D113 mid=3D9 state=3D4
[244388.469710] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_smb_ses: ses_count=3D1
[244388.469712]
[244388.469715] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_put_smb_ses as Xid: 2282 with uid: 0
[244388.469718] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
SMBLogoff for session disconnect
[244388.469722] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 116
[244388.469726] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 43
[244388.470707] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x27
[244388.470717] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D116 mid=3D10 state=3D4
[244388.470732] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_mount (xid =3D 2278) rc =3D 0
[244388.470736] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_mount as Xid: 2283 with uid: 0
[244388.470739] /build/buildd/linux-3.2.0/fs/cifs/connect.c: UNC:=20
\\domain.local\data ip: 172.27.194.152
[244388.470744] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing=20
tcp session with server found
[244388.470748] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
in cifs_get_smb_ses as Xid: 2284 with uid: 0
[244388.470752] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Existing=20
smb sess found (status=3D1)
[244388.470756] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_smb_ses (xid =3D 2284) rc =3D 0
[244388.470759] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Found matc=
h=20
on UNC path
[244388.470762] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_smb_ses: ses_count=3D2
[244388.470764]
[244388.470766] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
QFSDeviceInfo
[244388.470770] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.470774] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 72
[244388.471570] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x4a
[244388.471594] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D3684 state=3D4
[244388.471601] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In=20
QFSAttributeInfo
[244388.471605] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.471608] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 72
[244388.472495] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x4c
[244388.472510] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D3685 state=3D4
[244388.472519] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.472523] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 164
[244388.473273] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0xdc
[244388.473807] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D3686 state=3D4
[244388.473814] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_mount (xid =3D 2283) rc =3D 0
[244388.473822] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Use existin=
g=20
superblock
[244388.473828] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_tcon: tc_count=3D2
[244388.473830]
[244388.473929] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Get root=20
dentry for \\machine1.domain.local\data\13908
[244388.473939] /build/buildd/linux-3.2.0/fs/cifs/dir.c: CIFS VFS: in=20
cifs_lookup as Xid: 2285 with uid: 0
[244388.473944] /build/buildd/linux-3.2.0/fs/cifs/dir.c: parent inode =3D=
=20
0xffff88006c498070 name is: machine1.domain.local and dentry =3D=20
0xffff8800566ae000
[244388.473949] /build/buildd/linux-3.2.0/fs/cifs/dir.c: NULL inode in=20
lookup
[244388.473952] /build/buildd/linux-3.2.0/fs/cifs/dir.c: Full path:=20
\\machine1.domain.local\data\machine1.domain.local inode =3D 0x        =
 =20
(null)
[244388.473957] /build/buildd/linux-3.2.0/fs/cifs/inode.c: Getting info=
=20
on \\machine1.domain.local\data\machine1.domain.local
[244388.473964] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=20
smb_command 50
[244388.473967] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending=20
smb:  total_len 212
[244388.474865] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002=20
header 0x23
[244388.474872] /build/buildd/linux-3.2.0/fs/cifs/connect.c: invalid=20
transact2 word count
[244388.474884] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D3687 state=3D4
[244388.474888] Status code returned 0xc0000034=20
NT_STATUS_OBJECT_NAME_NOT_FOUND
[244388.474894] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping sm=
b=20
error code 0xc0000034 to POSIX err -2
[244388.474898] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Send error=
=20
in QPathInfo =3D -2
[244388.474903] /build/buildd/linux-3.2.0/fs/cifs/dir.c: CIFS VFS:=20
leaving cifs_lookup (xid =3D 2285) rc =3D 0



The folder \\domain.local\data exists with permissions for the user and=
=20
the folder \\domain.local\data\13908 also with permissions, in fact if =
I=20
use:

# sudo mount -t cifs \\\\domain.local\\data mountPoint -o=20
"username=3DmyUser,uid=3D489689328,gid=3D489685505,nounix,noserverino" =
--verbose

It works and I can navigate to mountpoint/13908 without problems.

-Javier Mart=C3=AD

El 01/08/14 a las #4, Bob Balsover escribi=C3=B3:
> Hello Javier,
>
> It is not the cause of your problem but if you are connecting to a MS=
 server add nounix and noserverino to the command line to remove some o=
f the messages from your log, I believe Unix type extensions are not ap=
plicable to MS servers and I found that I cannot mount an Apple SMB/X s=
hare without them on the command line.
>
> I am working with an older kernel so my suggestions might be a little=
 out of date.  I see your code returning from cifs_mount multiple times=
 with rc=3D0 which would indicate a successful mount.  I only see your =
command line parameters once with multiple calls to cifs_mount so is th=
is a DFS share? If this is a DFS share did you compile in DFS support? =
A problem that I have seen is that while the username/password used on =
the server that holds the namespace might be valid, the server that you=
 are referred to may not recognize that user and it causes problems. If=
 this is DFS then try mounting all of the servers that it might be refe=
rred to directly and see if you are successful. I have also seen a prob=
lem where the MS server that holds the namespace supports one type of s=
ec=3D setting, the server that it refers you to supports a different se=
tting and the mount will fail. ie. In my case it was a MS server using =
sec=3Dntlmsspi, referred server which is an old NAS running Linux using=
 sec=3Dntlm (the default).  The setting on the namespace server and the=
 referred server must match when using mount.cifs.
>
> In the case of a normal share it might also be the case that the user=
 does not have adequate permissions for both the directory and the sub =
directory, if the user can't read the parent directory then they probab=
ly can't see the subdirectory but that is just a guess.
>
> -Bob
>
> -----Original Message-----
> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-owner@vger.=
kernel.org] On Behalf Of Javier Mart=C3=AD Monforte
> Sent: Friday, August 01, 2014 1:43 AM
> To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Mount fileshare with prefixpath [mount error(2): No such fil=
e or directory]
>
> Hello list,
>
> I have a problem with mounting a cifs share with prefix path, I run u=
buntu 12.04 Precise Pangolin and I have updated mount.cifs package to c=
ifs-utils Version: 2:6.0-1ubuntu2
>
> The command:
> # sudo mount -t cifs \\\\machine.server.es\\datos\\13908
> /home/myuser/mountpoint -o "username=3Dmyuser,uid=3D489689328,gid=3D4=
89685505"
> --verbose
>
> mount.cifs kernel mount options:
> ip=3D172.27.194.152,unc=3D\\machine.server.es\datos,uid=3D489689328,g=
id=3D489685505,user=3Dd24399776l,prefixpath=3D13908,pass=3D********
> mount error(2): No such file or directory Refer to the mount.cifs(8) =
manual page (e.g. man mount.cifs)
>
>
> The results:
>
> # uname -r
> 3.2.0-67-generic
>
> # mount.cifs -V
> mount.cifs version: 6.0
>
> And a dmesg with debugging activated:
>
> [72758.230822] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Devname:
> \\machine.server.es\datos\13908 flags: 0 [72758.230835] /build/buildd=
/linux-3.2.0/fs/cifs/connect.c: prefix path
> /13908
> [72758.230839] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:
> d24399776l
> [72758.230845] /build/buildd/linux-3.2.0/fs/cifs/connect.c: file mode=
:
> 0x1ed  dir mode: 0x1ed
> [72758.230918] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=
 in cifs_mount as Xid: 2668 with uid: 0 [72758.230922] /build/buildd/li=
nux-3.2.0/fs/cifs/connect.c: UNC:
> \\machine.server.es\datos ip: 172.27.194.152 [72758.230928] /build/bu=
ildd/linux-3.2.0/fs/cifs/connect.c: Existing tcp session with server fo=
und [72758.230932] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VF=
S: in cifs_get_smb_ses as Xid: 2669 with uid: 0 [72758.230936] /build/b=
uildd/linux-3.2.0/fs/cifs/connect.c: Existing smb sess found (status=3D=
1) [72758.230940] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS=
:
> leaving cifs_get_smb_ses (xid =3D 2669) rc =3D 0 [72758.230944] /buil=
d/buildd/linux-3.2.0/fs/cifs/connect.c: Found match on UNC path [72758.=
230947] /build/buildd/linux-3.2.0/fs/cifs/connect.c:
> cifs_put_smb_ses: ses_count=3D2
> [72758.230949]
> [72758.230951] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSDev=
iceInfo [72758.230958] /build/buildd/linux-3.2.0/fs/cifs/transport.c: F=
or smb_command 50 [72758.230962] /build/buildd/linux-3.2.0/fs/cifs/tran=
sport.c: Sending
> smb:  total_len 72
> [72758.231651] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x4a [72758.231682] /build/buildd/linux-3.2.0/fs/cifs/transport.c=
:
> cifs_sync_mid_result: cmd=3D50 mid=3D137 state=3D4 [72758.231688] /bu=
ild/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSAttributeInfo [72758.23=
1692] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50=
 [72758.231696] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
> smb:  total_len 72
> [72758.232463] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x4c [72758.232485] /build/buildd/linux-3.2.0/fs/cifs/transport.c=
:
> cifs_sync_mid_result: cmd=3D50 mid=3D138 state=3D4 [72758.232492] /bu=
ild/buildd/linux-3.2.0/fs/cifs/connect.c:
> build_unc_path_to_root: full_path=3D\\machine.server.es\datos\13908
> [72758.232520] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In GetDFS=
Refer the path \machine.server.es\datos [72758.232527] /build/buildd/li=
nux-3.2.0/fs/cifs/transport.c: For smb_command 50 [72758.232530] /build=
/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
> smb:  total_len 148
> [72758.233686] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x140 [72758.233709] /build/buildd/linux-3.2.0/fs/cifs/transport.=
c:
> cifs_sync_mid_result: cmd=3D50 mid=3D139 state=3D4 [72758.233714] /bu=
ild/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Decoding GetDFSRefer response=
 BCC: 265  Offset 56 [72758.233718] /build/buildd/linux-3.2.0/fs/cifs/c=
ifssmb.c:
> num_referrals: 1 dfs flags: 0x3 ...
> [72758.233720]
> [72758.233736] /build/buildd/linux-3.2.0/fs/cifs/dns_resolve.c:
> dns_resolve_server_name_to_ip: resolved: machine.server.es to 172.27.=
194.152 [72758.233752] /build/buildd/linux-3.2.0/fs/cifs/connect.c: pre=
fix path
> /\13908
> [72758.233755] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:
> d24399776l
> [72758.233758] /build/buildd/linux-3.2.0/fs/cifs/connect.c:
> cifs_put_tcon: tc_count=3D2
> [72758.233760]
> [72758.233763] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:
> leaving cifs_mount (xid =3D 2668) rc =3D 0
> [72758.233767] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=
 in cifs_mount as Xid: 2670 with uid: 0 [72758.233770] /build/buildd/li=
nux-3.2.0/fs/cifs/connect.c: UNC:
> \\machine.server.es\datos ip: 172.27.194.152 [72758.233774] /build/bu=
ildd/linux-3.2.0/fs/cifs/connect.c: Existing tcp session with server fo=
und [72758.233778] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VF=
S: in cifs_get_smb_ses as Xid: 2671 with uid: 0 [72758.233782] /build/b=
uildd/linux-3.2.0/fs/cifs/connect.c: Existing smb sess found (status=3D=
1) [72758.233785] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS=
:
> leaving cifs_get_smb_ses (xid =3D 2671) rc =3D 0 [72758.233789] /buil=
d/buildd/linux-3.2.0/fs/cifs/connect.c: Found match on UNC path [72758.=
233791] /build/buildd/linux-3.2.0/fs/cifs/connect.c:
> cifs_put_smb_ses: ses_count=3D2
> [72758.233793]
> [72758.233795] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSDev=
iceInfo [72758.233799] /build/buildd/linux-3.2.0/fs/cifs/transport.c: F=
or smb_command 50 [72758.233802] /build/buildd/linux-3.2.0/fs/cifs/tran=
sport.c: Sending
> smb:  total_len 72
> [72758.234429] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x4a [72758.234443] /build/buildd/linux-3.2.0/fs/cifs/transport.c=
:
> cifs_sync_mid_result: cmd=3D50 mid=3D140 state=3D4 [72758.234448] /bu=
ild/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSAttributeInfo [72758.23=
4452] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50=
 [72758.234455] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
> smb:  total_len 72
> [72758.235508] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x4c [72758.235521] /build/buildd/linux-3.2.0/fs/cifs/transport.c=
:
> cifs_sync_mid_result: cmd=3D50 mid=3D141 state=3D4 [72758.235528] /bu=
ild/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50 [72758.2=
35532] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
> smb:  total_len 166
> [72758.236337] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0xde [72758.236358] /build/buildd/linux-3.2.0/fs/cifs/transport.c=
:
> cifs_sync_mid_result: cmd=3D50 mid=3D142 state=3D4 [72758.236366] /bu=
ild/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:
> leaving cifs_mount (xid =3D 2670) rc =3D 0
> [72758.236382] /build/buildd/linux-3.2.0/fs/cifs/inode.c: CIFS VFS: i=
n cifs_root_iget as Xid: 2672 with uid: 0 [72758.236385] /build/buildd/=
linux-3.2.0/fs/cifs/inode.c: Getting info on [72758.236389] /build/buil=
dd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50 [72758.236392] /=
build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
> smb:  total_len 78
> [72758.237078] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x86 [72758.237092] /build/buildd/linux-3.2.0/fs/cifs/transport.c=
:
> cifs_sync_mid_result: cmd=3D50 mid=3D143 state=3D4 [72758.237098] /bu=
ild/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In GetSrvInodeNum for [72758.=
237102] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command =
50 [72758.237105] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sendin=
g
> smb:  total_len 78
> [72758.237773] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x23 [72758.237778] /build/buildd/linux-3.2.0/fs/cifs/connect.c: =
invalid
> transact2 word count
> [72758.237789] /build/buildd/linux-3.2.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D50 mid=3D144 state=3D4 [72758.237792] Sta=
tus code returned 0xc0000001 NT_STATUS_UNSUCCESSFUL [72758.237798] /bui=
ld/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping smb error code 0xc0000=
001 to POSIX err -5 [72758.237802] /build/buildd/linux-3.2.0/fs/cifs/ci=
fssmb.c: error -5 in QueryInternalInfo [72758.237805] /build/buildd/lin=
ux-3.2.0/fs/cifs/inode.c: GetSrvInodeNum rc -5 [72758.237809] CIFS VFS:=
 Autodisabling the use of server inode numbers on \\machine.server.es\d=
atos. This server doesn't seem to support them properly. Hardlinks will=
 not be recognized on this mount. Consider mounting with the "noserveri=
no" option to silence this message.
> [72758.237815] /build/buildd/linux-3.2.0/fs/cifs/inode.c: looking for
> uniqueid=3D7310
> [72758.237821] /build/buildd/linux-3.2.0/fs/cifs/inode.c:
> cifs_revalidate_cache: revalidating inode 7310 [72758.237824] /build/=
buildd/linux-3.2.0/fs/cifs/inode.c:
> cifs_revalidate_cache: inode 7310 is new [72758.237828] /build/buildd=
/linux-3.2.0/fs/cifs/inode.c: inode
> 0xffff880072b4ad10 old_time=3D0 new_time=3D4313081855 [72758.237834] =
/build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Get root dentry for \\machi=
ne.server.es\datos\\13908 [72758.237840] /build/buildd/linux-3.2.0/fs/c=
ifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 2673 with uid: 0 [72758.237=
844] /build/buildd/linux-3.2.0/fs/cifs/dir.c: parent inode =3D
> 0xffff880072b4ad10 name is: machine.server.es and dentry =3D
> 0xffff8800a3f59900
> [72758.237849] /build/buildd/linux-3.2.0/fs/cifs/dir.c: NULL inode in=
 lookup [72758.237853] /build/buildd/linux-3.2.0/fs/cifs/dir.c: Full pa=
th:
> \\machine.server.es\datos\machine.server.es inode =3D 0x (null) [7275=
8.237857] /build/buildd/linux-3.2.0/fs/cifs/inode.c: Getting info on \\=
machine.server.es\datos\machine.server.es
> [72758.237863] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb=
_command 50 [72758.237866] /build/buildd/linux-3.2.0/fs/cifs/transport.=
c: Sending
> smb:  total_len 212
> [72758.238723] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 h=
eader 0x23 [72758.238728] /build/buildd/linux-3.2.0/fs/cifs/connect.c: =
invalid
> transact2 word count
> [72758.238738] /build/buildd/linux-3.2.0/fs/cifs/transport.c:
> cifs_sync_mid_result: cmd=3D50 mid=3D145 state=3D4 [72758.238742] Sta=
tus code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT_FOUND [72758.238=
747] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping smb error cod=
e 0xc0000034 to POSIX err -2 [72758.238751] /build/buildd/linux-3.2.0/f=
s/cifs/cifssmb.c: Send error in QPathInfo =3D -2 [72758.238755] /build/=
buildd/linux-3.2.0/fs/cifs/dir.c: CIFS VFS:
> leaving cifs_lookup (xid =3D 2673) rc =3D 0
> [72758.238844] /build/buildd/linux-3.2.0/fs/cifs/connect.c:
> cifs_put_tcon: tc_count=3D2
> [72758.238846]
>
> Anyone can help?
>
> Thank you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo i=
nfo at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
