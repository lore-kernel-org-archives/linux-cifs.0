From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New write logic
Date: Tue, 2 Nov 2010 20:59:00 +0300
Message-ID: <AANLkTi=HMTsqLXoVPkE=0CitmyXTV110KPDNSZ6fOp=w@mail.gmail.com>
References: <AANLkTinegdugrKiMn4rErSyfp-t7HK6pYxumAS5DDiya@mail.gmail.com>
	<20101102114350.59f41db2@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101102114350.59f41db2-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 2 Nov 2010 12:02:24 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Modify cifs_file_aio_write and cifs_write_end to let the client work=
s with
>> strict cache mode.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 35 ++++++++++++++++++++++++++++++-----
>> =A0fs/cifs/file.c =A0 | =A0 14 ++++++++++++--
>> =A02 files changed, 42 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 1b44a92..e1ecd35 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -602,12 +602,37 @@ static ssize_t cifs_file_aio_read(struct kiocb
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
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You can't ignore the return code from =
this. That function
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0may return an error if writeback fails=
=2E Also, I don't
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0see any need to wait on the result in =
this case. Why
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0not just kick off the I/O and return (=
do a
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0filemap_fdatawrite, IOW).

I don't change non-strict variant for writing - we have this code now
in the git tree. But I agree - we should think about return value in
this case.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
>> + =A0 =A0 }
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
> =A0 =A0 =A0 =A0^^^^^
> This seems awfully complicated. Why not just do a
> generic_file_aio_write to get this into the cache and then just do a
> filemap_write_and_wait and deal with the result?

The main reason of doing this is mandatory byte-range locks. If we
simply do generic_file_aio_write and then filemap_write_and_wait we
can fail in the following situation:
1) process1 opens file and sets a mandatory lock from 0 to 1.
2) process2 opens file and writes a data from 1 to 2.

If we do like you suggest we fail on page writing (on
filemap_write_and_wait which writes whole page - from 0 to 2). That's
why I do cifs_user_write which writes the data from 1 to 2 (it's what
we need) and then store it in the cache by generic_file_aio_write
(with the little change in cifs_write_end that doesn't write the same
data twice to the server). So, right working of write and read ops
with mandatory locks is one of the reasons to provide srict cache
semantic.

>
>> - =A0 =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, pos=
);
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheAll)
>> - =A0 =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
>> =A0 =A0 =A0 return written;
>> =A0}
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 3970e68..4796748 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1539,7 +1539,11 @@ static int cifs_write_end(struct file *file,
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
>> @@ -1572,7 +1576,13 @@ static int cifs_write_end(struct file *file,
>> struct address_space *mapping,
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D copied;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D copied;
>> - =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* if we have strict cache switched on and=
 don't have Exclusive
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock for the inode, we don't have=
 to set_page_dirty
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0because we flushed the data to the =
server in
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file_aio_write before */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_=
STRICT_IO) =3D=3D 0 ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->clientCanCacheAll)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 if (rc > 0) {
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
