From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for
 cifs_invalidate_mapping
Date: Fri, 25 Mar 2011 16:36:46 -0400
Message-ID: <20110325163646.3310868b@tlielax.poochiereds.net>
References: <1300977587-8218-1-git-send-email-piastry@etersoft.ru>
	<20110324171536.36fbc94f@tlielax.poochiereds.net>
	<AANLkTinnQXjDfJ6yghEmKarXNFqbwk-YVc4ew9coUiii@mail.gmail.com>
	<20110325073136.69c09d6b@tlielax.poochiereds.net>
	<AANLkTinpSkDgZNu47srSKkBPo8EUYxTbtAEYgPTE43+e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinpSkDgZNu47srSKkBPo8EUYxTbtAEYgPTE43+e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Mar 2011 22:47:23 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/3/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Fri, 25 Mar 2011 07:56:07 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> 2011/3/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> > On Thu, 24 Mar 2011 17:39:47 +0300
> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >> >
> >> >> Base of approach for splitting all calls that uses cifs_invalid=
ate_mapping
> >> >> (or cifs_revalidate_dentry, cifs_revalidate_file) into two grou=
ps:
> >> >> 1) aware about -EBUSY error code and report it back (cifs_d_rev=
alidate,
> >> >> cifs_strict_fsync, cifs_file_strict_mmap);
> >> >> 2) don't do it (cifs_getattrs, cifs_lseek).
> >> >>
> >> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> >> ---
> >> >> =C2=A0fs/cifs/cifsfs.c | =C2=A0 =C2=A08 +++++++-
> >> >> =C2=A0fs/cifs/cifsfs.h | =C2=A0 =C2=A02 +-
> >> >> =C2=A0fs/cifs/file.c =C2=A0 | =C2=A0 18 ++++++++++++++----
> >> >> =C2=A0fs/cifs/inode.c =C2=A0| =C2=A0 30 ++++++++++++++++++-----=
-------
> >> >> =C2=A04 files changed, 40 insertions(+), 18 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> >> index de49fbb..b275d76 100644
> >> >> --- a/fs/cifs/cifsfs.c
> >> >> +++ b/fs/cifs/cifsfs.c
> >> >> @@ -634,7 +634,13 @@ static loff_t cifs_llseek(struct file *fil=
e, loff_t offset, int origin)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_I(file->f=
_path.dentry->d_inode)->time =3D 0;
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retval =3D cif=
s_revalidate_file(file);
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retval < 0)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We only nee=
d to get right file length and don't need to
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* aware about=
 busy pages (-EBUSY error code).
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retval =3D=3D -=
EBUSY)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 retval =3D 0;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (retval < 0=
)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 return (loff_t)retval;
> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >> =C2=A0 =C2=A0 =C2=A0 return generic_file_llseek_unlocked(file, =
offset, origin);
> >> >> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> >> >> index bb64313..f4391ff 100644
> >> >> --- a/fs/cifs/cifsfs.h
> >> >> +++ b/fs/cifs/cifsfs.h
> >> >> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct=
 dentry *, struct inode *,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct dentry *);
> >> >> =C2=A0extern int cifs_revalidate_file(struct file *filp);
> >> >> =C2=A0extern int cifs_revalidate_dentry(struct dentry *);
> >> >> -extern void cifs_invalidate_mapping(struct inode *inode);
> >> >> +extern int cifs_invalidate_mapping(struct inode *inode);
> >> >> =C2=A0extern int cifs_getattr(struct vfsmount *, struct dentry =
*, struct kstat *);
> >> >> =C2=A0extern int cifs_setattr(struct dentry *, struct iattr *);
> >> >>
> >> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> >> index b9731c9..d99cf48 100644
> >> >> --- a/fs/cifs/file.c
> >> >> +++ b/fs/cifs/file.c
> >> >> @@ -1448,8 +1448,13 @@ int cifs_strict_fsync(struct file *file,=
 int datasync)
> >> >> =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Sync file - name: %s datasync: 0x=
%x",
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 file->f_path.d=
entry->d_name.name, datasync);
> >> >>
> >> >> - =C2=A0 =C2=A0 if (!CIFS_I(inode)->clientCanCacheRead)
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_invalidate_map=
ping(inode);
> >> >> + =C2=A0 =C2=A0 if (!CIFS_I(inode)->clientCanCacheRead) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_invalid=
ate_mapping(inode);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 FreeXid(xid);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return rc;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> >> + =C2=A0 =C2=A0 }
> >> >>
> >> >
> >> > Hmm...this put us in danger of reporting writeback errors twice?=
 Note
> >> > that cifs_invalidate_mapping resets the error on the mapping if
> >> > writeback fails. So imagine:
> >> >
> >> > t1: do the regular filemap_write_and_wait in vfs_fsync
> >> > t2: another thread dirties pages on the inode
> >> > t1: call cifs_invalidate_mapping which does filemap_write_and_wa=
it.
> >> > =C2=A0 =C2=A0That fails, so fsync returns an error.
> >> > t2: now it does an fsync and the error is reported again
> >>
> >> why does the last line report the error again? what does it preven=
t to
> >> return OK?
> >>
> >
> > cifs_invalidate_inode does this:
> >
> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D filem=
ap_write_and_wait(inode->i_mapping);
> > =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping_set_=
error(inode->i_mapping, rc);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D invalidate_=
inode_pages2(inode->i_mapping);
> >
> >
> > ...if there's an error on writeback, it'll reset that error on the
> > mapping to make sure we can report it later. However, I was
> > mistaken...this patch doesn't report any writeback errors here, jus=
t
> > ones on invalidation, so it may be ok.
> >
> > I wonder though...would it be less racy to set up a launder_page
> > function for CIFS and just call invalidate_inode_pages2 here withou=
t
> > the filemap_write_and_wait?
> >
>=20
> It can make sense but I think that it should be a separate patch. If
> everything is ok excepts things you commented I can provide the next
> version of the patch.
>=20

That's seems reasonable.
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
