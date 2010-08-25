From: joe hefner <joe.hefner-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Cannot allocate memory error on mount
Date: Wed, 25 Aug 2010 13:26:04 -0700 (PDT)
Message-ID: <514808.54527.qm@web56908.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On a recent Fedora (13), I am seeing a mount failure message that I can=
 not explain. I have a Windows Server 2003=A0a with a share set up for =
access only for a specific username (say userfoo). If I try to mount it=
 from Linux,=A0using userfoo and the correct password all is well. If I=
 try with a bad password or with some other username (userbar), it fail=
s with "Permission denied" as expected. If I try to mount as username =3D=
 administrator, and give the correct administrator password, I would al=
so expect "Permission denied", but I see "Cannot allocate memory" inste=
ad.
=A0
dmesg and /var/log/messages show an odd=A0entry about failure to get ro=
ot inode. Setting cifsFYI shows that errno 13 is being seen on the clie=
nt side, but then this=A0inode error occurs.
=A0
Has anyone seen this? Any ideas what is happening?
=A0
Thanks, Joe H.
=A0
=A0fs/cifs/netmisc.c: Mapping smb error code 5 to POSIX err -13
=A0fs/cifs/cifssmb.c: Send error in QPathInfo =3D -13
=A0CIFS VFS: cifs_read_super: get root inode failed
=A0fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 44322319 with =
uid: 0
=A0fs/cifs/cifssmb.c: In tree disconnect
=A0fs/cifs/transport.c: For smb_command 113
=A0fs/cifs/transport.c: Sending smb:=A0 total_len 39
=A0fs/cifs/connect.c: rfc1002 length 0x27
=A0fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 44322320 wi=
th uid: 0
=A0fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
=A0fs/cifs/transport.c: For smb_command 116
=A0fs/cifs/transport.c: Sending smb:=A0 total_len 43
=A0fs/cifs/connect.c: rfc1002 length 0x2b




     =20
