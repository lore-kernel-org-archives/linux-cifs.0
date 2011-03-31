From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for
 cifs_invalidate_mapping (try #3)
Date: Wed, 30 Mar 2011 20:40:24 -0400
Message-ID: <20110330204024.01d9a986@corrin.poochiereds.net>
References: <1301336153-10193-1-git-send-email-piastry@etersoft.ru>
	<20110330165522.5fc6dc1c@tlielax.poochiereds.net>
	<AANLkTik8EWOj5TOaEjwwm760mM670E7PK4QZOTNBBfiN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik8EWOj5TOaEjwwm760mM670E7PK4QZOTNBBfiN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 30 Mar 2011 16:06:11 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Mar 30, 2011 at 3:55 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 28 Mar 2011 22:15:53 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Base of approach for splitting all calls that uses cifs_invalidate=
_mapping
> >> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
> >> 1) aware about -EBUSY error code and report it back (cifs_d_revali=
date,
> >> cifs_file_strict_mmap);
> >> 2) don't do it (cifs_getattrs, cifs_strict_fsync, cifs_lseek).
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsfs.c | =C2=A0 =C2=A08 +++++++-
> >> =C2=A0fs/cifs/cifsfs.h | =C2=A0 =C2=A02 +-
> >> =C2=A0fs/cifs/file.c =C2=A0 | =C2=A0 24 ++++++++++++++++++++----
> >> =C2=A0fs/cifs/inode.c =C2=A0| =C2=A0 23 ++++++++++++++++-------
> >> =C2=A04 files changed, 44 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index de49fbb..b76d992 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -634,7 +634,13 @@ static loff_t cifs_llseek(struct file *file, =
loff_t offset, int origin)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_I(file->f_pa=
th.dentry->d_inode)->time =3D 0;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retval =3D cifs_r=
evalidate_file(file);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retval < 0)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We only need t=
o get right file length and should not aware
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* about busy pag=
es (-EBUSY error code).
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retval =3D=3D -EBU=
SY)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 retval =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (retval < 0)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return (loff_t)retval;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 return generic_file_llseek_unlocked(file, off=
set, origin);
> >> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> >> index bb64313..f4391ff 100644
> >> --- a/fs/cifs/cifsfs.h
> >> +++ b/fs/cifs/cifsfs.h
> >> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct de=
ntry *, struct inode *,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0struct dentry *);
> >> =C2=A0extern int cifs_revalidate_file(struct file *filp);
> >> =C2=A0extern int cifs_revalidate_dentry(struct dentry *);
> >> -extern void cifs_invalidate_mapping(struct inode *inode);
> >> +extern int cifs_invalidate_mapping(struct inode *inode);
> >> =C2=A0extern int cifs_getattr(struct vfsmount *, struct dentry *, =
struct kstat *);
> >> =C2=A0extern int cifs_setattr(struct dentry *, struct iattr *);
> >>
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index b9731c9..329081f 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1448,8 +1448,19 @@ int cifs_strict_fsync(struct file *file, in=
t datasync)
> >> =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Sync file - name: %s datasync: 0x%x"=
,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 file->f_path.dent=
ry->d_name.name, datasync);
> >>
> >> - =C2=A0 =C2=A0 if (!CIFS_I(inode)->clientCanCacheRead)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_invalidate_mappin=
g(inode);
> >> + =C2=A0 =C2=A0 if (!CIFS_I(inode)->clientCanCacheRead) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_invalidate=
_mapping(inode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We only need t=
o flush all dirty pages and should not aware
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* if some of the=
m are busy (-EBUSY error code).
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D -EBUSY)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 FreeXid(xid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return rc;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 tcon =3D tlink_tcon(smbfile->tlink);
> >> =C2=A0 =C2=A0 =C2=A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO=
SSYNC))
> >> @@ -1916,8 +1927,13 @@ int cifs_file_strict_mmap(struct file *file=
, struct vm_area_struct *vma)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 xid =3D GetXid();
> >>
> >> - =C2=A0 =C2=A0 if (!CIFS_I(inode)->clientCanCacheRead)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_invalidate_mappin=
g(inode);
> >> + =C2=A0 =C2=A0 if (!CIFS_I(inode)->clientCanCacheRead) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_invalidate=
_mapping(inode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 FreeXid(xid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return rc;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D generic_file_mmap(file, vma);
> >> =C2=A0 =C2=A0 =C2=A0 FreeXid(xid);
> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> index adb6324..7b3a078 100644
> >> --- a/fs/cifs/inode.c
> >> +++ b/fs/cifs/inode.c
> >> @@ -1683,10 +1683,10 @@ cifs_inode_needs_reval(struct inode *inode=
)
> >> =C2=A0/*
> >> =C2=A0 * Zap the cache. Called when invalid_mapping flag is set.
> >> =C2=A0 */
> >> -void
> >> +int
> >> =C2=A0cifs_invalidate_mapping(struct inode *inode)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 int rc;
> >> + =C2=A0 =C2=A0 int rc =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 struct cifsInodeInfo *cifs_i =3D CIFS_I(inode=
);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cifs_i->invalid_mapping =3D false;
> >> @@ -1697,13 +1697,14 @@ cifs_invalidate_mapping(struct inode *inod=
e)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping_set_error=
(inode->i_mapping, rc);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D invalidate=
_inode_pages2(inode->i_mapping);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cERROR(1, "%s: could not invalidate inode %p", __func__,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cFYI(1, "%s: could not invalidate inode %p", __func__,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0inode);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_i->invalid_mapping =3D true;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cifs_fscache_reset_inode_cookie(inode);
> >> + =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >>
> >> =C2=A0int cifs_revalidate_file(struct file *filp)
> >> @@ -1722,7 +1723,7 @@ int cifs_revalidate_file(struct file *filp)
> >>
> >> =C2=A0check_inval:
> >> =C2=A0 =C2=A0 =C2=A0 if (CIFS_I(inode)->invalid_mapping)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_invalidate_mappin=
g(inode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_invalidate=
_mapping(inode);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >> @@ -1764,7 +1765,7 @@ int cifs_revalidate_dentry(struct dentry *de=
ntry)
> >>
> >> =C2=A0check_inval:
> >> =C2=A0 =C2=A0 =C2=A0 if (CIFS_I(inode)->invalid_mapping)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_invalidate_mappin=
g(inode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_invalidate=
_mapping(inode);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 kfree(full_path);
> >> =C2=A0 =C2=A0 =C2=A0 FreeXid(xid);
> >> @@ -1776,7 +1777,15 @@ int cifs_getattr(struct vfsmount *mnt, stru=
ct dentry *dentry,
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dent=
ry->d_sb);
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon =3D cifs_sb_master_tco=
n(cifs_sb);
> >> - =C2=A0 =C2=A0 int err =3D cifs_revalidate_dentry(dentry);
> >> + =C2=A0 =C2=A0 int err;
> >> +
> >> + =C2=A0 =C2=A0 err =3D cifs_revalidate_dentry(dentry);
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* We only need to get inode attributes and s=
hould not aware about busy
> >> + =C2=A0 =C2=A0 =C2=A0* pages (-EBUSY error code).
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 if (err =3D=3D -EBUSY)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D 0;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (!err) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 generic_fillattr(=
dentry->d_inode, stat);
> >
> > I really dislike this special casing for EBUSY. That seems like a r=
eal
> > red flag that this is the wrong approach.
> >
> > I think the right solution will involve implementing a launder_page
> > operation. With that you shouldn't ever get an EBUSY as long as the
> > launder_page succeeds. If it doesn't then you probably want to retu=
rn
> > an error in the above cases anyway.
>=20
> I am not convinced that launder page is needed (it might make it
> easier but hard to tell)

=46rom invalidate_inode_pages2_range:

---------------[snip]--------------------
	BUG_ON(page_mapped(page));
	ret2 =3D do_launder_page(mapping, page);
	if (ret2 =3D=3D 0) {
		if (!invalidate_complete_page2(mapping, page))
			ret2 =3D -EBUSY;
	}
---------------[snip]--------------------

=2E..when the above code runs, the page is locked. It can't be mapped
into anyone's page tables until it's unlocked. So, we launder the page
(basically, write it out), and then invalidate it. CIFS doesn't use
PagePrivate, and after launder_page it should be clean. So
invalidate_complete_page2 should then work -- no EBUSY.

The only catch is that launder_page can fail and you do have to deal
with that case.

> but I agree that special casing one
> rc out of:
>=20
>                rc =3D invalidate_inode_pages2(inode->i_mapping);
>=20
> is odd.   Seems like the problem is that some callers of
> invalidate_mapping don't care about the rc, some care
> about the rc from filemap_fdatawrite so they can return
> write errors (disk full, server down etc.) to the user and
> some may even care whether all pages are freed
> this time around (ie whether invalidate_inode_page2
> partially vs. totally succeeded).
>=20

Yes. Perhaps it's time to consider breaking up cifs_invalidate_mapping.

The function made sense when we didn't have to worry about the return
code from invalidate_remote_inode, but I don't think we can just drop
invalidate_inode_pages2 in its place trivially like this without making
a mess.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
