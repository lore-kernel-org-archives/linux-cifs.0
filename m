From: Alexander Burker <burker-CQO3GkJhTFA@public.gmane.org>
Subject: Unable to create files or directories with the correct uid and gid
 using UNIX extensions and setuids
Date: Thu, 27 Nov 2014 03:46:49 +0100
Message-ID: <82dd521a9916d91441bc11509a37462d@ucs.at>
Reply-To: <burker-CQO3GkJhTFA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I hope this is the right place to post this, but after two days of=20
trying to solve the problem with the internet I feel I have to go to th=
e=20
source of the code. I hope I am right here.

Long story short, I am running a Samba server with enabled UNIX=20
extensions on a Debian OS.

$ uname -a
Linux ... 3.16-3-amd64 #1 SMP Debian 3.16.5-1 (2014-10-10) x86_64=20
GNU/Linux

$ samba-tool -V
4.1.13-Debian

I am mounting the share (though the first attempt ALWAYS fails!) on the=
=20
command line.

# mount -v -t cifs -o noauto,rw,setuids,soft,posixpaths=20
//host.domain.com/data /media/host.data
Password for root@//host.domain.com/data:  **********
mount.cifs kernel mount options:=20
ip=3D127.0.1.1,unc=3D\\host.domain.com\data,setuids,soft,posixpaths,use=
r=3Droot,pass=3D********
mount error(5): Input/output error
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
$ mount -v -t cifs -o noauto,rw,setuids,soft,posixpaths=20
//host.domain.com/data /media/host.data
Password for root@//host.domain.com/data:  **********
mount.cifs kernel mount options:=20
ip=3D127.0.1.1,unc=3D\\host.domain.com\data,setuids,soft,posixpaths,use=
r=3Droot,pass=3D********
$

When I work as root (the user that has mounted the share) everything=20
works fine.
If I try to create a file or directory, in a folder of the mounted=20
share,the file or directory is created but with the user root and group=
=20
root instead of the correct user.
$ mkdir testdir
$ touch testfile
touch: cannot touch =E2=80=98testfile=E2=80=99: Permission denied
$ echo adsfdsaf >testfile2
-bash: testfile2: Permission denied
$ ll
total 0
drwxr-xr-x 2 root root 0 Nov 27 01:27 testdir
-rw-r--r-- 1 root root 0 Nov 27 01:27 testfile
-rw-r--r-- 1 root root 0 Nov 27 01:28 testfile2
$

As you can see the files and directories are created but the owner is=20
root instead of alex.
I have the following options enabled in /etc/samba/smb.conf.

    unix extensions =3D yes
    case sensitive =3D yes
    delete readonly =3D yes
    ea support =3D yes

It looks like if the UNIX extensions are enabled and working.
$ cat LinuxExtensionsEnabled
1
$

I also mounted the share with the setuids option which should fix exact=
=20
this behaviour. The uid and gid of the user alex are the same on the=20
client and on the samba server host. Even mounting the share on the=20
samba server host produces the exact same result. Client 1 runs Ubuntu=20
14.10 and, client 2 is on the Debian server see above, same result on=20
both!

So I guess it has something to do with the user handling, because it=20
looks like the server is falling back to the mounting user as described=
=20
in the man page to mount.cifs section setuids. But even tracing the=20
communication with

$ echo 7 > /proc/fs/cifs/cifsFYI
$ echo 1 > /proc/fs/cifs/traceSMB

