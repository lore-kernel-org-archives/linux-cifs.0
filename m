From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Implement cifs_strict_write (try #2)
Date: Wed, 22 Dec 2010 22:28:11 +0300
Message-ID: <AANLkTimX-Xs_N=tBH7OTeiGjK9E-uEerGQ0dP5RGWGrj@mail.gmail.com>
References: <1292590154-4768-1-git-send-email-piastryyy@gmail.com>
	<20101221140941.17fd3ece@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101221140941.17fd3ece-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 17 Dec 2010 15:49:14 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> If we don't have Exclusive oplock we write a data to the server thro=
ugh
>> CISSMBWrite2. Also set invalidate_mapping flag on the inode if we wr=
ote
>> something to the server.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0228 ++++++++++++++++++++++++++++++++=
++++++++++++++++++-
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A02 +-
>> =A03 files changed, 227 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index bcb4d2c..fb50883 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -606,15 +606,235 @@ static ssize_t cifs_strict_read(struct kiocb =
*iocb, const struct iovec *iov,
>> =A0 =A0 =A0 return read;
>> =A0}
>>
>> +/* Assume that dest points to memory area that is enough for source=
 data */
>> +static int cifs_copy_iovs(struct kvec *dst, const struct iovec **so=
urce,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long *lastlen=
, unsigned long len)
>> +{
>> + =A0 =A0 const struct iovec *src =3D *source;
>> + =A0 =A0 unsigned long dst_lastlen, src_lastlen;
>> + =A0 =A0 unsigned long cur_len;
>> +
>> + =A0 =A0 dst_lastlen =3D dst->iov_len;
>> + =A0 =A0 src_lastlen =3D *lastlen;
>> +
>> + =A0 =A0 while (len > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(unsigned long, dst_lastl=
en, src_lastlen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(unsigned long, cur_len, =
len);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (copy_from_user(dst->iov_base + dst->io=
v_len - dst_lastlen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0src=
->iov_base + src->iov_len - src_lastlen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur=
_len))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 dst_lastlen -=3D cur_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!dst_lastlen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst_lastlen =3D dst->iov_l=
en;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 src_lastlen -=3D cur_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!src_lastlen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 src++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 src_lastlen =3D src->iov_l=
en;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 len -=3D cur_len;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* update length of the last element in dest */
>> + =A0 =A0 if (dst_lastlen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 dst->iov_len -=3D dst_lastlen;
>> +
>> + =A0 =A0 /* save offset and length of the last element in source */
>> + =A0 =A0 *lastlen =3D src_lastlen;
>> + =A0 =A0 *source =3D src;
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static int
>> +cifs_strict_write_helper(struct page ***ppages, struct kvec **pto_s=
end,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Wow, a=
 triple pointer? Ugly...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long num_pages=
)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 unsigned long i;
>> + =A0 =A0 struct page **pages;
>> + =A0 =A0 struct kvec *to_send;
>> +
>> + =A0 =A0 *ppages =3D kmalloc(sizeof(struct pages *)*num_pages, GFP_=
KERNEL);
>> + =A0 =A0 if (!ppages)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 *pto_send =3D kmalloc(sizeof(struct kvec)*(num_pages + 1),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
>> + =A0 =A0 if (!pto_send) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ppages);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 pages =3D *ppages;
>> + =A0 =A0 to_send =3D *pto_send;
>> +
>> + =A0 =A0 for (i =3D 0; i < num_pages; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 pages[i] =3D alloc_page(__GFP_HIGHMEM);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!pages[i]) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* save number of pages =
we have already allocated and
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* return with ENOMEM er=
ror
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_pages =3D i;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_base =3D kmap(pages[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_len =3D PAGE_CACHE_SIZE;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^=
^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmap space is limited =
on 32-bit architectures.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You really want to lim=
it the amount of pages
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that you have simultan=
eously mapped.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0What's going to happen=
 if someone passes down a
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0massive write this way=
? I expect that it would
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fail badly.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0I think that you reall=
y only want to allocate
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the memory needed to p=
erform just the write
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that you're getting re=
ady to perform, and then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free it when that's do=
ne.
>
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return rc;
>> +
>> +error:
>> + =A0 =A0 for (i =3D 0; i < num_pages; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kunmap(pages[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
>> + =A0 =A0 }
>> + =A0 =A0 kfree(to_send);
>> + =A0 =A0 kfree(pages);
>> + =A0 =A0 return rc;
>> +}
>> +
>
> Instead of rolling your own functions for this, might it be better to
> try and use the iov_iter infrastructure? Look at what
> generic_perform_write does, IOW. This situation is a little different=
,
> but there are similarities.
>
>> +static ssize_t cifs_strict_write(struct kiocb *iocb, const struct i=
ovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigne=
d long nr_segs, loff_t pos)
>> +{
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 ssize_t written =3D 0, total_written =3D 0;
>> + =A0 =A0 unsigned long i, num_pages, cur_numpages;
>> + =A0 =A0 unsigned long len, cur_len, last_len;
>> + =A0 =A0 struct kvec *to_send;
>> + =A0 =A0 const struct iovec *offset;
>> + =A0 =A0 struct page **pages;
>> + =A0 =A0 struct cifsFileInfo *open_file;
>> + =A0 =A0 struct cifsTconInfo *pTcon;
>> + =A0 =A0 int xid, rc;
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
>> + =A0 =A0 len =3D 0;
>> + =A0 =A0 for (i =3D 0; i < nr_segs; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 len +=3D iov[i].iov_len;
>> +
>> + =A0 =A0 if (!len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* BB - optimize the way when signing is disabled. We ca=
n drop this
>> + =A0 =A0 =A0* extra memory-to-memory copying and use iovec buffers =
for constructing
>> + =A0 =A0 =A0* write request.
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 xid =3D GetXid();
>> + =A0 =A0 open_file =3D iocb->ki_filp->private_data;
>> + =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>> +
>> + =A0 =A0 /* calculate number of pages we need for process this writ=
e */
>> + =A0 =A0 cur_len =3D min_t(unsigned long, len, cifs_sb->wsize);
>> + =A0 =A0 num_pages =3D cur_len / PAGE_CACHE_SIZE;
>> + =A0 =A0 if (cur_len % PAGE_CACHE_SIZE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 num_pages++;
>> +
>> + =A0 =A0 rc =3D cifs_strict_write_helper(&pages, &to_send, num_page=
s);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 total_written =3D rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto error;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 last_len =3D iov->iov_len;
>> + =A0 =A0 offset =3D iov;
>> + =A0 =A0 cur_numpages =3D num_pages;
>> +
>> + =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_copy_iovs(to_send+1, &offset, =
&last_len, cur_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_written =3D -EFAULT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_len, pos, &written, to_send,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_numpages, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } while (rc =3D=3D -EAGAIN);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (written) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D written;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_written +=3D written=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_update_eof(CIFS_I(ino=
de), pos, written);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D written;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!total_written)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_writ=
ten =3D rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* get length and number of kvecs of the n=
ext write */
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(unsigned long, len, cifs=
_sb->wsize);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_numpages =3D cur_len / PAGE_CACHE_SIZE=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (cur_len % PAGE_CACHE_SIZE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_numpages++;
>> + =A0 =A0 } while (len > 0);
>> +
>> +exit:
>> + =A0 =A0 if (total_written > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->invalid_mapping =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos +=3D total_written;
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&inode->i_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (pos > inode->i_size)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, pos);
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&inode->i_lock);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 cifs_stats_bytes_written(pTcon, total_written);
>> + =A0 =A0 mark_inode_dirty_sync(inode);
>> +
>> + =A0 =A0 for (i =3D 0; i < num_pages; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kunmap(pages[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
>> + =A0 =A0 }
>> + =A0 =A0 kfree(to_send);
>> + =A0 =A0 kfree(pages);
>> +error:
>> + =A0 =A0 FreeXid(xid);
>> + =A0 =A0 return total_written;
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
>> @@ -748,7 +968,7 @@ const struct file_operations cifs_file_strict_op=
s =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> =A0 =A0 =A0 .aio_read =3D cifs_strict_read,
>> - =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> + =A0 =A0 .aio_write =3D cifs_strict_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> =A0 =A0 =A0 .lock =3D cifs_lock,
>> @@ -804,7 +1024,7 @@ const struct file_operations cifs_file_strict_n=
obrl_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> =A0 =A0 =A0 .aio_read =3D cifs_strict_read,
>> - =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> + =A0 =A0 .aio_write =3D cifs_strict_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> =A0 =A0 =A0 .fsync =3D cifs_strict_fsync,
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index e6d1481..e7d6c24 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -79,6 +79,8 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid=
, unsigned int length);
>> =A0extern bool is_valid_oplock_break(struct smb_hdr *smb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct TCP_Server_Info *);
>> =A0extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 =
eof);
>> +extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t off=
set,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int bytes=
_written);
>> =A0extern struct cifsFileInfo *find_writable_file(struct cifsInodeIn=
fo *, bool);
>> =A0extern struct cifsFileInfo *find_readable_file(struct cifsInodeIn=
fo *, bool);
>> =A0extern unsigned int smbCalcSize(struct smb_hdr *ptr);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index bc53e9e..8260f53 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -924,7 +924,7 @@ cifs_write_timeout(struct cifsInodeInfo *cifsi, =
loff_t offset)
>> =A0}
>>
>> =A0/* update the file size (if needed) after a write */
>> -static void
>> +void
>> =A0cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int bytes_written)
>> =A0{
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Ok, I understood your idea and agree with it. iov_iter is what I
should use for this. So, I am going to rewrite this patch also with
kmap changes you wrote about above.

--=20
Best regards,
Pavel Shilovsky.
