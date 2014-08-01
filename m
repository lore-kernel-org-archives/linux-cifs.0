From: "Bob Balsover" <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Subject: RE: Mount fileshare with prefixpath [mount error(2): No such file or directory]
Date: Fri, 1 Aug 2014 10:00:09 -0700
Message-ID: <004e01cfadaa$0d82b870$28882950$@balsover.com>
References: <53DB5310.5060701@gva.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "=?UTF-8?Q?'Javier_Mart=C3=AD_Monforte'?=" <marti_javmon-S9K+yDyl5s4@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53DB5310.5060701-S9K+yDyl5s4@public.gmane.org>
Content-Language: en-us
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Javier,

It is not the cause of your problem but if you are connecting to a MS s=
erver add nounix and noserverino to the command line to remove some of =
the messages from your log, I believe Unix type extensions are not appl=
icable to MS servers and I found that I cannot mount an Apple SMB/X sha=
re without them on the command line.

I am working with an older kernel so my suggestions might be a little o=
ut of date.  I see your code returning from cifs_mount multiple times w=
ith rc=3D0 which would indicate a successful mount.  I only see your co=
mmand line parameters once with multiple calls to cifs_mount so is this=
 a DFS share? If this is a DFS share did you compile in DFS support? A =
problem that I have seen is that while the username/password used on th=
e server that holds the namespace might be valid, the server that you a=
re referred to may not recognize that user and it causes problems. If t=
his is DFS then try mounting all of the servers that it might be referr=
ed to directly and see if you are successful. I have also seen a proble=
m where the MS server that holds the namespace supports one type of sec=
=3D setting, the server that it refers you to supports a different sett=
ing and the mount will fail. ie. In my case it was a MS server using se=
c=3Dntlmsspi, referred server which is an old NAS running Linux using s=
ec=3Dntlm (the default).  The setting on the namespace server and the r=
eferred server must match when using mount.cifs.

In the case of a normal share it might also be the case that the user d=
oes not have adequate permissions for both the directory and the sub di=
rectory, if the user can't read the parent directory then they probably=
 can't see the subdirectory but that is just a guess.

-Bob

-----Original Message-----
=46rom: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-owner@vger.=
kernel.org] On Behalf Of Javier Mart=C3=AD Monforte
Sent: Friday, August 01, 2014 1:43 AM
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Mount fileshare with prefixpath [mount error(2): No such file =
or directory]

Hello list,

I have a problem with mounting a cifs share with prefix path, I run ubu=
ntu 12.04 Precise Pangolin and I have updated mount.cifs package to cif=
s-utils Version: 2:6.0-1ubuntu2

The command:
# sudo mount -t cifs \\\\machine.server.es\\datos\\13908
/home/myuser/mountpoint -o "username=3Dmyuser,uid=3D489689328,gid=3D489=
685505"=20
--verbose

mount.cifs kernel mount options:=20
ip=3D172.27.194.152,unc=3D\\machine.server.es\datos,uid=3D489689328,gid=
=3D489685505,user=3Dd24399776l,prefixpath=3D13908,pass=3D********
mount error(2): No such file or directory Refer to the mount.cifs(8) ma=
nual page (e.g. man mount.cifs)


The results:

# uname -r
3.2.0-67-generic

# mount.cifs -V
mount.cifs version: 6.0

And a dmesg with debugging activated:

[72758.230822] /build/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Devname:=20
\\machine.server.es\datos\13908 flags: 0 [72758.230835] /build/buildd/l=
inux-3.2.0/fs/cifs/connect.c: prefix path
/13908
[72758.230839] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:=20
d24399776l
[72758.230845] /build/buildd/linux-3.2.0/fs/cifs/connect.c: file mode:=20
0x1ed  dir mode: 0x1ed
[72758.230918] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: i=
n cifs_mount as Xid: 2668 with uid: 0 [72758.230922] /build/buildd/linu=
x-3.2.0/fs/cifs/connect.c: UNC:=20
\\machine.server.es\datos ip: 172.27.194.152 [72758.230928] /build/buil=
dd/linux-3.2.0/fs/cifs/connect.c: Existing tcp session with server foun=
d [72758.230932] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=
 in cifs_get_smb_ses as Xid: 2669 with uid: 0 [72758.230936] /build/bui=
ldd/linux-3.2.0/fs/cifs/connect.c: Existing smb sess found (status=3D1)=
 [72758.230940] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_smb_ses (xid =3D 2669) rc =3D 0 [72758.230944] /build/=
