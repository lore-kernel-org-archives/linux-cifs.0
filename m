From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Wed, 31 Aug 2011 21:35:39 +0400
Message-ID: <CAKywueSy2tFQC4mxOBZYjiY=PyLjUZ44v+qvtNNg+zKoxJmeCw@mail.gmail.com>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A@mail.gmail.com>
	<20110830085935.71e671e4@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110830085935.71e671e4-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 30 Aug 2011 16:31:52 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/8/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
>> > Reorganize code and make it send qpath info request only for a ful=
l
>> > path (//server/share/prefixpath) rather than request for every pat=
h
>> > compoment. In this case we end up with negative dentries for all
>> > components except full one and we will instantiate them later if
>> > such a mount is requested.
>> >
>> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsfs.c =A0| =A0123 +++++++++++++++++++++++++++++++---=
-------------------
>> > =A0fs/cifs/cifsfs.h =A0| =A0 =A03 +-
>> > =A0fs/cifs/inode.c =A0 | =A0 =A07 ++-
>> > =A0fs/cifs/readdir.c | =A0 =A09 +++-
>> > =A04 files changed, 85 insertions(+), 57 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> > index 0435bb9..33a2e1e 100644
>> > --- a/fs/cifs/cifsfs.c
>> > +++ b/fs/cifs/cifsfs.c
>> > @@ -95,14 +95,13 @@ mempool_t *smb2_mid_poolp;
>> > =A0static struct kmem_cache *smb2_mid_cachep;
>> > =A0#endif /* CONFIG_CIFS_SMB2 */
>> >
>> > -static int
>> > +static void
>> > =A0cifs_read_super(struct super_block *sb)
>> > =A0{
>> > - =A0 =A0 =A0 struct inode *inode;
>> > - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> > - =A0 =A0 =A0 int rc =3D 0;
>> > + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> >
>> > - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(sb);
>> > + =A0 =A0 =A0 /* BB should we make this contingent on mount parm? =
*/
>> > + =A0 =A0 =A0 sb->s_flags |=3D MS_NODIRATIME | MS_NOATIME;
>> >
>> > =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_flags |=3D MS_POSIXACL;
>> > @@ -120,26 +119,6 @@ cifs_read_super(struct super_block *sb)
>> > =A0 =A0 =A0 =A0sb->s_bdi =3D &cifs_sb->bdi;
>> > =A0 =A0 =A0 =A0sb->s_blocksize =3D CIFS_MAX_MSGSIZE;
>> > =A0 =A0 =A0 =A0sb->s_blocksize_bits =3D 14; =A0 =A0 =A0/* default =
2**14 =3D CIFS_MAX_MSGSIZE */
>> > - =A0 =A0 =A0 inode =3D cifs_root_iget(sb);
>> > -
>> > - =A0 =A0 =A0 if (IS_ERR(inode)) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(inode);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode =3D NULL;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_no_root;
>> > - =A0 =A0 =A0 }
>> > -
>> > - =A0 =A0 =A0 sb->s_root =3D d_alloc_root(inode);
>> > -
>> > - =A0 =A0 =A0 if (!sb->s_root) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_no_root;
>> > - =A0 =A0 =A0 }
>> > -
>> > - =A0 =A0 =A0 /* do that *after* d_alloc_root() - we want NULL ->d=
_op for root here */
>> > - =A0 =A0 =A0 if (cifs_sb_master_tcon(cifs_sb)->nocase)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_d_op =3D &cifs_ci_dentry_ops;
>> > - =A0 =A0 =A0 else
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_d_op =3D &cifs_dentry_ops;
>> >
>> > =A0#ifdef CIFS_NFSD_EXPORT
>> > =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INU=
M) {
>> > @@ -148,14 +127,7 @@ cifs_read_super(struct super_block *sb)
>> > =A0 =A0 =A0 =A0}
>> > =A0#endif /* CIFS_NFSD_EXPORT */
>> >
>> > - =A0 =A0 =A0 return 0;
>> > -
>> > -out_no_root:
>> > - =A0 =A0 =A0 cERROR(1, "cifs_read_super: get root inode failed");
>> > - =A0 =A0 =A0 if (inode)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iput(inode);
>> > -
>> > - =A0 =A0 =A0 return rc;
>> > + =A0 =A0 =A0 sb->s_flags |=3D MS_ACTIVE;
>> > =A0}
>> >
>> > =A0static void cifs_kill_sb(struct super_block *sb)
>> > @@ -529,6 +501,17 @@ static const struct super_operations cifs_sup=
er_ops =3D {
>> > =A0#endif
>> > =A0};
>> >
>> > +static struct dentry *
>> > +cifs_alloc_root(struct super_block *sb)
>> > +{
>> > + =A0 =A0 =A0 struct qstr q;
>> > +
>> > + =A0 =A0 =A0 q.name =3D "/";
>> > + =A0 =A0 =A0 q.len =3D 1;
>> > + =A0 =A0 =A0 q.hash =3D full_name_hash(q.name, q.len);
>> > + =A0 =A0 =A0 return d_alloc_pseudo(sb, &q);
>> > +}
>> > +
>> > =A0/*
>> > =A0* Get root dentry from superblock according to prefix path moun=
t option.
>> > =A0* Return dentry with refcount + 1 on success and NULL otherwise=
=2E
>> > @@ -536,8 +519,10 @@ static const struct super_operations cifs_sup=
er_ops =3D {
>> > =A0static struct dentry *
>> > =A0cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>> > =A0{
>> > - =A0 =A0 =A0 struct dentry *dentry;
>> > + =A0 =A0 =A0 struct dentry *dentry, *found;
>> > + =A0 =A0 =A0 struct inode *inode;
>> > =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> > + =A0 =A0 =A0 struct qstr q;
>> > =A0 =A0 =A0 =A0char *full_path =3D NULL;
>> > =A0 =A0 =A0 =A0char *s, *p;
>> > =A0 =A0 =A0 =A0char sep;
>> > @@ -550,13 +535,29 @@ cifs_get_root(struct smb_vol *vol, struct su=
per_block *sb)
>> >
>> > =A0 =A0 =A0 =A0cFYI(1, "Get root dentry for %s", full_path);
>> >
>> > + =A0 =A0 =A0 if (!sb->s_root) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_root =3D cifs_alloc_root(sb);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(sb->s_root)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D ERR_PTR(-=
ENOMEM);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* do that *after* cifs_alloc_root=
() - we want NULL ->d_op for
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* root here
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb_master_tcon(cifs_sb)->no=
case)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_d_op =3D &cifs=
_ci_dentry_ops;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_d_op =3D &cifs=
_dentry_ops;
>> > + =A0 =A0 =A0 }
>> > +
>> > =A0 =A0 =A0 =A0xid =3D GetXid();
>> > =A0 =A0 =A0 =A0sep =3D CIFS_DIR_SEP(cifs_sb);
>> > =A0 =A0 =A0 =A0dentry =3D dget(sb->s_root);
>> > =A0 =A0 =A0 =A0p =3D s =3D full_path;
>> >
>> > =A0 =A0 =A0 =A0do {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *dir =3D dentry->d_inod=
e;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *child;
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* skip separators */
>> > @@ -569,16 +570,45 @@ cifs_get_root(struct smb_vol *vol, struct su=
per_block *sb)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while (*s && *s !=3D sep)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s++;
>> >
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&dir->i_mutex);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 child =3D lookup_one_len(p, dentry, =
s - p);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&dir->i_mutex);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 q.name =3D p;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 q.len =3D s - p;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dentry->d_flags & DCACHE_OP_HASH=
)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry->d_op->d_hash=
(dentry, dentry->d_inode, &q);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 q.hash =3D full_name=
_hash(q.name, q.len);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 child =3D d_lookup(dentry, &q);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!child) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 child =3D d_alloc(de=
ntry, &q);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(child)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput=
(dentry);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dent=
ry =3D ERR_CAST(child);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brea=
k;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_rehash(child);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dput(dentry);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dentry =3D child;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dentry->d_inode) {
>> > + =A0 =A0 =A0 } while (!IS_ERR(dentry));
>> > +
>> > + =A0 =A0 =A0 if (IS_ERR(dentry))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > +
>> > + =A0 =A0 =A0 if (!dentry->d_inode) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode =3D cifs_mntroot_iget(sb, full=
_path);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(inode)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dput(dentry);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D ERR_PTR(-=
ENOENT);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D ERR_CAST(=
inode);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> > - =A0 =A0 =A0 } while (!IS_ERR(dentry));
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 found =3D d_instantiate_unique(dentr=
y, inode);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (found) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dentry);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D dget(foun=
d);
>>
>> it seems like found dentry has been already got by
>> d_instantiate_unique - we don't need to call dget again here
>>
>
> That sounds right.
>
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 }
>>
>> also, I think that if (!dentry->d_inode) {} statement should be
>> protected by a lock (mutex) - I am not sure should we create new loc=
k
>> for this or use existing one. What d you think about it?
>>
>
> I guess you're worried about the dentry suddenly becoming negative
> after checking for it? If you have an active reference to it, then
> that shouldn't occur. See d_delete().
>

