From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
Date: Fri, 25 Mar 2011 22:47:23 +0300
Message-ID: <AANLkTinpSkDgZNu47srSKkBPo8EUYxTbtAEYgPTE43+e@mail.gmail.com>
References: <1300977587-8218-1-git-send-email-piastry@etersoft.ru>
	<20110324171536.36fbc94f@tlielax.poochiereds.net>
	<AANLkTinnQXjDfJ6yghEmKarXNFqbwk-YVc4ew9coUiii@mail.gmail.com>
	<20110325073136.69c09d6b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110325073136.69c09d6b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 25 Mar 2011 07:56:07 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/3/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > On Thu, 24 Mar 2011 17:39:47 +0300
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Base of approach for splitting all calls that uses cifs_invalidat=
e_mapping
>> >> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups=
:
>> >> 1) aware about -EBUSY error code and report it back (cifs_d_reval=
idate,
>> >> cifs_strict_fsync, cifs_file_strict_mmap);
>> >> 2) don't do it (cifs_getattrs, cifs_lseek).
>> >>
>> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/cifsfs.c | =A0 =A08 +++++++-
>> >> =A0fs/cifs/cifsfs.h | =A0 =A02 +-
>> >> =A0fs/cifs/file.c =A0 | =A0 18 ++++++++++++++----
>> >> =A0fs/cifs/inode.c =A0| =A0 30 ++++++++++++++++++------------
>> >> =A04 files changed, 40 insertions(+), 18 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> >> index de49fbb..b275d76 100644
>> >> --- a/fs/cifs/cifsfs.c
>> >> +++ b/fs/cifs/cifsfs.c
>> >> @@ -634,7 +634,13 @@ static loff_t cifs_llseek(struct file *file,=
 loff_t offset, int origin)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(file->f_path.dentry->d_inode)-=
>time =3D 0;
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file(file)=
;
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* We only need to get right file len=
gth and don't need to
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* aware about busy pages (-EBUSY err=
or code).
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval =3D=3D -EBUSY)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D 0;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 else if (retval < 0)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)retval=
;
>> >> =A0 =A0 =A0 }
>> >> =A0 =A0 =A0 return generic_file_llseek_unlocked(file, offset, ori=
gin);
>> >> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> >> index bb64313..f4391ff 100644
>> >> --- a/fs/cifs/cifsfs.h
>> >> +++ b/fs/cifs/cifsfs.h
>> >> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct d=
entry *, struct inode *,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *);
>> >> =A0extern int cifs_revalidate_file(struct file *filp);
>> >> =A0extern int cifs_revalidate_dentry(struct dentry *);
>> >> -extern void cifs_invalidate_mapping(struct inode *inode);
>> >> +extern int cifs_invalidate_mapping(struct inode *inode);
>> >> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, st=
ruct kstat *);
>> >> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
>> >>
>> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> >> index b9731c9..d99cf48 100644
>> >> --- a/fs/cifs/file.c
>> >> +++ b/fs/cifs/file.c
>> >> @@ -1448,8 +1448,13 @@ int cifs_strict_fsync(struct file *file, i=
nt datasync)
>> >> =A0 =A0 =A0 cFYI(1, "Sync file - name: %s datasync: 0x%x",
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 file->f_path.dentry->d_name.name, dat=
async);
>> >>
>> >> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> >> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 }
>> >>
>> >
>> > Hmm...this put us in danger of reporting writeback errors twice? N=
ote
>> > that cifs_invalidate_mapping resets the error on the mapping if
>> > writeback fails. So imagine:
>> >
>> > t1: do the regular filemap_write_and_wait in vfs_fsync
>> > t2: another thread dirties pages on the inode
>> > t1: call cifs_invalidate_mapping which does filemap_write_and_wait=
=2E
>> > =A0 =A0That fails, so fsync returns an error.
>> > t2: now it does an fsync and the error is reported again
>>
>> why does the last line report the error again? what does it prevent =
to
>> return OK?
>>
>
> cifs_invalidate_inode does this:
>
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i=
_mapping);
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i_m=
apping);
>
>
> ...if there's an error on writeback, it'll reset that error on the
> mapping to make sure we can report it later. However, I was
> mistaken...this patch doesn't report any writeback errors here, just
> ones on invalidation, so it may be ok.
>
> I wonder though...would it be less racy to set up a launder_page
> function for CIFS and just call invalidate_inode_pages2 here without
> the filemap_write_and_wait?
>

It can make sense but I think that it should be a separate patch. If
everything is ok excepts things you commented I can provide the next
version of the patch.

--=20
Best regards,
Pavel Shilovsky.