buildd/linux-3.2.0/fs/cifs/connect.c: Found match on UNC path [72758.23=
0947] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_smb_ses: ses_count=3D2
[72758.230949]
[72758.230951] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSDevic=
eInfo [72758.230958] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=
 smb_command 50 [72758.230962] /build/buildd/linux-3.2.0/fs/cifs/transp=
ort.c: Sending
smb:  total_len 72
[72758.231651] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x4a [72758.231682] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D137 state=3D4 [72758.231688] /buil=
d/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSAttributeInfo [72758.2316=
92] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50 [=
72758.231696] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
smb:  total_len 72
[72758.232463] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x4c [72758.232485] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D138 state=3D4 [72758.232492] /buil=
d/buildd/linux-3.2.0/fs/cifs/connect.c:=20
build_unc_path_to_root: full_path=3D\\machine.server.es\datos\13908
[72758.232520] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In GetDFSRe=
fer the path \machine.server.es\datos [72758.232527] /build/buildd/linu=
x-3.2.0/fs/cifs/transport.c: For smb_command 50 [72758.232530] /build/b=
uildd/linux-3.2.0/fs/cifs/transport.c: Sending
smb:  total_len 148
[72758.233686] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x140 [72758.233709] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=
=20
cifs_sync_mid_result: cmd=3D50 mid=3D139 state=3D4 [72758.233714] /buil=
d/buildd/linux-3.2.0/fs/cifs/cifssmb.c: Decoding GetDFSRefer response B=
CC: 265  Offset 56 [72758.233718] /build/buildd/linux-3.2.0/fs/cifs/cif=
ssmb.c:=20
num_referrals: 1 dfs flags: 0x3 ...
[72758.233720]
[72758.233736] /build/buildd/linux-3.2.0/fs/cifs/dns_resolve.c:=20
dns_resolve_server_name_to_ip: resolved: machine.server.es to 172.27.19=
4.152 [72758.233752] /build/buildd/linux-3.2.0/fs/cifs/connect.c: prefi=
x path
/\13908
[72758.233755] /build/buildd/linux-3.2.0/fs/cifs/connect.c: Username:=20
d24399776l
[72758.233758] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_tcon: tc_count=3D2
[72758.233760]
[72758.233763] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_mount (xid =3D 2668) rc =3D 0
[72758.233767] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS: i=
n cifs_mount as Xid: 2670 with uid: 0 [72758.233770] /build/buildd/linu=
x-3.2.0/fs/cifs/connect.c: UNC:=20
\\machine.server.es\datos ip: 172.27.194.152 [72758.233774] /build/buil=
dd/linux-3.2.0/fs/cifs/connect.c: Existing tcp session with server foun=
d [72758.233778] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=
 in cifs_get_smb_ses as Xid: 2671 with uid: 0 [72758.233782] /build/bui=
ldd/linux-3.2.0/fs/cifs/connect.c: Existing smb sess found (status=3D1)=
 [72758.233785] /build/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_get_smb_ses (xid =3D 2671) rc =3D 0 [72758.233789] /build/=
buildd/linux-3.2.0/fs/cifs/connect.c: Found match on UNC path [72758.23=
3791] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_smb_ses: ses_count=3D2
[72758.233793]
[72758.233795] /build/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSDevic=
eInfo [72758.233799] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For=
 smb_command 50 [72758.233802] /build/buildd/linux-3.2.0/fs/cifs/transp=
ort.c: Sending
smb:  total_len 72
[72758.234429] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x4a [72758.234443] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D140 state=3D4 [72758.234448] /buil=
d/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In QFSAttributeInfo [72758.2344=
52] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50 [=
72758.234455] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
smb:  total_len 72
[72758.235508] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x4c [72758.235521] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D141 state=3D4 [72758.235528] /buil=
d/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50 [72758.235=
532] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
smb:  total_len 166
[72758.236337] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0xde [72758.236358] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D142 state=3D4 [72758.236366] /buil=
d/buildd/linux-3.2.0/fs/cifs/connect.c: CIFS VFS:=20
leaving cifs_mount (xid =3D 2670) rc =3D 0
[72758.236382] /build/buildd/linux-3.2.0/fs/cifs/inode.c: CIFS VFS: in =
cifs_root_iget as Xid: 2672 with uid: 0 [72758.236385] /build/buildd/li=
nux-3.2.0/fs/cifs/inode.c: Getting info on [72758.236389] /build/buildd=
/linux-3.2.0/fs/cifs/transport.c: For smb_command 50 [72758.236392] /bu=
ild/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
smb:  total_len 78
[72758.237078] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x86 [72758.237092] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D143 state=3D4 [72758.237098] /buil=
d/buildd/linux-3.2.0/fs/cifs/cifssmb.c: In GetSrvInodeNum for [72758.23=
7102] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_command 50=
 [72758.237105] /build/buildd/linux-3.2.0/fs/cifs/transport.c: Sending
