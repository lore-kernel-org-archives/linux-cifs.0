From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Wed, 31 Aug 2011 14:00:44 -0400
Message-ID: <20110831140044.5ac4a691@tlielax.poochiereds.net>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A@mail.gmail.com>
	<20110830085935.71e671e4@corrin.poochiereds.net>
	<CAKywueSy2tFQC4mxOBZYjiY=PyLjUZ44v+qvtNNg+zKoxJmeCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSy2tFQC4mxOBZYjiY=PyLjUZ44v+qvtNNg+zKoxJmeCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 31 Aug 2011 21:35:39 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/8/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Tue, 30 Aug 2011 16:31:52 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> 2011/8/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> >> > Reorganize code and make it send qpath info request only for a f=
ull
> >> > path (//server/share/prefixpath) rather than request for every p=
ath
> >> > compoment. In this case we end up with negative dentries for all
> >> > components except full one and we will instantiate them later if
> >> > such a mount is requested.
> >> >
> >> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> > ---
> >> > =C2=A0fs/cifs/cifsfs.c =C2=A0| =C2=A0123 +++++++++++++++++++++++=
++++++++----------------------
> >> > =C2=A0fs/cifs/cifsfs.h =C2=A0| =C2=A0 =C2=A03 +-
> >> > =C2=A0fs/cifs/inode.c =C2=A0 | =C2=A0 =C2=A07 ++-
> >> > =C2=A0fs/cifs/readdir.c | =C2=A0 =C2=A09 +++-
> >> > =C2=A04 files changed, 85 insertions(+), 57 deletions(-)
> >> >
> >> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> > index 0435bb9..33a2e1e 100644
> >> > --- a/fs/cifs/cifsfs.c
> >> > +++ b/fs/cifs/cifsfs.c
> >> > @@ -95,14 +95,13 @@ mempool_t *smb2_mid_poolp;
> >> > =C2=A0static struct kmem_cache *smb2_mid_cachep;
> >> > =C2=A0#endif /* CONFIG_CIFS_SMB2 */
> >> >
> >> > -static int
> >> > +static void
> >> > =C2=A0cifs_read_super(struct super_block *sb)
> >> > =C2=A0{
> >> > - =C2=A0 =C2=A0 =C2=A0 struct inode *inode;
> >> > - =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> > - =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> >> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(=
sb);
> >> >
> >> > - =C2=A0 =C2=A0 =C2=A0 cifs_sb =3D CIFS_SB(sb);
> >> > + =C2=A0 =C2=A0 =C2=A0 /* BB should we make this contingent on m=
ount parm? */
> >> > + =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_NODIRATIME | MS_NOATI=
ME;
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_POSIXACL)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_fla=
gs |=3D MS_POSIXACL;
> >> > @@ -120,26 +119,6 @@ cifs_read_super(struct super_block *sb)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_bdi =3D &cifs_sb->bdi;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_blocksize =3D CIFS_MAX_MSGSIZE;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_blocksize_bits =3D 14; =C2=A0 =C2=
=A0 =C2=A0/* default 2**14 =3D CIFS_MAX_MSGSIZE */
> >> > - =C2=A0 =C2=A0 =C2=A0 inode =3D cifs_root_iget(sb);
> >> > -
> >> > - =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(inode)) {
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D PTR_ER=
R(inode);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode =3D NUL=
L;
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_no_r=
oot;
> >> > - =C2=A0 =C2=A0 =C2=A0 }
> >> > -
> >> > - =C2=A0 =C2=A0 =C2=A0 sb->s_root =3D d_alloc_root(inode);
> >> > -
> >> > - =C2=A0 =C2=A0 =C2=A0 if (!sb->s_root) {
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOME=
M;
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_no_r=
oot;
> >> > - =C2=A0 =C2=A0 =C2=A0 }
> >> > -
> >> > - =C2=A0 =C2=A0 =C2=A0 /* do that *after* d_alloc_root() - we wa=
nt NULL ->d_op for root here */
> >> > - =C2=A0 =C2=A0 =C2=A0 if (cifs_sb_master_tcon(cifs_sb)->nocase)
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_d_op =3D=
 &cifs_ci_dentry_ops;
> >> > - =C2=A0 =C2=A0 =C2=A0 else
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_d_op =3D=
 &cifs_dentry_ops;
