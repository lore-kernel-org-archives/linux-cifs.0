From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Fri, 26 Aug 2011 17:23:42 -0400
Message-ID: <20110826172342.52996149@tlielax.poochiereds.net>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<20110826073437.743c06a3@tlielax.poochiereds.net>
	<CAKywueQQMuTA=xszQYr6sf5L+cZ_s56qrCiL8MqthWS-Xbxw5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQQMuTA=xszQYr6sf5L+cZ_s56qrCiL8MqthWS-Xbxw5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 27 Aug 2011 00:11:57 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/8/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Fri, 26 Aug 2011 10:52:21 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Reorganize code and make it send qpath info request only for a ful=
l
> >> path (//server/share/prefixpath) rather than request for every pat=
h
> >> compoment. In this case we end up with negative dentries for all
> >> components except full one and we will instantiate them later if
> >> such a mount is requested.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsfs.c =C2=A0| =C2=A0123 +++++++++++++++++++++++++=
++++++----------------------
> >> =C2=A0fs/cifs/cifsfs.h =C2=A0| =C2=A0 =C2=A03 +-
> >> =C2=A0fs/cifs/inode.c =C2=A0 | =C2=A0 =C2=A07 ++-
> >> =C2=A0fs/cifs/readdir.c | =C2=A0 =C2=A09 +++-
> >> =C2=A04 files changed, 85 insertions(+), 57 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index 0435bb9..33a2e1e 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -95,14 +95,13 @@ mempool_t *smb2_mid_poolp;
> >> =C2=A0static struct kmem_cache *smb2_mid_cachep;
> >> =C2=A0#endif /* CONFIG_CIFS_SMB2 */
> >>
> >> -static int
> >> +static void
> >> =C2=A0cifs_read_super(struct super_block *sb)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 struct inode *inode;
> >> - =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> - =C2=A0 =C2=A0 int rc =3D 0;
> >> + =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
> >>
> >> - =C2=A0 =C2=A0 cifs_sb =3D CIFS_SB(sb);
> >> + =C2=A0 =C2=A0 /* BB should we make this contingent on mount parm=
? */
> >> + =C2=A0 =C2=A0 sb->s_flags |=3D MS_NODIRATIME | MS_NOATIME;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSI=
XACL)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D =
MS_POSIXACL;
> >> @@ -120,26 +119,6 @@ cifs_read_super(struct super_block *sb)
> >> =C2=A0 =C2=A0 =C2=A0 sb->s_bdi =3D &cifs_sb->bdi;
> >> =C2=A0 =C2=A0 =C2=A0 sb->s_blocksize =3D CIFS_MAX_MSGSIZE;
> >> =C2=A0 =C2=A0 =C2=A0 sb->s_blocksize_bits =3D 14; =C2=A0 =C2=A0 =C2=
=A0/* default 2**14 =3D CIFS_MAX_MSGSIZE */
> >> - =C2=A0 =C2=A0 inode =3D cifs_root_iget(sb);
> >> -
> >> - =C2=A0 =C2=A0 if (IS_ERR(inode)) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D PTR_ERR(inode);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode =3D NULL;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_no_root;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 sb->s_root =3D d_alloc_root(inode);
> >> -
> >> - =C2=A0 =C2=A0 if (!sb->s_root) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOMEM;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_no_root;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 /* do that *after* d_alloc_root() - we want NULL -=
>d_op for root here */
> >> - =C2=A0 =C2=A0 if (cifs_sb_master_tcon(cifs_sb)->nocase)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_d_op =3D &cifs_c=
i_dentry_ops;
> >> - =C2=A0 =C2=A0 else
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_d_op =3D &cifs_d=
entry_ops;
> >>
> >> =C2=A0#ifdef CIFS_NFSD_EXPORT
> >> =C2=A0 =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERV=
ER_INUM) {
> >> @@ -148,14 +127,7 @@ cifs_read_super(struct super_block *sb)
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0#endif /* CIFS_NFSD_EXPORT */
> >>
> >> - =C2=A0 =C2=A0 return 0;
> >> -
> >> -out_no_root:
> >> - =C2=A0 =C2=A0 cERROR(1, "cifs_read_super: get root inode failed"=
);
> >> - =C2=A0 =C2=A0 if (inode)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iput(inode);
> >> -
> >> - =C2=A0 =C2=A0 return rc;
> >> + =C2=A0 =C2=A0 sb->s_flags |=3D MS_ACTIVE;
> >> =C2=A0}
> >>
> >> =C2=A0static void cifs_kill_sb(struct super_block *sb)
> >> @@ -529,6 +501,17 @@ static const struct super_operations cifs_sup=
er_ops =3D {
> >> =C2=A0#endif
> >> =C2=A0};
> >>
> >> +static struct dentry *
> >> +cifs_alloc_root(struct super_block *sb)
> >> +{
> >> + =C2=A0 =C2=A0 struct qstr q;
> >> +
> >> + =C2=A0 =C2=A0 q.name =3D "/";
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0I don't think you want a separator in th=
e name. That seems
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0like it should be "".
> >
>=20
> In this case I based it on d_alloc_root() function that fills name as
> "/". Why this should be ""?
>=20

You may be right. It just looked odd to me because '/' is typically the
delimiter between path components and the q.name should be the name of
the path component itself. If d_alloc_root does it though, you're
probably OK.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