No, I mean the following situation:
1) process1 gets a dentry and comes into if (!dentry->d_inode) {}
2) process2 gets the same dentry and comes into if {} too (because
dentry is still negative).
3) process1 gets a new inode
4) process2 gets a new inode (e.g. it doesn't get an inode created by
process1 in noserverino case)
5) denty is instantiated twice - wrong!

if we protect if statement with a mutex - it won't happen. Should we
create extra one for this?

>> > +out:
>> > =A0 =A0 =A0 =A0_FreeXid(xid);
>> > =A0 =A0 =A0 =A0kfree(full_path);
>> > =A0 =A0 =A0 =A0return dentry;
>> > @@ -646,16 +676,7 @@ cifs_do_mount(struct file_system_type *fs_typ=
e,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_umount(cifs_sb);
>> > =A0 =A0 =A0 =A0} else {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_flags =3D flags;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB should we make this contingent=
 on mount parm? */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_flags |=3D MS_NODIRATIME | MS_=
NOATIME;
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_read_super(sb);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_PTR(rc)=
;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_super;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_flags |=3D MS_ACTIVE;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_read_super(sb);
>> > =A0 =A0 =A0 =A0}
>> >
>> > =A0 =A0 =A0 =A0root =3D cifs_get_root(volume_info, sb);
>> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> > index 3145c18..47d9ec9 100644
>> > --- a/fs/cifs/cifsfs.h
>> > +++ b/fs/cifs/cifsfs.h
>> > @@ -43,7 +43,8 @@ extern const struct address_space_operations cif=
s_addr_ops_smallbuf;
>> >
>> > =A0/* Functions related to inodes */
>> > =A0extern const struct inode_operations cifs_dir_inode_ops;
>> > -extern struct inode *cifs_root_iget(struct super_block *);
>> > +extern struct inode *cifs_mntroot_iget(struct super_block *sb,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0const char *full_path);
>> > =A0extern int cifs_create(struct inode *, struct dentry *, int,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nameidata *);
>> > =A0extern struct dentry *cifs_lookup(struct inode *, struct dentry=
 *,
>> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> > index aee0c0b..dedfed3 100644
>> > --- a/fs/cifs/inode.c
>> > +++ b/fs/cifs/inode.c
>> > @@ -931,7 +931,7 @@ retry_iget5_locked:
>> > =A0}
>> >
>> > =A0/* gets root inode */
>> > -struct inode *cifs_root_iget(struct super_block *sb)
>> > +struct inode *cifs_mntroot_iget(struct super_block *sb, const cha=
r *full_path)
>> > =A0{
>> > =A0 =A0 =A0 =A0int xid;
>> > =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> > @@ -941,9 +941,10 @@ struct inode *cifs_root_iget(struct super_blo=
ck *sb)
>> >
>> > =A0 =A0 =A0 =A0xid =3D GetXid();
>> > =A0 =A0 =A0 =A0if (tcon->unix_ext)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&ino=
de, "", sb, xid);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&ino=
de, full_path, sb, xid);
>> > =A0 =A0 =A0 =A0else
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, "=
", NULL, sb, xid, NULL);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, f=
ull_path, NULL, sb, xid,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0NULL);
>> >
>> > =A0 =A0 =A0 =A0if (!inode) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode =3D ERR_PTR(rc);
>> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
>> > index 75e8b5c..7475cba 100644
>> > --- a/fs/cifs/readdir.c
>> > +++ b/fs/cifs/readdir.c
>> > @@ -708,6 +708,7 @@ int cifs_readdir(struct file *file, void *dire=
ntry, filldir_t filldir)
>> > =A0 =A0 =A0 =A0char *tmp_buf =3D NULL;
>> > =A0 =A0 =A0 =A0char *end_of_smb;
>> > =A0 =A0 =A0 =A0unsigned int max_len;
>> > + =A0 =A0 =A0 ino_t ino;
>> >
>> > =A0 =A0 =A0 =A0xid =3D GetXid();
>> >
>> > @@ -732,8 +733,12 @@ int cifs_readdir(struct file *file, void *dir=
entry, filldir_t filldir)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->f_pos++;
>> > =A0 =A0 =A0 =A0case 1:
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (filldir(direntry, "..", 2, file-=
>f_pos,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent_ino(file->f_path.d=
entry), DT_DIR) < 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!file->f_path.dentry->d_parent->=
d_inode) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "parent dir =
is negative, filling as current");
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ino =3D file->f_path=
=2Edentry->d_inode->i_ino;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ino =3D parent_ino(f=
ile->f_path.dentry);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (filldir(direntry, "..", 2, file-=
>f_pos, ino, DT_DIR) < 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Filldir =
for parent dir failed");
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> > --
>> > 1.7.1
>> >
>> >
>>
>>
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