smb:  total_len 78
[72758.237773] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x23 [72758.237778] /build/buildd/linux-3.2.0/fs/cifs/connect.c: in=
valid
transact2 word count
[72758.237789] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D144 state=3D4 [72758.237792] Statu=
s code returned 0xc0000001 NT_STATUS_UNSUCCESSFUL [72758.237798] /build=
/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping smb error code 0xc000000=
1 to POSIX err -5 [72758.237802] /build/buildd/linux-3.2.0/fs/cifs/cifs=
smb.c: error -5 in QueryInternalInfo [72758.237805] /build/buildd/linux=
-3.2.0/fs/cifs/inode.c: GetSrvInodeNum rc -5 [72758.237809] CIFS VFS: A=
utodisabling the use of server inode numbers on \\machine.server.es\dat=
os. This server doesn't seem to support them properly. Hardlinks will n=
ot be recognized on this mount. Consider mounting with the "noserverino=
" option to silence this message.
[72758.237815] /build/buildd/linux-3.2.0/fs/cifs/inode.c: looking for
uniqueid=3D7310
[72758.237821] /build/buildd/linux-3.2.0/fs/cifs/inode.c:=20
cifs_revalidate_cache: revalidating inode 7310 [72758.237824] /build/bu=
ildd/linux-3.2.0/fs/cifs/inode.c:=20
cifs_revalidate_cache: inode 7310 is new [72758.237828] /build/buildd/l=
inux-3.2.0/fs/cifs/inode.c: inode
0xffff880072b4ad10 old_time=3D0 new_time=3D4313081855 [72758.237834] /b=
uild/buildd/linux-3.2.0/fs/cifs/cifsfs.c: Get root dentry for \\machine=
=2Eserver.es\datos\\13908 [72758.237840] /build/buildd/linux-3.2.0/fs/c=
ifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 2673 with uid: 0 [72758.237=
844] /build/buildd/linux-3.2.0/fs/cifs/dir.c: parent inode =3D
0xffff880072b4ad10 name is: machine.server.es and dentry =3D
0xffff8800a3f59900
[72758.237849] /build/buildd/linux-3.2.0/fs/cifs/dir.c: NULL inode in l=
ookup [72758.237853] /build/buildd/linux-3.2.0/fs/cifs/dir.c: Full path=
:=20
\\machine.server.es\datos\machine.server.es inode =3D 0x (null) [72758.=
237857] /build/buildd/linux-3.2.0/fs/cifs/inode.c: Getting info on \\ma=
chine.server.es\datos\machine.server.es
[72758.237863] /build/buildd/linux-3.2.0/fs/cifs/transport.c: For smb_c=
ommand 50 [72758.237866] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=
 Sending
smb:  total_len 212
[72758.238723] /build/buildd/linux-3.2.0/fs/cifs/connect.c: RFC1002 hea=
der 0x23 [72758.238728] /build/buildd/linux-3.2.0/fs/cifs/connect.c: in=
valid
transact2 word count
[72758.238738] /build/buildd/linux-3.2.0/fs/cifs/transport.c:=20
cifs_sync_mid_result: cmd=3D50 mid=3D145 state=3D4 [72758.238742] Statu=
s code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT_FOUND [72758.23874=
7] /build/buildd/linux-3.2.0/fs/cifs/netmisc.c: Mapping smb error code =
0xc0000034 to POSIX err -2 [72758.238751] /build/buildd/linux-3.2.0/fs/=
cifs/cifssmb.c: Send error in QPathInfo =3D -2 [72758.238755] /build/bu=
ildd/linux-3.2.0/fs/cifs/dir.c: CIFS VFS:=20
leaving cifs_lookup (xid =3D 2673) rc =3D 0
[72758.238844] /build/buildd/linux-3.2.0/fs/cifs/connect.c:=20
cifs_put_tcon: tc_count=3D2
[72758.238846]

Anyone can help?

Thank you
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" i=
n the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo inf=
o at  http://vger.kernel.org/majordomo-info.html
