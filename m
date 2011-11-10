From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs and win2k8
Date: Thu, 10 Nov 2011 08:24:12 -0500
Message-ID: <20111110082412.7ff860e6@tlielax.poochiereds.net>
References: <20111024073534.GB7086@cobija.connexer.com>
	<1320171185-11150-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRjR+UNg98odoe8x2WmnqdiCtEa_UgwnKt-8AEi0XRFdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRjR+UNg98odoe8x2WmnqdiCtEa_UgwnKt-8AEi0XRFdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 Nov 2011 22:56:18 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/11/1 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> > Sorry for so long delay on this. Here is the fixed version of the p=
atch:
> >
> > [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with prefixpat=
h option
> >
> > but I found out one use case where it doesn't work right:
> >
> > 1) mount //server/share/a/b/ test
> > 2) mount //server/share/ test2
> > 3) stat test2/a/b - return wrong inode number (autodisable server i=
node number happens)
> >
> > In the same time if I add "ls test2" before step #3 it works! May b=
e VFS can't
> > handle negative dentry with children in this case, but I am not sur=
e.
> >
> > Reorganize code and make it send qpath info request only for a full
> > path (//server/share/prefixpath) rather than request for every path
> > compoment. In this case we end up with negative dentries for all
> > components except full one and we will instantiate them later if
> > such a mount is requested.
> >
> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsfs.c =C2=A0 | =C2=A0138 +++++++++++++++++++++++++=
++++++--------------------
> > =C2=A0fs/cifs/cifsfs.h =C2=A0 | =C2=A0 =C2=A03 +-
> > =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A06 ++
> > =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A03 +-
> > =C2=A0fs/cifs/inode.c =C2=A0 =C2=A0| =C2=A0 =C2=A07 ++-
> > =C2=A0fs/cifs/readdir.c =C2=A0| =C2=A0 43 ++++++++++------
> > =C2=A06 files changed, 124 insertions(+), 76 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 8f1fe32..a188be1 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -90,14 +90,13 @@ extern mempool_t *cifs_sm_req_poolp;
> > =C2=A0extern mempool_t *cifs_req_poolp;
> > =C2=A0extern mempool_t *cifs_mid_poolp;
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
> > @@ -115,26 +114,6 @@ cifs_read_super(struct super_block *sb)
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
> > =C2=A0#ifdef CONFIG_CIFS_NFSD_EXPORT
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT=
_SERVER_INUM) {
> > @@ -143,14 +122,7 @@ cifs_read_super(struct super_block *sb)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0#endif /* CONFIG_CIFS_NFSD_EXPORT */
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
> > @@ -528,6 +500,17 @@ static const struct super_operations cifs_supe=
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
> > @@ -535,8 +518,10 @@ static const struct super_operations cifs_supe=
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
> > @@ -548,20 +533,30 @@ cifs_get_root(struct smb_vol *vol, struct sup=
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
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dir) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dput(dentry);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D ERR_PTR(-ENOENT);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* skip sepa=
rators */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (*s =3D=
=3D sep)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0s++;
> > @@ -572,12 +567,55 @@ cifs_get_root(struct smb_vol *vol, struct sup=
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
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} while (!IS_ERR(dentry));
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(dentry))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 mutex_lock(&cifs_root_mutex);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (dentry->d_parent->d_inode)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock(&dent=
ry->d_parent->d_inode->i_mutex);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (!dentry->d_inode) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode =3D cifs_m=
ntroot_iget(sb, full_path);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(inode=
)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dput(dentry);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D ERR_CAST(inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found =3D d_inst=
antiate_unique(dentry, inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (found) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dput(dentry);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D found;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (dentry->d_parent->d_inode)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&de=
ntry->d_parent->d_inode->i_mutex);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&cifs_root_mutex);
> > +out:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(full_path);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return dentry;
> > =C2=A0}
> > @@ -644,16 +682,7 @@ cifs_do_mount(struct file_system_type *fs_type=
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
> > @@ -1112,6 +1141,7 @@ init_cifs(void)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&cifs_tcp_ses_lock);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&cifs_file_list_lock);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&GlobalMid_Lock);
> > + =C2=A0 =C2=A0 =C2=A0 mutex_init(&cifs_root_mutex);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_max_pending < 2) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_max_pen=
ding =3D 2;
> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> > index 30ff560..cf28150 100644
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
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 8238aa1..67f6852 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -958,6 +958,12 @@ GLOBAL_EXTERN spinlock_t =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 cifs_tcp_ses_lock;
> > =C2=A0*/
> > =C2=A0GLOBAL_EXTERN spinlock_t =C2=A0 =C2=A0 =C2=A0 cifs_file_list_=
lock;
> >
> > +/*
> > + * This lock protects root dentry in cifs_get_root from being inst=
antiated
> > + * twice.
> > + */
> > +GLOBAL_EXTERN struct mutex cifs_root_mutex;
> > +
> > =C2=A0#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily=
 */
