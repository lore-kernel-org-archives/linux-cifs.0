From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: cifs and win2k8
Date: Thu, 10 Nov 2011 17:38:39 +0400
Message-ID: <CAKywueS5zvSNapoyzCWSsFsXF=XeYbQLM=nMXgW3RUKRdagKyw@mail.gmail.com>
References: <20111024073534.GB7086@cobija.connexer.com>
	<1320171185-11150-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRjR+UNg98odoe8x2WmnqdiCtEa_UgwnKt-8AEi0XRFdQ@mail.gmail.com>
	<20111110082412.7ff860e6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111110082412.7ff860e6@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2011/11/10 Jeff Layton <jlayton@samba.org>:
> On Tue, 1 Nov 2011 22:56:18 +0300
> Pavel Shilovsky <piastry@etersoft.ru> wrote:
>
>> 2011/11/1 Pavel Shilovsky <piastry@etersoft.ru>:
>> > Sorry for so long delay on this. Here is the fixed version of the =
patch:
>> >
>> > [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with prefixpa=
th option
>> >
>> > but I found out one use case where it doesn't work right:
>> >
>> > 1) mount //server/share/a/b/ test
>> > 2) mount //server/share/ test2
>> > 3) stat test2/a/b - return wrong inode number (autodisable server =
inode number happens)
>> >
>> > In the same time if I add "ls test2" before step #3 it works! May =
be VFS can't
>> > handle negative dentry with children in this case, but I am not su=
re.
>> >
>> > Reorganize code and make it send qpath info request only for a ful=
l
>> > path (//server/share/prefixpath) rather than request for every pat=
h
>> > compoment. In this case we end up with negative dentries for all
>> > components except full one and we will instantiate them later if
>> > such a mount is requested.
>> >
>> > Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
>> > ---
>> > =A0fs/cifs/cifsfs.c =A0 | =A0138 +++++++++++++++++++++++++++++++--=
------------------
>> > =A0fs/cifs/cifsfs.h =A0 | =A0 =A03 +-
>> > =A0fs/cifs/cifsglob.h | =A0 =A06 ++
>> > =A0fs/cifs/dir.c =A0 =A0 =A0| =A0 =A03 +-
>> > =A0fs/cifs/inode.c =A0 =A0| =A0 =A07 ++-
>> > =A0fs/cifs/readdir.c =A0| =A0 43 ++++++++++------
>> > =A06 files changed, 124 insertions(+), 76 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> > index 8f1fe32..a188be1 100644
>> > --- a/fs/cifs/cifsfs.c
>> > +++ b/fs/cifs/cifsfs.c
>> > @@ -90,14 +90,13 @@ extern mempool_t *cifs_sm_req_poolp;
>> > =A0extern mempool_t *cifs_req_poolp;
>> > =A0extern mempool_t *cifs_mid_poolp;
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
>> > @@ -115,26 +114,6 @@ cifs_read_super(struct super_block *sb)
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
>> > =A0#ifdef CONFIG_CIFS_NFSD_EXPORT
>> > =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INU=
M) {
>> > @@ -143,14 +122,7 @@ cifs_read_super(struct super_block *sb)
>> > =A0 =A0 =A0 =A0}
>> > =A0#endif /* CONFIG_CIFS_NFSD_EXPORT */
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
>> > @@ -528,6 +500,17 @@ static const struct super_operations cifs_sup=
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
>> > @@ -535,8 +518,10 @@ static const struct super_operations cifs_sup=
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
>> > @@ -548,20 +533,30 @@ cifs_get_root(struct smb_vol *vol, struct su=
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
>> > =A0 =A0 =A0 =A0sep =3D CIFS_DIR_SEP(cifs_sb);
>> > =A0 =A0 =A0 =A0dentry =3D dget(sb->s_root);
>> > =A0 =A0 =A0 =A0p =3D s =3D full_path;
>> >
>> > =A0 =A0 =A0 =A0do {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *dir =3D dentry->d_inod=
e;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *child;
>> >
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dir) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dentry);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D ERR_PTR(-=
ENOENT);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > -
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* skip separators */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while (*s =3D=3D sep)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s++;
>> > @@ -572,12 +567,55 @@ cifs_get_root(struct smb_vol *vol, struct su=
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
>> > =A0 =A0 =A0 =A0} while (!IS_ERR(dentry));
>> > +
>> > + =A0 =A0 =A0 if (IS_ERR(dentry))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > +
>> > + =A0 =A0 =A0 mutex_lock(&cifs_root_mutex);
>> > +
>> > + =A0 =A0 =A0 if (dentry->d_parent->d_inode)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&dentry->d_parent->d_inod=
e->i_mutex);
>> > +
>> > + =A0 =A0 =A0 if (!dentry->d_inode) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode =3D cifs_mntroot_iget(sb, full=
_path);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(inode)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dentry);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D ERR_CAST(=
inode);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 found =3D d_instantiate_unique(dentr=
y, inode);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (found) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dentry);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D found;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 if (dentry->d_parent->d_inode)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&dentry->d_parent->d_in=
ode->i_mutex);
>> > +
>> > + =A0 =A0 =A0 mutex_unlock(&cifs_root_mutex);
>> > +out:
>> > =A0 =A0 =A0 =A0kfree(full_path);
>> > =A0 =A0 =A0 =A0return dentry;
>> > =A0}
>> > @@ -644,16 +682,7 @@ cifs_do_mount(struct file_system_type *fs_typ=
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
>> > @@ -1112,6 +1141,7 @@ init_cifs(void)
>> > =A0 =A0 =A0 =A0spin_lock_init(&cifs_tcp_ses_lock);
>> > =A0 =A0 =A0 =A0spin_lock_init(&cifs_file_list_lock);
>> > =A0 =A0 =A0 =A0spin_lock_init(&GlobalMid_Lock);
>> > + =A0 =A0 =A0 mutex_init(&cifs_root_mutex);
>> >
>> > =A0 =A0 =A0 =A0if (cifs_max_pending < 2) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_max_pending =3D 2;
>> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> > index 30ff560..cf28150 100644
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
>> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> > index 8238aa1..67f6852 100644
>> > --- a/fs/cifs/cifsglob.h
>> > +++ b/fs/cifs/cifsglob.h
>> > @@ -958,6 +958,12 @@ GLOBAL_EXTERN spinlock_t =A0 =A0 =A0 =A0 =A0 =
cifs_tcp_ses_lock;
>> > =A0*/
>> > =A0GLOBAL_EXTERN spinlock_t =A0 =A0 =A0 cifs_file_list_lock;
>> >
>> > +/*
>> > + * This lock protects root dentry in cifs_get_root from being ins=
tantiated
>> > + * twice.
>> > + */
>> > +GLOBAL_EXTERN struct mutex cifs_root_mutex;
>> > +
>> > =A0#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily *=
/
>> > =A0/* Outstanding dir notify requests */
>> > =A0GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
>> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> > index d7eeb9d..d6b3319 100644
>> > --- a/fs/cifs/dir.c
>> > +++ b/fs/cifs/dir.c
>> > @@ -553,6 +553,7 @@ cifs_lookup(struct inode *parent_dir_inode, st=
ruct dentry *direntry,
>> >
>> > =A0 =A0 =A0 =A0if (direntry->d_inode !=3D NULL) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "non-NULL inode in lookup")=
;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 newInode =3D direntry->d_inode;
>>
>> this and ...
>>
>> > =A0 =A0 =A0 =A0} else {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "NULL inode in lookup");
>> > =A0 =A0 =A0 =A0}
>> > @@ -596,7 +597,7 @@ cifs_lookup(struct inode *parent_dir_inode, st=
ruct dentry *direntry,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_info(&newInod=
e, full_path, NULL,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0par=
ent_dir_inode->i_sb, xid, NULL);
>> >
>> > - =A0 =A0 =A0 if ((rc =3D=3D 0) && (newInode !=3D NULL)) {
>> > + =A0 =A0 =A0 if ((rc =3D=3D 0) && (newInode !=3D NULL) && !dirent=
ry->d_inode) {
>>
>> ... this doesn't make sense - I made it for testing purpose only and
>> forgot to remove. Since this patch isn't going to be a candidate to
>> merge, seems no need to respin it.
>>
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0d_add(direntry, newInode);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (posix_open) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0filp =3D lookup_ins=
tantiate_filp(nd, direntry,
>> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> > index 2c50bd2..7b7fccd 100644
>> > --- a/fs/cifs/inode.c
>> > +++ b/fs/cifs/inode.c
>> > @@ -878,7 +878,7 @@ retry_iget5_locked:
>> > =A0}
>> >
>> > =A0/* gets root inode */
>> > -struct inode *cifs_root_iget(struct super_block *sb)
>> > +struct inode *cifs_mntroot_iget(struct super_block *sb, const cha=
r *full_path)
>> > =A0{
>> > =A0 =A0 =A0 =A0int xid;
>> > =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> > @@ -888,9 +888,10 @@ struct inode *cifs_root_iget(struct super_blo=
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
>> > index 5de03ec..b2f8851 100644
>> > --- a/fs/cifs/readdir.c
>> > +++ b/fs/cifs/readdir.c
>> > @@ -65,10 +65,8 @@ static inline void dump_cifs_file_struct(struct=
 file *file, char *label)
>> > =A0}
>> > =A0#endif /* DEBUG2 */
>> >
>> > -/*
>> > - * Find the dentry that matches "name". If there isn't one, creat=
e one. If it's
>> > - * a negative dentry or the uniqueid changed, then drop it and re=
create it.
>> > - */
>> > +
>> > +/* Find the dentry that matches "name". If there isn't one, creat=
e one. */
>> > =A0static struct dentry *
>> > =A0cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_fattr *fattr)
>> > @@ -84,32 +82,38 @@ cifs_readdir_lookup(struct dentry *parent, str=
uct qstr *name,
>> > =A0 =A0 =A0 =A0else
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0name->hash =3D full_name_hash(name-=
>name, name->len);
>> >
>> > + =A0 =A0 =A0 mutex_lock(&cifs_root_mutex);
>> > +
>> > =A0 =A0 =A0 =A0dentry =3D d_lookup(parent, name);
>> > =A0 =A0 =A0 =A0if (dentry) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* FIXME: check for inode number ch=
anges? */
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (dentry->d_inode !=3D NULL)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return dentry;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_drop(dentry);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dentry);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D d_alloc(parent, name);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dentry =3D=3D NULL)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_rehash(dentry);
>> > =A0 =A0 =A0 =A0}
>> >
>> > - =A0 =A0 =A0 dentry =3D d_alloc(parent, name);
>> > - =A0 =A0 =A0 if (dentry =3D=3D NULL)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> > -
>> > =A0 =A0 =A0 =A0inode =3D cifs_iget(sb, fattr);
>> > =A0 =A0 =A0 =A0if (!inode) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dput(dentry);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D NULL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > =A0 =A0 =A0 =A0}
>> >
>> > - =A0 =A0 =A0 alias =3D d_materialise_unique(dentry, inode);
>> > + =A0 =A0 =A0 alias =3D d_instantiate_unique(dentry, inode);
>> > =A0 =A0 =A0 =A0if (alias !=3D NULL) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dput(dentry);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(alias))
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(alias)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry =3D NULL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dentry =3D alias;
>> > =A0 =A0 =A0 =A0}
>> > +out:
>> > + =A0 =A0 =A0 mutex_unlock(&cifs_root_mutex);
>> >
>> > =A0 =A0 =A0 =A0return dentry;
>> > =A0}
>> > @@ -708,6 +712,7 @@ int cifs_readdir(struct file *file, void *dire=
ntry, filldir_t filldir)
>> > =A0 =A0 =A0 =A0char *tmp_buf =3D NULL;
>> > =A0 =A0 =A0 =A0char *end_of_smb;
>> > =A0 =A0 =A0 =A0unsigned int max_len;
>> > + =A0 =A0 =A0 ino_t ino;
>> >
>> > =A0 =A0 =A0 =A0xid =3D GetXid();
>> >
>> > @@ -732,8 +737,12 @@ int cifs_readdir(struct file *file, void *dir=
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
> (cc'ing fsdevel since I think we could use more eyes on this scheme)
>
> I'm not a big fan of this patch. It seems to me that this assumes tha=
t
> it's ok to have a dentry with a negative dentry as a parent. That mak=
es
> no sense though. Anegative dentry is the result of a lookup that
> returned the equivalent of -ENOENT. I'm very reticent to play that so=
rt
> of game with the dcache code...
>

Jeff, now I agree with you that keeping negative dentries with
childrens is not a good idea. That really breaks some VFS assumptions.

> What may be better is to do something like this:
>
> Go ahead and instantiate positive dentries from the root of the share
> to the root of the vfsmount. However, we would mark those inodes as
> "placeholders" and give them a bogus inode number of some sort (maybe
> even 0?).
>

Yes, I was thinking about this approach too but didn't have enough
time to prototype it. It seems easier to implement than the second one
but now I don't imagine what problems we can faced with going this
way.

--=20
Best regards,
Pavel Shilovsky.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
