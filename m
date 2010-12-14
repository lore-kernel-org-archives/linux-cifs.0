From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Implement cifs_strict_write
Date: Tue, 14 Dec 2010 17:01:58 +0300
Message-ID: <AANLkTinXkK+2PyUNGNY9cBkBP2T5ft65a=9vpXpd5aBz@mail.gmail.com>
References: <1292325060-8828-1-git-send-email-piastryyy@gmail.com>
	<1292325060-8828-4-git-send-email-piastryyy@gmail.com>
	<20101214084053.0da711a2@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214084053.0da711a2-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 14 Dec 2010 14:10:58 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> If we don't have Exclusive oplock we write a data to the server thro=
ugh
>> cifs_write. Also set invalidate_mapping flag on the inode if we wrot=
e
>> something to the server.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 74 ++++++++++++++++++++++++++++++++=
++++++++++++++++---
>> =A0fs/cifs/cifsproto.h | =A0 =A03 ++
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A05 +--
>> =A03 files changed, 75 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index a218afe..5df0503 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -572,15 +572,81 @@ cifs_do_mount(struct file_system_type *fs_type=
,
>> =A0 =A0 =A0 return dget(sb->s_root);
>> =A0}
>>
>> +static ssize_t cifs_strict_write(struct kiocb *iocb, const struct i=
ovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigne=
d long nr_segs, loff_t pos)
>> +{
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 ssize_t written =3D 0;
>> + =A0 =A0 unsigned long i, len =3D 0;
>> + =A0 =A0 char *buf, *offset;
>> +
>> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> +
>> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov, n=
r_segs, pos);
>> +
>> + =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* In strict cache mode we need to write the data to the=
 server exactly
>> + =A0 =A0 =A0* from the pos to pos+len-1 rather than flush all affec=
ted pages
>> + =A0 =A0 =A0* because it may cause a error with mandatory locks on =
these pages but
>> + =A0 =A0 =A0* not on the region from pos to ppos+len-1.
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 for (i =3D 0; i < nr_segs; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 len +=3D iov[i].iov_len;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* BB - optimize the way when signing is disabled. We ca=
n drop this
>> + =A0 =A0 =A0* extra memory-to-memory copying and use iovec buffers =
for constructing
>> + =A0 =A0 =A0* write request.
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 buf =3D kmalloc(len, GFP_KERNEL);
>> +
>
> Actually...I thought about another problem here. Suppose an applicati=
on
> does a 100M write. This may fail in that case. It varies by the slab
> allocator in use, but there are limits to how large you can kmalloc.
> This is especially going to be a problem on 32-bit arches where
> GFP_KERNEL memory is more limited.
>
> There are a couple of different solutions, but I think the best one
> would be to stitch together individual pages. Walk the iov array firs=
t
> and figure out how many pages you're going to need, and kmalloc an io=
v
> array that size. Then start allocating pages (preferably using
> GFP_HIGHMEM and kmapping them) and then copy the data to them. Stop
> when you get to the wsize limit, and issue a CIFSSMBWrite2 call. When
> it returns, pick up where you left off and do it again.

May be I should allocate buffer of min(wsize, write_len) size, fill it
with a data to write on cycle and issue a cifs_write with this buffer.

1) get write data len into 'len'
2)=A0buf =3D kmalloc(min(wsize, len), GFP_KERNEL)
3) last_ind =3D 0, last_len =3D iov[0].iov_len
4) while (len > 0){
=A0=A0 =A0 =A0cur_len =3D min(len, last_len)
=A0=A0 =A0 =A0memcpy(buf, iov[last_ind].iov_base + iov[last_ind].iov_le=
n -
last_len, cur_len)
=A0=A0 =A0 =A0len -=3D cur_len
=A0=A0 =A0 =A0last_len -=3D cur_len
=A0=A0 =A0 =A0if (last_len =3D=3D 0) {
=A0=A0 =A0 =A0 =A0last_ind++
=A0=A0 =A0 =A0 =A0last_len =3D iov[last_ind].iov_len
=A0=A0 =A0 =A0}
=A0=A0 =A0 =A0cifs_write(buf)
=A0=A0 }

So - it is like the way I do in read part (cifs_fill_iov). Thoughts?

>
>> + =A0 =A0 for (i =3D 0, offset =3D buf; i < nr_segs; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (copy_from_user(offset, iov[i].iov_base=
, iov[i].iov_len)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D iov[i].iov_len;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 written =3D cifs_write((struct cifsFileInfo *)iocb->ki_fil=
p->private_data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf, len, &pos)=
;
>> + =A0 =A0 if (written < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 iocb->ki_pos =3D pos;
>> +
>> + =A0 =A0 if (written > 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->invalid_mapping =3D true;
>> +
>> + =A0 =A0 kfree(buf);
>> + =A0 =A0 return written;
>> +}
>> +
>> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u=
nsigned long nr_segs, loff_t pos)
>> =A0{
>> =A0 =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_=
inode;
>> =A0 =A0 =A0 ssize_t written;
>> + =A0 =A0 int rc;
>>
>> =A0 =A0 =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, p=
os);
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheAll)
>> - =A0 =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
>> +
>> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
>> +
>> + =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mapping);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_file_aio_write: %d rc on %p =
inode", rc, inode);
>> +
>> =A0 =A0 =A0 return written;
>> =A0}
>>
>> @@ -714,7 +780,7 @@ const struct file_operations cifs_file_strict_op=
s =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> =A0 =A0 =A0 .aio_read =3D generic_file_aio_read,
>> - =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> + =A0 =A0 .aio_write =3D cifs_strict_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> =A0 =A0 =A0 .lock =3D cifs_lock,
>> @@ -770,7 +836,7 @@ const struct file_operations cifs_file_strict_no=
brl_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> =A0 =A0 =A0 .aio_read =3D generic_file_aio_read,
>> - =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> + =A0 =A0 .aio_write =3D cifs_strict_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> =A0 =A0 =A0 .fsync =3D cifs_strict_fsync,
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index e6d1481..3a337a9 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -79,6 +79,9 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid=
, unsigned int length);
>> =A0extern bool is_valid_oplock_break(struct smb_hdr *smb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct TCP_Server_Info *);
>> =A0extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 =
eof);
>> +extern ssize_t cifs_write(struct cifsFileInfo *open_file,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *write_data=
, size_t write_size,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t *poffset);
>> =A0extern struct cifsFileInfo *find_writable_file(struct cifsInodeIn=
fo *, bool);
>> =A0extern struct cifsFileInfo *find_readable_file(struct cifsInodeIn=
fo *, bool);
>> =A0extern unsigned int smbCalcSize(struct smb_hdr *ptr);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index dd1e59a..2c848ef 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1026,9 +1026,8 @@ ssize_t cifs_user_write(struct file *file, con=
st char __user *write_data,
>> =A0 =A0 =A0 return total_written;
>> =A0}
>>
>> -static ssize_t cifs_write(struct cifsFileInfo *open_file,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *write_data=
, size_t write_size,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t *poffset)
>> +ssize_t cifs_write(struct cifsFileInfo *open_file, const char *writ=
e_data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t write_size, loff_t *poffset)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 unsigned int bytes_written =3D 0;
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
