From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] CIFS: New write logic
Date: Tue, 26 Oct 2010 21:49:33 +0400
Message-ID: <AANLkTi=R+UGzh6mpMDTDdPg7+o1i2jK8H9t1-3nkL=YU@mail.gmail.com>
References: <AANLkTikD7Lw-+o6ky6P7NW05B1QYPick0PvZeaqF-_v2@mail.gmail.com>
	<20101026104856.11b69571@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101026104856.11b69571-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/10/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 26 Oct 2010 17:03:49 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Modify cifs_file_aio_write and cifs_write_end to let the client work=
s with
>> strict cache mode.
>>
>
> Not very descriptive of the logic here. Care to explain why you chang=
ed
> things the way you did?

I have explained this logic in the patch number 1 that adds
strictcache mount option (it includes README changes).

>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 35 ++++++++++++++++++++++++++++++-----
>> =A0fs/cifs/file.c =A0 | =A0 23 ++++++++++++++++++++++-
>> =A02 files changed, 52 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 21e0f47..85042e4 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -603,12 +603,37 @@ static ssize_t cifs_file_aio_read(struct kiocb
>> *iocb, const struct iovec *iov,
>> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u=
nsigned long nr_segs, loff_t pos)
>> =A0{
>> - =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_in=
ode;
>> - =A0 =A0 ssize_t written;
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 ssize_t written, cache_written;
>> + =A0 =A0 loff_t saved_pos;
>> +
>> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> +
>> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov, n=
r_segs, pos);
>> +
>> + =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
>> +
>> + =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=3D=
 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(iocb, i=
ov, nr_segs, pos);
>> + =A0 =A0 =A0 =A0 =A0 =A0 filemap_write_and_wait(inode->i_mapping);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
>> + =A0 =A0 }
>
> =A0 =A0 =A0 =A0That doesn't look right. CIFS_MOUNT_STRICT_IO is false=
=2E You're
> =A0 =A0 =A0 =A0doing a "normal" aio write (fine), and then calling
> =A0 =A0 =A0 =A0filemap_write_and_wait to sync it out? Why isn't
> =A0 =A0 =A0 =A0filemap_fdatawrite sufficient in the non-strict case?
>
> =A0 =A0 =A0 =A0Also, filemap_write_and_wait can return an error and y=
ou're
> =A0 =A0 =A0 =A0ignoring it here.
>

It's the same we have now - so, nothing changes. I try not to affect
existing mode and only to add changes in the strict mode.

>> +
>> + =A0 =A0 saved_pos =3D pos;
>> + =A0 =A0 written =3D cifs_user_write(iocb->ki_filp, iov->iov_base,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov->i=
ov_len, &pos);
>> +
>> + =A0 =A0 if (written > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cache_written =3D generic_file_aio_write(i=
ocb, iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_segs, saved_pos);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (cache_written !=3D written)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Cache written a=
nd server written data "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"lengths ar=
e different");
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos =3D pos;
>>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> =A0 =A0 =A0 =A0What exactly is this doing? It looks like you're writi=
ng the
> =A0 =A0 =A0 =A0same data to the server twice?

This code writes the data in cifs_user_write but not in
generic_file_aio_write - the client doesn't write anything or sets
pages dirty (to let writepages flush it) in cifs_write_end. So, that's
why this code writes to the server ony once.

>
>> - =A0 =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, pos=
);
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheAll)
>> - =A0 =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
>> =A0 =A0 =A0 return written;
>> =A0}
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 02a045e..a4d4b3a 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1578,11 +1578,31 @@ static int cifs_write_end(struct file *file,
>> struct address_space *mapping,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *page, void =
*fsdata)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> - =A0 =A0 struct inode *inode =3D mapping->host;
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> +
>> + =A0 =A0 inode =3D mapping->host;
>> + =A0 =A0 cifs_sb =3D CIFS_SB(inode->i_sb);
>>
>> =A0 =A0 =A0 cFYI(1, "write_end for page %p from pos %lld with %d byt=
es",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page, pos, copied);
>>
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D copied;
>> + =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D copied;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* if we don't have an exclusive oplock th=
e page data was
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0previously written to the server in=
 cifs_file_aio_write,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0so we don't need to do it again - g=
oto exit */
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto exit;
>> + =A0 =A0 }
>> +
>
> Oof. So you're only conditionally setting the uptodate and dirty bits
> on the pages after dirtying them? What exactly is going to flush thes=
e
> out to the server?

At first I am going to set only dirty flag but the kernel proves the
error in __set_page_dirty_nobuffers on the line:

WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));

and I add setting the page up to date. We flush the data to the server
through writepages (that flushs all dirty pages).

>
>> =A0 =A0 =A0 if (PageChecked(page)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copied =3D=3D len)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
>> @@ -1614,6 +1634,7 @@ static int cifs_write_end(struct file *file,
>> struct address_space *mapping,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
>> =A0 =A0 =A0 }
>>
>> +exit:
>> =A0 =A0 =A0 if (rc > 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&inode->i_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pos > inode->i_size)

--=20
Best regards,
Pavel Shilovsky.
