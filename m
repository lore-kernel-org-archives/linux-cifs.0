From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Cannot allocate memory error on mount
Date: Thu, 26 Aug 2010 08:23:05 -0400
Message-ID: <20100826082305.1594ec4e@barsoom.rdu.redhat.com>
References: <514808.54527.qm@web56908.mail.re3.yahoo.com>
	<4C7630D9.7060203@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: joe hefner <joe.hefner-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7630D9.7060203-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 26 Aug 2010 14:46:09 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 08/26/2010 01:56 AM, joe hefner wrote:
> > On a recent Fedora (13), I am seeing a mount failure message that I=
 can not explain. I have a Windows Server 2003=FDa with a share set up =
for access only for a specific username (say userfoo). If I try to moun=
t it from Linux,=FDusing userfoo and the correct password all is well. =
If I try with a bad password or with some other username (userbar), it =
fails with "Permission denied" as expected. If I try to mount as userna=
me =3D administrator, and give the correct administrator password, I wo=
uld also expect "Permission denied", but I see "Cannot allocate memory"=
 instead.
> > =FD
> > dmesg and /var/log/messages show an odd=FDentry about failure to ge=
t root inode. Setting cifsFYI shows that errno 13 is being seen on the =
client side, but then this=FDinode error occurs.
> > =FD
> > Has anyone seen this? Any ideas what is happening?
> > =FD
> > Thanks, Joe H.
> > =FD
> > =FDfs/cifs/netmisc.c: Mapping smb error code 5 to POSIX err -13
> > =FDfs/cifs/cifssmb.c: Send error in QPathInfo =3D -13
> > =FDCIFS VFS: cifs_read_super: get root inode failed
> > =FDfs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 44322319 w=
ith uid: 0
> > =FDfs/cifs/cifssmb.c: In tree disconnect
> > =FDfs/cifs/transport.c: For smb_command 113
> > =FDfs/cifs/transport.c: Sending smb:=FD total_len 39
> > =FDfs/cifs/connect.c: rfc1002 length 0x27
> > =FDfs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 4432232=
0 with uid: 0
> > =FDfs/cifs/cifssmb.c: In SMBLogoff for session disconnect
> > =FDfs/cifs/transport.c: For smb_command 116
> > =FDfs/cifs/transport.c: Sending smb:=FD total_len 43
> > =FDfs/cifs/connect.c: rfc1002 length 0x2b
> >=20
>=20
> Looks like the commit 0b8f18e3 assumed that cifs_get_inode_info() and
> friends fail only due to memory allocation error when the inode is NU=
LL
> which is not the case if CIFSSMBQPathInfo() fails and returns an erro=
r.
> Fix this by propagating the actual error code back.
>=20
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 4bc47e5..86a164f 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -834,7 +834,7 @@ struct inode *cifs_root_iget(struct super_block *=
sb, unsigned long ino)
>  						xid, NULL);
> =20
>  	if (!inode)
> -		return ERR_PTR(-ENOMEM);
> +		return ERR_PTR(rc);
> =20
>  #ifdef CONFIG_CIFS_FSCACHE
>  	/* populate tcon->resource_id */

Good catch.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