> > =C2=A0/* Outstanding dir notify requests */
> > =C2=A0GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index d7eeb9d..d6b3319 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -553,6 +553,7 @@ cifs_lookup(struct inode *parent_dir_inode, str=
uct dentry *direntry,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (direntry->d_inode !=3D NULL) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "non=
-NULL inode in lookup");
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 newInode =3D dir=
entry->d_inode;
>=20
> this and ...
>=20
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "NUL=
L inode in lookup");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > @@ -596,7 +597,7 @@ cifs_lookup(struct inode *parent_dir_inode, str=
uct dentry *direntry,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D cifs_=
get_inode_info(&newInode, full_path, NULL,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parent_dir_inode->i_sb, xid, =
NULL);
> >
> > - =C2=A0 =C2=A0 =C2=A0 if ((rc =3D=3D 0) && (newInode !=3D NULL)) {
> > + =C2=A0 =C2=A0 =C2=A0 if ((rc =3D=3D 0) && (newInode !=3D NULL) &&=
 !direntry->d_inode) {
>=20
> ... this doesn't make sense - I made it for testing purpose only and
> forgot to remove. Since this patch isn't going to be a candidate to
> merge, seems no need to respin it.
>=20
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0d_add(dirent=
ry, newInode);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (posix_op=
en) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0filp =3D lookup_instantiate_filp(nd, direntry,
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 2c50bd2..7b7fccd 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -878,7 +878,7 @@ retry_iget5_locked:
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
> > @@ -888,9 +888,10 @@ struct inode *cifs_root_iget(struct super_bloc=
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
> > index 5de03ec..b2f8851 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -65,10 +65,8 @@ static inline void dump_cifs_file_struct(struct =
file *file, char *label)
> > =C2=A0}
> > =C2=A0#endif /* DEBUG2 */
> >
> > -/*
> > - * Find the dentry that matches "name". If there isn't one, create=
 one. If it's
> > - * a negative dentry or the uniqueid changed, then drop it and rec=
reate it.
> > - */
> > +
> > +/* Find the dentry that matches "name". If there isn't one, create=
 one. */
> > =C2=A0static struct dentry *
> > =C2=A0cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
struct cifs_fattr *fattr)
> > @@ -84,32 +82,38 @@ cifs_readdir_lookup(struct dentry *parent, stru=
ct qstr *name,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name->hash =3D=
 full_name_hash(name->name, name->len);
> >
> > + =C2=A0 =C2=A0 =C2=A0 mutex_lock(&cifs_root_mutex);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0dentry =3D d_lookup(parent, name);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dentry) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* FIXME: ch=
eck for inode number changes? */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dentry->=
d_inode !=3D NULL)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return dentry;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 d_drop(dentry);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dput(dentry);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 } else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dentry =3D d_all=
oc(parent, name);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dentry =3D=3D=
 NULL)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 d_rehash(dentry)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 dentry =3D d_alloc(parent, name);
> > - =C2=A0 =C2=A0 =C2=A0 if (dentry =3D=3D NULL)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0inode =3D cifs_iget(sb, fattr);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!inode) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dput(dentry)=
;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dentry =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 alias =3D d_materialise_unique(dentry, inode=
);
> > + =C2=A0 =C2=A0 =C2=A0 alias =3D d_instantiate_unique(dentry, inode=
);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (alias !=3D NULL) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dput(dentry)=
;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(alias=
))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(alias=
)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dentry =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dentry =3D a=
lias;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +out:
> > + =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&cifs_root_mutex);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return dentry;
> > =C2=A0}
> > @@ -708,6 +712,7 @@ int cifs_readdir(struct file *file, void *diren=
try, filldir_t filldir)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *tmp_buf =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *end_of_smb;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int max_len;
> > + =C2=A0 =C2=A0 =C2=A0 ino_t ino;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> >
> > @@ -732,8 +737,12 @@ int cifs_readdir(struct file *file, void *dire=
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

(cc'ing fsdevel since I think we could use more eyes on this scheme)

I'm not a big fan of this patch. It seems to me that this assumes that
it's ok to have a dentry with a negative dentry as a parent. That makes
no sense though. Anegative dentry is the result of a lookup that
returned the equivalent of -ENOENT. I'm very reticent to play that sort
of game with the dcache code...

What may be better is to do something like this:

Go ahead and instantiate positive dentries from the root of the share
to the root of the vfsmount. However, we would mark those inodes as
"placeholders" and give them a bogus inode number of some sort (maybe
even 0?).

If we end up coming across a dentry with a placeholder d_inode later,
the we'd fetch the inode info and, we could remove and reinsert the
inode into the inode hashtable with the proper inode number.

Another idea might be to keep the root dentry of the mount as a
disconnected root dentry, and then try to graft it into a "parent
mount's" tree later if you end up coming across it from another
vfsmount that contains it. That seems a little trickier to handle
though.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
