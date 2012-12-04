From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: CIFS VFS: Unexpected SMB signature ...NULL inode in lookup
Date: Tue, 04 Dec 2012 14:23:16 +0100
Message-ID: <546150668.69990.1354627396422.JavaMail.www@wwinf8225>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I have a problem with users losing their connections from linux clients=
 with cifs share. (Windows 2008) :CIFS VFS: Unexpected SMB signature
I am using two methods for mounting: pam_mount and autofs, both with sa=
me results.

I am using mount options nounix,noserverino

I am lauching cifs module on boot (rc.local) with
modprobe cifs
echo 0 > /proc/fs/cifs/OplockEnabled
echo 1 > /proc/fs/cifs/MultiuserMount
echo 7 > /proc/fs/cifs/cifsFYI

What happens :=20
in /var/log/messages
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Dec 3 17:31:01 u1205-08l kernel: [ 3732.140040] CIFS VFS: Unexpected lo=
okup error -512
Dec 3 17:31:01 u1205-08l kernel: [ 3732.334939] CIFS VFS: Unexpected SM=
B signature

This user was working since one hour with no problem :
Daemon log :
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Dec 3 16:29:35 u1205-08l cifs.upcall: key description: cifs.spnego;0;0;=
3f000000
;ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0x1000005;c=
reduid=3D0x1000005;us
er=3D21206xxx;pid=3D0x65f
Dec 3 16:29:35 u1205-08l cifs.upcall: ver=3D2
Dec 3 16:29:35 u1205-08l cifs.upcall: host=3Dfigue
Dec 3 16:29:35 u1205-08l cifs.upcall: ip=3D130.120.8.11
Dec 3 16:29:35 u1205-08l cifs.upcall: sec=3D1
Dec 3 16:29:35 u1205-08l cifs.upcall: uid=3D16777221
Dec 3 16:29:35 u1205-08l cifs.upcall: creduid=3D16777221
Dec 3 16:29:35 u1205-08l cifs.upcall: user=3D21206xxx
Dec 3 16:29:35 u1205-08l cifs.upcall: pid=3D1631
Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc: considering /tmp/kr=
b5cc_167
77221
Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc: FILE:/tmp/krb5cc_16=
777221 i
s valid ccache

in dmesg
=3D=3D=3D=3D=3D=3D=3D=3D=3D
fs/cifs/inode.c: Getting info on \21206xxx\TP9
[ 3735.419612] fs/cifs/transport.c: For smb_command 50
[ 3735.419615] fs/cifs/transport.c: Sending smb: total_len 104
[ 3735.420257] fs/cifs/connect.c: RFC1002 header 0x23
[ 3735.420261] fs/cifs/connect.c: invalid transact2 word count
[ 3735.422403] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D50 mid=3D=
37012 state=3D4
[ 3735.422406] CIFS VFS: Unexpected SMB signature
[ 3735.422408] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
[ 3735.422411] fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to =
POSIX err -13
[ 3735.422413] fs/cifs/cifssmb.c: Send error in QPathInfo =3D -13
[ 3735.422415] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid =3D 76=
854) rc =3D -13
[ 3735.422424] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 76855 wi=
th uid: 16777221
[ 3735.422427] fs/cifs/dir.c: parent inode =3D 0xf14481f0 name is: TP9 =
and dentry =3D 0xf074e300
[ 3735.422429] fs/cifs/dir.c: NULL inode in lookup
[ 3735.422430] fs/cifs/dir.c: Full path: \21206xxx\TP9 inode =3D 0x (nu=
ll)

I don't understand what happens...
NULL inode in lookup ... What about noserverino option ?
Perhaps an unresponsive server... The network infrastructure is old. La=
st year I got this working very well, but the server was in a better pl=
ace (switch and network infrastructure speaking)

Regards,
Thanks in advance
Serge Conrad

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