> >> >
> >> > =C2=A0#ifdef CIFS_NFSD_EXPORT
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_SERVER_INUM) {
> >> > @@ -148,14 +127,7 @@ cifs_read_super(struct super_block *sb)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > =C2=A0#endif /* CIFS_NFSD_EXPORT */
> >> >
> >> > - =C2=A0 =C2=A0 =C2=A0 return 0;
> >> > -
> >> > -out_no_root:
> >> > - =C2=A0 =C2=A0 =C2=A0 cERROR(1, "cifs_read_super: get root inod=
e failed");
> >> > - =C2=A0 =C2=A0 =C2=A0 if (inode)
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iput(inode);
> >> > -
> >> > - =C2=A0 =C2=A0 =C2=A0 return rc;
> >> > + =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_ACTIVE;
> >> > =C2=A0}
> >> >
> >> > =C2=A0static void cifs_kill_sb(struct super_block *sb)
> >> > @@ -529,6 +501,17 @@ static const struct super_operations cifs_s=
uper_ops =3D {
> >> > =C2=A0#endif
> >> > =C2=A0};
> >> >
> >> > +static struct dentry *
> >> > +cifs_alloc_root(struct super_block *sb)
> >> > +{
> >> > + =C2=A0 =C2=A0 =C2=A0 struct qstr q;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 q.name =3D "/";
> >> > + =C2=A0 =C2=A0 =C2=A0 q.len =3D 1;
> >> > + =C2=A0 =C2=A0 =C2=A0 q.hash =3D full_name_hash(q.name, q.len);
> >> > + =C2=A0 =C2=A0 =C2=A0 return d_alloc_pseudo(sb, &q);
> >> > +}
> >> > +
> >> > =C2=A0/*
> >> > =C2=A0* Get root dentry from superblock according to prefix path=
 mount option.
> >> > =C2=A0* Return dentry with refcount + 1 on success and NULL othe=
rwise.
> >> > @@ -536,8 +519,10 @@ static const struct super_operations cifs_s=
uper_ops =3D {
> >> > =C2=A0static struct dentry *
> >> > =C2=A0cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> >> > =C2=A0{
> >> > - =C2=A0 =C2=A0 =C2=A0 struct dentry *dentry;
> >> > + =C2=A0 =C2=A0 =C2=A0 struct dentry *dentry, *found;
> >> > + =C2=A0 =C2=A0 =C2=A0 struct inode *inode;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_sb_info *cifs_sb =3D CIFS=
_SB(sb);
> >> > + =C2=A0 =C2=A0 =C2=A0 struct qstr q;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *full_path =3D NULL;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *s, *p;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char sep;
> >> > @@ -550,13 +535,29 @@ cifs_get_root(struct smb_vol *vol, struct =
super_block *sb)
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "Get root dentry for %s", ful=
l_path);
> >> >
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!sb->s_root) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_root =3D=
 cifs_alloc_root(sb);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(sb=
->s_root)) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 dentry =3D ERR_PTR(-ENOMEM);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 goto out;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* do th=
at *after* cifs_alloc_root() - we want NULL ->d_op for
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* root =
here
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cifs_sb_m=
aster_tcon(cifs_sb)->nocase)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 sb->s_d_op =3D &cifs_ci_dentry_ops;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 sb->s_d_op =3D &cifs_dentry_ops;
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >> > +
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0sep =3D CIFS_DIR_SEP(cifs_sb);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0dentry =3D dget(sb->s_root);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D s =3D full_path;
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0do {
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct inode =
*dir =3D dentry->d_inode;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct de=
ntry *child;
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* skip s=
eparators */
> >> > @@ -569,16 +570,45 @@ cifs_get_root(struct smb_vol *vol, struct =
super_block *sb)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (*s=
 && *s !=3D sep)
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0s++;
> >> >
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock(&d=
ir->i_mutex);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 child =3D loo=
kup_one_len(p, dentry, s - p);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(=
&dir->i_mutex);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q.name =3D p;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q.len =3D s -=
 p;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dentry->d=
_flags & DCACHE_OP_HASH)
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 dentry->d_op->d_hash(dentry, dentry->d_inode, &q);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 q.hash =3D full_name_hash(q.name, q.len);
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 child =3D d_l=
ookup(dentry, &q);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!child) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 child =3D d_alloc(dentry, &q);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (IS_ERR(child)) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dput(dentry);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dentry =3D ERR_CAST(child);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 }
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 d_rehash(child);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dput(dent=
ry);
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dentry =3D=
 child;
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dentry->=
d_inode) {
> >> > + =C2=A0 =C2=A0 =C2=A0 } while (!IS_ERR(dentry));
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(dentry))
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 if (!dentry->d_inode) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode =3D cif=
s_mntroot_iget(sb, full_path);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(in=
ode)) {
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0dput(dentry);
> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 dentry =3D ERR_PTR(-ENOENT);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 dentry =3D ERR_CAST(inode);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 goto out;
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >> > - =C2=A0 =C2=A0 =C2=A0 } while (!IS_ERR(dentry));
> >> > +
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found =3D d_i=
nstantiate_unique(dentry, inode);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (found) {
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 dput(dentry);
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 dentry =3D dget(found);
> >>
> >> it seems like found dentry has been already got by
> >> d_instantiate_unique - we don't need to call dget again here
> >>
> >
> > That sounds right.
> >
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> > + =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> also, I think that if (!dentry->d_inode) {} statement should be
> >> protected by a lock (mutex) - I am not sure should we create new l=
ock
> >> for this or use existing one. What d you think about it?
> >>
> >
> > I guess you're worried about the dentry suddenly becoming negative
> > after checking for it? If you have an active reference to it, then
> > that shouldn't occur. See d_delete().
> >
>=20
> No, I mean the following situation:
> 1) process1 gets a dentry and comes into if (!dentry->d_inode) {}
> 2) process2 gets the same dentry and comes into if {} too (because
> dentry is still negative).
> 3) process1 gets a new inode
> 4) process2 gets a new inode (e.g. it doesn't get an inode created by
> process1 in noserverino case)
> 5) denty is instantiated twice - wrong!
>=20
> if we protect if statement with a mutex - it won't happen. Should we
> create extra one for this?
>=20

I think you need to make sure you're holding the i_mutex of the parent
for this. Most of these sorts of dentry operations require it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
