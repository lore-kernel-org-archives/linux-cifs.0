From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Tue, 30 Aug 2011 08:59:35 -0400
Message-ID: <20110830085935.71e671e4@corrin.poochiereds.net>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Aug 2011 16:31:52 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/8/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> > Reorganize code and make it send qpath info request only for a full
> > path (//server/share/prefixpath) rather than request for every path
> > compoment. In this case we end up with negative dentries for all
> > components except full one and we will instantiate them later if
> > such a mount is requested.
> >
> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsfs.c =C2=A0| =C2=A0123 ++++++++++++++++++++++++++=
+++++----------------------
> > =C2=A0fs/cifs/cifsfs.h =C2=A0| =C2=A0 =C2=A03 +-
> > =C2=A0fs/cifs/inode.c =C2=A0 | =C2=A0 =C2=A07 ++-
> > =C2=A0fs/cifs/readdir.c | =C2=A0 =C2=A09 +++-
> > =C2=A04 files changed, 85 insertions(+), 57 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 0435bb9..33a2e1e 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -95,14 +95,13 @@ mempool_t *smb2_mid_poolp;
> > =C2=A0static struct kmem_cache *smb2_mid_cachep;
> > =C2=A0#endif /* CONFIG_CIFS_SMB2 */
> >
> > -static int
> > +static void
> > =C2=A0cifs_read_super(struct super_block *sb)
> > =C2=A0{
> > - =C2=A0 =C2=A0 =C2=A0 struct inode *inode;
> > - =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> > - =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb)=
;
> >
> > - =C2=A0 =C2=A0 =C2=A0 cifs_sb =3D CIFS_SB(sb);
> > + =C2=A0 =C2=A0 =C2=A0 /* BB should we make this contingent on moun=
t parm? */
> > + =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_NODIRATIME | MS_NOATIME;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT=
_POSIXACL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_flags =
|=3D MS_POSIXACL;
> > @@ -120,26 +119,6 @@ cifs_read_super(struct super_block *sb)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_bdi =3D &cifs_sb->bdi;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_blocksize =3D CIFS_MAX_MSGSIZE;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_blocksize_bits =3D 14; =C2=A0 =C2=A0=
 =C2=A0/* default 2**14 =3D CIFS_MAX_MSGSIZE */
> > - =C2=A0 =C2=A0 =C2=A0 inode =3D cifs_root_iget(sb);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(inode)) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D PTR_ERR(i=
node);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode =3D NULL;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_no_root=
;
> > - =C2=A0 =C2=A0 =C2=A0 }
> > -
> > - =C2=A0 =C2=A0 =C2=A0 sb->s_root =3D d_alloc_root(inode);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 if (!sb->s_root) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOMEM;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_no_root=
;
> > - =C2=A0 =C2=A0 =C2=A0 }
> > -
> > - =C2=A0 =C2=A0 =C2=A0 /* do that *after* d_alloc_root() - we want =
NULL ->d_op for root here */
> > - =C2=A0 =C2=A0 =C2=A0 if (cifs_sb_master_tcon(cifs_sb)->nocase)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_d_op =3D &=
cifs_ci_dentry_ops;
> > - =C2=A0 =C2=A0 =C2=A0 else
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_d_op =3D &=
cifs_dentry_ops;
> >
> > =C2=A0#ifdef CIFS_NFSD_EXPORT
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT=
_SERVER_INUM) {
> > @@ -148,14 +127,7 @@ cifs_read_super(struct super_block *sb)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0#endif /* CIFS_NFSD_EXPORT */
> >
> > - =C2=A0 =C2=A0 =C2=A0 return 0;
> > -
> > -out_no_root:
> > - =C2=A0 =C2=A0 =C2=A0 cERROR(1, "cifs_read_super: get root inode f=
ailed");
> > - =C2=A0 =C2=A0 =C2=A0 if (inode)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iput(inode);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 return rc;
> > + =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_ACTIVE;
> > =C2=A0}
> >
> > =C2=A0static void cifs_kill_sb(struct super_block *sb)
> > @@ -529,6 +501,17 @@ static const struct super_operations cifs_supe=
r_ops =3D {
> > =C2=A0#endif
> > =C2=A0};
> >
> > +static struct dentry *
> > +cifs_alloc_root(struct super_block *sb)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct qstr q;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 q.name =3D "/";
> > + =C2=A0 =C2=A0 =C2=A0 q.len =3D 1;
> > + =C2=A0 =C2=A0 =C2=A0 q.hash =3D full_name_hash(q.name, q.len);
> > + =C2=A0 =C2=A0 =C2=A0 return d_alloc_pseudo(sb, &q);
> > +}
> > +
> > =C2=A0/*
> > =C2=A0* Get root dentry from superblock according to prefix path mo=
unt option.
> > =C2=A0* Return dentry with refcount + 1 on success and NULL otherwi=
se.
> > @@ -536,8 +519,10 @@ static const struct super_operations cifs_supe=
r_ops =3D {
> > =C2=A0static struct dentry *
> > =C2=A0cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> > =C2=A0{
> > - =C2=A0 =C2=A0 =C2=A0 struct dentry *dentry;
> > + =C2=A0 =C2=A0 =C2=A0 struct dentry *dentry, *found;
> > + =C2=A0 =C2=A0 =C2=A0 struct inode *inode;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_sb_info *cifs_sb =3D CIFS_SB=
(sb);
> > + =C2=A0 =C2=A0 =C2=A0 struct qstr q;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *full_path =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *s, *p;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char sep;
> > @@ -550,13 +535,29 @@ cifs_get_root(struct smb_vol *vol, struct sup=
er_block *sb)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "Get root dentry for %s", full_p=
ath);
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (!sb->s_root) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_root =3D c=
ifs_alloc_root(sb);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(sb->s=
_root)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D ERR_PTR(-ENOMEM);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* do that =
*after* cifs_alloc_root() - we want NULL ->d_op for
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* root her=
e
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cifs_sb_mast=
er_tcon(cifs_sb)->nocase)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sb->s_d_op =3D &cifs_ci_dentry_ops;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sb->s_d_op =3D &cifs_dentry_ops;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sep =3D CIFS_DIR_SEP(cifs_sb);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0dentry =3D dget(sb->s_root);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D s =3D full_path;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0do {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct inode *di=
r =3D dentry->d_inode;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dentr=
y *child;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* skip sepa=
rators */
> > @@ -569,16 +570,45 @@ cifs_get_root(struct smb_vol *vol, struct sup=
er_block *sb)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (*s &&=
 *s !=3D sep)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0s++;
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock(&dir-=
>i_mutex);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 child =3D lookup=
_one_len(p, dentry, s - p);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&di=
r->i_mutex);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q.name =3D p;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q.len =3D s - p;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dentry->d_fl=
ags & DCACHE_OP_HASH)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry->d_op->d_hash(dentry, dentry->d_inode, &q);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 q.hash =3D full_name_hash(q.name, q.len);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 child =3D d_look=
up(dentry, &q);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!child) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 child =3D d_alloc(dentry, &q);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (IS_ERR(child)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dput(dentry);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dentry =3D ERR_CAST(child);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 d_rehash(child);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dput(dentry)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dentry =3D c=
hild;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dentry->d_i=
node) {
> > + =C2=A0 =C2=A0 =C2=A0 } while (!IS_ERR(dentry));
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(dentry))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (!dentry->d_inode) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode =3D cifs_m=
ntroot_iget(sb, full_path);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(inode=
)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0dput(dentry);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D ERR_PTR(-ENOENT);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D ERR_CAST(inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > - =C2=A0 =C2=A0 =C2=A0 } while (!IS_ERR(dentry));
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found =3D d_inst=
antiate_unique(dentry, inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (found) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dput(dentry);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D dget(found);
>=20
> it seems like found dentry has been already got by
> d_instantiate_unique - we don't need to call dget again here
>=20

That sounds right.

> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
>=20
> also, I think that if (!dentry->d_inode) {} statement should be
> protected by a lock (mutex) - I am not sure should we create new lock
> for this or use existing one. What d you think about it?
>=20

I guess you're worried about the dentry suddenly becoming negative
after checking for it? If you have an active reference to it, then
that shouldn't occur. See d_delete().

> > +out:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0_FreeXid(xid);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(full_path);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return dentry;
> > @@ -646,16 +676,7 @@ cifs_do_mount(struct file_system_type *fs_type=
,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_umount(=
cifs_sb);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_flags =
=3D flags;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* BB should we =
make this contingent on mount parm? */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D=
 MS_NODIRATIME | MS_NOATIME;
> > -
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_read=
_super(sb);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 root =3D ERR_PTR(rc);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out_super;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > -
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D=
 MS_ACTIVE;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_read_super(=
sb);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0root =3D cifs_get_root(volume_info, sb);
> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> > index 3145c18..47d9ec9 100644
> > --- a/fs/cifs/cifsfs.h
> > +++ b/fs/cifs/cifsfs.h
> > @@ -43,7 +43,8 @@ extern const struct address_space_operations cifs=
_addr_ops_smallbuf;
> >
> > =C2=A0/* Functions related to inodes */
> > =C2=A0extern const struct inode_operations cifs_dir_inode_ops;
> > -extern struct inode *cifs_root_iget(struct super_block *);
> > +extern struct inode *cifs_mntroot_iget(struct super_block *sb,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const=
 char *full_path);
> > =C2=A0extern int cifs_create(struct inode *, struct dentry *, int,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct nameidata *);
> > =C2=A0extern struct dentry *cifs_lookup(struct inode *, struct dent=
ry *,
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index aee0c0b..dedfed3 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -931,7 +931,7 @@ retry_iget5_locked:
> > =C2=A0}
> >
> > =C2=A0/* gets root inode */
> > -struct inode *cifs_root_iget(struct super_block *sb)
> > +struct inode *cifs_mntroot_iget(struct super_block *sb, const char=
 *full_path)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int xid;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_sb_info *cifs_sb =3D CIFS_SB=
(sb);
> > @@ -941,9 +941,10 @@ struct inode *cifs_root_iget(struct super_bloc=
k *sb)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tcon->unix_ext)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_get_=
inode_info_unix(&inode, "", sb, xid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_get_=
inode_info_unix(&inode, full_path, sb, xid);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_get_=
inode_info(&inode, "", NULL, sb, xid, NULL);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_get_=
inode_info(&inode, full_path, NULL, sb, xid,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
NULL);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!inode) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode =3D ER=
R_PTR(rc);
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index 75e8b5c..7475cba 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -708,6 +708,7 @@ int cifs_readdir(struct file *file, void *diren=
try, filldir_t filldir)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *tmp_buf =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *end_of_smb;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int max_len;
> > + =C2=A0 =C2=A0 =C2=A0 ino_t ino;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> >
> > @@ -732,8 +733,12 @@ int cifs_readdir(struct file *file, void *dire=
ntry, filldir_t filldir)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0file->f_pos+=
+;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0case 1:
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (filldir(dire=
ntry, "..", 2, file->f_pos,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0parent_ino(file->f_path.dentry), DT_DIR) < 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!file->f_pat=
h.dentry->d_parent->d_inode) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cFYI(1, "parent dir is negative, filling as current");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ino =3D file->f_path.dentry->d_inode->i_ino;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ino =3D parent_ino(file->f_path.dentry);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (filldir(dire=
ntry, "..", 2, file->f_pos, ino, DT_DIR) < 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cERROR(1, "Filldir for parent dir failed");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -ENOMEM;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > --
> > 1.7.1
> >
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
