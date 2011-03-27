From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
 (try #2)
Date: Sun, 27 Mar 2011 09:55:03 -0500
Message-ID: <AANLkTimOx-P95k-Jvg_ESiYii7bd7RzWYpjxQnkvAf7k@mail.gmail.com>
References: <1301127285-3573-1-git-send-email-piastry@etersoft.ru>
	<20110327064857.6fc346f0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110327064857.6fc346f0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Mar 27, 2011 at 5:48 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sat, 26 Mar 2011 11:14:45 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Base of approach for splitting all calls that uses cifs_invalidate_m=
apping
>> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
>> 1) aware about -EBUSY error code and report it back (cifs_d_revalida=
te,
>> cifs_strict_fsync, cifs_file_strict_mmap);
>> 2) don't do it (cifs_getattrs, cifs_lseek).
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 =A08 +++++++-
>> =A0fs/cifs/cifsfs.h | =A0 =A02 +-
>> =A0fs/cifs/file.c =A0 | =A0 18 ++++++++++++++----
>> =A0fs/cifs/inode.c =A0| =A0 23 ++++++++++++++++-------
>> =A04 files changed, 38 insertions(+), 13 deletions(-)
>>
>
> -----------------[snip]---------------------
>
>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> index bb64313..f4391ff 100644
>> --- a/fs/cifs/cifsfs.h
>> +++ b/fs/cifs/cifsfs.h
>> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct dent=
ry *, struct inode *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *);
>> =A0extern int cifs_revalidate_file(struct file *filp);
>> =A0extern int cifs_revalidate_dentry(struct dentry *);
>> -extern void cifs_invalidate_mapping(struct inode *inode);
>> +extern int cifs_invalidate_mapping(struct inode *inode);
>> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, struc=
t kstat *);
>> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index b9731c9..d99cf48 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1448,8 +1448,13 @@ int cifs_strict_fsync(struct file *file, int =
datasync)
>> =A0 =A0 =A0 cFYI(1, "Sync file - name: %s datasync: 0x%x",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 file->f_path.dentry->d_name.name, datasy=
nc);
>>
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>
> Now that I've had some more time to think on this patch, I don't thin=
k
> this is what we want at all. The problem in a nutshell is that an -EB=
USY
> return makes no sense here.
>
> Suppose I run fsync() on a file, and everything is written out
> successfully, but some page is redirtied in the meantime and can't be
> invalidated. This then returns -EBUSY, but why should the task doing =
the
> fsync care that the pages can't be invalidated? It shouldn't, AFAICT.
> The thread getting the -EBUSY ought to be the one that next attempts =
to
> access the page.

you are right. it doesn't care about EBUSY, that the filemap_fdatawrite=
*
succeeds is more important.   But the next thread that
accesses the range may need to recognize that invalid_mapping =3D true
though.  I thought Pavel said that the strict cache read was going
to be changed so it frees the mapping when the mapping is marked
invalid



--=20
Thanks,

Steve
