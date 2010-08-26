From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Cannot allocate memory error on mount
Date: Thu, 26 Aug 2010 14:46:09 +0530
Message-ID: <4C7630D9.7060203@suse.de>
References: <514808.54527.qm@web56908.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: joe hefner <joe.hefner-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514808.54527.qm-21+BQsVhpP+B9c0Qi4KiSs0jms80CZx+QQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/26/2010 01:56 AM, joe hefner wrote:
> On a recent Fedora (13), I am seeing a mount failure message that I c=
an not explain. I have a Windows Server 2003=C3=BDa with a share set up=
 for access only for a specific username (say userfoo). If I try to mou=
nt it from Linux,=C3=BDusing userfoo and the correct password all is we=
ll. If I try with a bad password or with some other username (userbar),=
 it fails with "Permission denied" as expected. If I try to mount as us=
ername =3D administrator, and give the correct administrator password, =
I would also expect "Permission denied", but I see "Cannot allocate mem=
ory" instead.
> =C3=BD
> dmesg and /var/log/messages show an odd=C3=BDentry about failure to g=
et root inode. Setting cifsFYI shows that errno 13 is being seen on the=
 client side, but then this=C3=BDinode error occurs.
> =C3=BD
> Has anyone seen this? Any ideas what is happening?
> =C3=BD
> Thanks, Joe H.
> =C3=BD
> =C3=BDfs/cifs/netmisc.c: Mapping smb error code 5 to POSIX err -13
> =C3=BDfs/cifs/cifssmb.c: Send error in QPathInfo =3D -13
> =C3=BDCIFS VFS: cifs_read_super: get root inode failed
> =C3=BDfs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 44322319 =
with uid: 0
> =C3=BDfs/cifs/cifssmb.c: In tree disconnect
> =C3=BDfs/cifs/transport.c: For smb_command 113
> =C3=BDfs/cifs/transport.c: Sending smb:=C3=BD total_len 39
> =C3=BDfs/cifs/connect.c: rfc1002 length 0x27
> =C3=BDfs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 443223=
20 with uid: 0
> =C3=BDfs/cifs/cifssmb.c: In SMBLogoff for session disconnect
> =C3=BDfs/cifs/transport.c: For smb_command 116
> =C3=BDfs/cifs/transport.c: Sending smb:=C3=BD total_len 43
> =C3=BDfs/cifs/connect.c: rfc1002 length 0x2b
>=20

Looks like the commit 0b8f18e3 assumed that cifs_get_inode_info() and
friends fail only due to memory allocation error when the inode is NULL
which is not the case if CIFSSMBQPathInfo() fails and returns an error.
=46ix this by propagating the actual error code back.

Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 4bc47e5..86a164f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -834,7 +834,7 @@ struct inode *cifs_root_iget(struct super_block *sb=
, unsigned long ino)
 						xid, NULL);
=20
 	if (!inode)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(rc);
=20
 #ifdef CONFIG_CIFS_FSCACHE
 	/* populate tcon->resource_id */