Nov 27 00:46:16 belegaer kernel: [1863123.954794]=20
/build/buildd/linux-3.16.0/fs/cifs/dir.c: CIFS VFS: in cifs_atomic_open=
=20
as Xid: 94685 with uid: 1000
Nov 27 00:46:16 belegaer kernel: [1863123.954799]=20
/build/buildd/linux-3.16.0/fs/cifs/dir.c: parent inode =3D=20
0xffff88036206bb68 name is: test6.txt and dentry =3D 0xffff8804250599c0
Nov 27 00:46:16 belegaer kernel: [1863123.954804]=20
/build/buildd/linux-3.16.0/fs/cifs/dir.c: name: /test6.txt
Nov 27 00:46:16 belegaer kernel: [1863123.954806]=20
/build/buildd/linux-3.16.0/fs/cifs/dir.c: name: /alex/test6.txt
Nov 27 00:46:16 belegaer kernel: [1863123.954807]=20
/build/buildd/linux-3.16.0/fs/cifs/dir.c: name: /wrk/alex/test6.txt
Nov 27 00:46:16 belegaer kernel: [1863123.954809]=20
/build/buildd/linux-3.16.0/fs/cifs/file.c: posix open=20
/wrk/alex/test6.txt
Nov 27 00:46:16 belegaer kernel: [1863123.954812]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: In POSIX Create
Nov 27 00:46:16 belegaer kernel: [1863123.954818]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: For smb_command 50
Nov 27 00:46:16 belegaer kernel: [1863123.954821]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: Sending smb: smb_len=3D=
132
Nov 27 00:46:16 belegaer kernel: [1863123.957867]=20
/build/buildd/linux-3.16.0/fs/cifs/connect.c: RFC1002 header 0xac
Nov 27 00:46:16 belegaer kernel: [1863123.957876]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: checkSMB Length: 0xb0,=20
smb_buf_length: 0xac
Nov 27 00:46:16 belegaer kernel: [1863123.957903]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: cifs_sync_mid_result:=20
cmd=3D50 mid=3D20690 state=3D4
Nov 27 00:46:16 belegaer kernel: [1863123.957908]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: copying inode info
Nov 27 00:46:16 belegaer kernel: [1863123.957912]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: looking for=20
uniqueid=3D313393291
Nov 27 00:46:16 belegaer kernel: [1863123.957920]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: cifs_revalidate_cache:=20
revalidating inode 313393291
Nov 27 00:46:16 belegaer kernel: [1863123.957922]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: cifs_revalidate_cache: inod=
e=20
313393291 is new
Nov 27 00:46:16 belegaer kernel: [1863123.957931]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: Exclusive Oplock granted on=20
inode ffff880376e1b298
Nov 27 00:46:16 belegaer kernel: [1863123.957933]=20
/build/buildd/linux-3.16.0/fs/cifs/dir.c: CIFS VFS: leaving=20
cifs_atomic_open (xid =3D 94685) rc =3D 0
Nov 27 00:46:16 belegaer kernel: [1863123.957941]=20
/build/buildd/linux-3.16.0/fs/cifs/file.c: closing last open instance=20
for inode ffff880376e1b298
Nov 27 00:46:16 belegaer kernel: [1863123.957943]=20
/build/buildd/linux-3.16.0/fs/cifs/file.c: CIFS VFS: in cifsFileInfo_pu=
t=20
as Xid: 94686 with uid: 1000
Nov 27 00:46:16 belegaer kernel: [1863123.957944]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: In CIFSSMBClose
Nov 27 00:46:16 belegaer kernel: [1863123.957947]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: For smb_command 4
Nov 27 00:46:16 belegaer kernel: [1863123.957949]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: Sending smb: smb_len=3D=
41
Nov 27 00:46:16 belegaer kernel: [1863123.960868]=20
/build/buildd/linux-3.16.0/fs/cifs/connect.c: RFC1002 header 0x23
Nov 27 00:46:16 belegaer kernel: [1863123.960882]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: checkSMB Length: 0x27,=20
smb_buf_length: 0x23
Nov 27 00:46:16 belegaer kernel: [1863123.960925]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: cifs_sync_mid_result:=20
cmd=3D4 mid=3D20691 state=3D4
Nov 27 00:46:17 belegaer kernel: [1863124.515447]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: CIFS VFS: in=20
cifs_revalidate_dentry_attr as Xid: 94687 with uid: 0
Nov 27 00:46:17 belegaer kernel: [1863124.515469]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: Update attributes:  inode=20
0xffff880376e1bb68 count 2 dentry: 0xffff880371e0b0c0 d_time=20
-114445832977592 jiffies 4760368120
Nov 27 00:46:17 belegaer kernel: [1863124.515473]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: Getting info on
Nov 27 00:46:17 belegaer kernel: [1863124.515475]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: In QPathInfo (Unix) the=20
path
Nov 27 00:46:17 belegaer kernel: [1863124.515484]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: For smb_command 50
Nov 27 00:46:17 belegaer kernel: [1863124.515487]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: Sending smb: smb_len=3D=
74
Nov 27 00:46:17 belegaer kernel: [1863124.518580]=20
/build/buildd/linux-3.16.0/fs/cifs/connect.c: RFC1002 header 0xa0
Nov 27 00:46:17 belegaer kernel: [1863124.518595]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: checkSMB Length: 0xa4,=20
smb_buf_length: 0xa0
Nov 27 00:46:17 belegaer kernel: [1863124.518650]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: cifs_sync_mid_result:=20
cmd=3D50 mid=3D20692 state=3D4
Nov 27 00:46:17 belegaer kernel: [1863124.518661]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: cifs_revalidate_cache:=20
revalidating inode 313393153
Nov 27 00:46:17 belegaer kernel: [1863124.518664]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: cifs_revalidate_cache: inod=
e=20
313393153 is unchanged
Nov 27 00:46:17 belegaer kernel: [1863124.518668]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: CIFS VFS: leaving=20
cifs_revalidate_dentry_attr (xid =3D 94687) rc =3D 0
Nov 27 00:46:17 belegaer kernel: [1863124.520312]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: CIFS VFS: in=20
cifs_revalidate_dentry_attr as Xid: 94688 with uid: 0
Nov 27 00:46:17 belegaer kernel: [1863124.520323]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: Update attributes:  inode=20
0xffff8800079fc0a8 count 2 dentry: 0xffff880376500780 d_time=20
-72039585256828832 jiffies 4760368121
Nov 27 00:46:17 belegaer kernel: [1863124.520326]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: Getting info on
Nov 27 00:46:17 belegaer kernel: [1863124.520329]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: In QPathInfo (Unix) the=20
path
Nov 27 00:46:17 belegaer kernel: [1863124.520338]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: For smb_command 50
Nov 27 00:46:17 belegaer kernel: [1863124.520341]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: Sending smb: smb_len=3D=
74
Nov 27 00:46:17 belegaer kernel: [1863124.520911]=20
/build/buildd/linux-3.16.0/fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs a=
s=20
Xid: 94689 with uid: 0
Nov 27 00:46:17 belegaer kernel: [1863124.520917]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: In QFSPosixInfo
Nov 27 00:46:17 belegaer kernel: [1863124.520923]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: For smb_command 50
Nov 27 00:46:17 belegaer kernel: [1863124.520926]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: Sending smb: smb_len=3D=
68
Nov 27 00:46:17 belegaer kernel: [1863124.521725]=20
/build/buildd/linux-3.16.0/fs/cifs/connect.c: RFC1002 header 0xa0
Nov 27 00:46:17 belegaer kernel: [1863124.521735]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: checkSMB Length: 0xa4,=20
smb_buf_length: 0xa0
Nov 27 00:46:17 belegaer kernel: [1863124.521752]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: cifs_sync_mid_result:=20
cmd=3D50 mid=3D20693 state=3D4
Nov 27 00:46:17 belegaer kernel: [1863124.521762]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: cifs_revalidate_cache:=20
revalidating inode 28068
Nov 27 00:46:17 belegaer kernel: [1863124.521766]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: cifs_revalidate_cache: inod=
e=20
28068 is unchanged
Nov 27 00:46:17 belegaer kernel: [1863124.521770]=20
/build/buildd/linux-3.16.0/fs/cifs/inode.c: CIFS VFS: leaving=20
cifs_revalidate_dentry_attr (xid =3D 94688) rc =3D 0
Nov 27 00:46:17 belegaer kernel: [1863124.524813]=20
/build/buildd/linux-3.16.0/fs/cifs/connect.c: RFC1002 header 0x70
Nov 27 00:46:17 belegaer kernel: [1863124.524827]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: checkSMB Length: 0x74,=20
smb_buf_length: 0x70
Nov 27 00:46:17 belegaer kernel: [1863124.524881]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: cifs_sync_mid_result:=20
cmd=3D50 mid=3D20694 state=3D4
Nov 27 00:46:17 belegaer kernel: [1863124.524891]=20
/build/buildd/linux-3.16.0/fs/cifs/cifsfs.c: CIFS VFS: leaving=20
cifs_statfs (xid =3D 94689) rc =3D 0
Nov 27 00:46:17 belegaer kernel: [1863124.526191]=20
/build/buildd/linux-3.16.0/fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs a=
s=20
Xid: 94690 with uid: 0
Nov 27 00:46:17 belegaer kernel: [1863124.526194]=20
/build/buildd/linux-3.16.0/fs/cifs/cifssmb.c: In QFSPosixInfo
Nov 27 00:46:17 belegaer kernel: [1863124.526199]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: For smb_command 50
Nov 27 00:46:17 belegaer kernel: [1863124.526201]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: Sending smb: smb_len=3D=
68
Nov 27 00:46:17 belegaer kernel: [1863124.529270]=20
/build/buildd/linux-3.16.0/fs/cifs/connect.c: RFC1002 header 0x70
Nov 27 00:46:17 belegaer kernel: [1863124.529281]=20
/build/buildd/linux-3.16.0/fs/cifs/misc.c: checkSMB Length: 0x74,=20
smb_buf_length: 0x70
Nov 27 00:46:17 belegaer kernel: [1863124.529329]=20
/build/buildd/linux-3.16.0/fs/cifs/transport.c: cifs_sync_mid_result:=20
cmd=3D50 mid=3D20695 state=3D4
Nov 27 00:46:17 belegaer kernel: [1863124.529339]=20
/build/buildd/linux-3.16.0/fs/cifs/cifsfs.c: CIFS VFS: leaving=20
cifs_statfs (xid =3D 94690) rc =3D 0

I am not able to find the problem. So please ANY help would be really=20
appreciated!

ps fixing the error (5) on first mount would be great too!

thanks in advance,
with best regards,
alex burker
