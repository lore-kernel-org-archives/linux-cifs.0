From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Implement cifs_strict_writev (try #3)
Date: Mon, 27 Dec 2010 19:20:05 +0300
Message-ID: <AANLkTi=+Nw+Spp6pmDJbqn5sBt0TKp8g=wr2BTHHdSYu@mail.gmail.com>
References: <1293357858-10006-1-git-send-email-piastryyy@gmail.com>
	<1293357858-10006-2-git-send-email-piastryyy@gmail.com>
	<20101227110538.48b150c7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101227110538.48b150c7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sun, 26 Dec 2010 13:04:18 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> If we don't have Exclusive oplock we write a data to the server.
>> Also set invalidate_mapping flag on the inode if we wrote something
>> to the server. Add cifs_iovec_write to let the client write iovec
>> buffers through CIFSSMBWrite2.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 15 +++-
>> =A0fs/cifs/cifsfs.h =A0 =A0| =A0 =A06 ++-
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0193 ++++++++++++++++++++++++++++++=
++++++++++++++++++++-
>> =A04 files changed, 210 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 0d6b005..76ba04e 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -578,10 +578,17 @@ static ssize_t cifs_file_aio_write(struct kioc=
b *iocb, const struct iovec *iov,
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
>> @@ -715,7 +722,7 @@ const struct file_operations cifs_file_strict_op=
s =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> =A0 =A0 =A0 .aio_read =3D cifs_strict_readv,
>> - =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> + =A0 =A0 .aio_write =3D cifs_strict_writev,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> =A0 =A0 =A0 .lock =3D cifs_lock,
>> @@ -771,7 +778,7 @@ const struct file_operations cifs_file_strict_no=
brl_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> =A0 =A0 =A0 .aio_read =3D cifs_strict_readv,
>> - =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> + =A0 =A0 .aio_write =3D cifs_strict_writev,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> =A0 =A0 =A0 .fsync =3D cifs_strict_fsync,
>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> index 6ff3ca2..2302a81 100644
>> --- a/fs/cifs/cifsfs.h
>> +++ b/fs/cifs/cifsfs.h
>> @@ -87,7 +87,11 @@ extern ssize_t cifs_user_readv(struct kiocb *iocb=
, const struct iovec *iov,
>> =A0extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct=
 iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsig=
ned long nr_segs, loff_t pos);
>> =A0extern ssize_t cifs_user_write(struct file *file, const char __us=
er *write_data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t write_size, loff=
_t *poffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t writ=
e_size, loff_t *poffset);
>> +extern ssize_t cifs_user_writev(struct kiocb *iocb, const struct io=
vec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned l=
ong nr_segs, loff_t pos);
>> +extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct =
iovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsign=
ed long nr_segs, loff_t pos);
>> =A0extern int cifs_lock(struct file *, int, struct file_lock *);
>> =A0extern int cifs_fsync(struct file *, int);
>> =A0extern int cifs_strict_fsync(struct file *, int);
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
>> index c3bc65c..9a23a58 100644
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
>> @@ -1677,6 +1677,197 @@ int cifs_flush(struct file *file, fl_owner_t=
 id)
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> +static int
>> +cifs_write_allocate_pages(struct page **pages, unsigned long num_pa=
ges)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 unsigned long i;
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
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return rc;
>> +
>> +error:
>> + =A0 =A0 for (i =3D 0; i < num_pages; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
>> + =A0 =A0 return rc;
>> +}
>> +
>> +static inline
>> +size_t get_numpages(const size_t wsize, const size_t len, size_t *c=
ur_len)
>> +{
>> + =A0 =A0 size_t num_pages;
>> + =A0 =A0 size_t clen;
>> +
>> + =A0 =A0 clen =3D min_t(const size_t, len, wsize);
>> + =A0 =A0 num_pages =3D clen / PAGE_CACHE_SIZE;
>> + =A0 =A0 if (clen % PAGE_CACHE_SIZE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 num_pages++;
>> +
>> + =A0 =A0 if (cur_len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 *cur_len =3D clen;
>> +
>> + =A0 =A0 return num_pages;
>> +}
>> +
>> +static ssize_t
>> +cifs_iovec_write(struct file *file, const struct iovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_segs, loff_t *poffset)
>> +{
>> + =A0 =A0 size_t total_written =3D 0, written =3D 0;
>> + =A0 =A0 unsigned long num_pages, npages;
>> + =A0 =A0 size_t copied, len, cur_len, i;
>> + =A0 =A0 struct kvec *to_send;
>> + =A0 =A0 struct page **pages;
>> + =A0 =A0 struct iov_iter it;
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifsFileInfo *open_file;
>> + =A0 =A0 struct cifsTconInfo *pTcon;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 int xid, rc;
>> +
>> + =A0 =A0 len =3D iov_length(iov, nr_segs);
>> + =A0 =A0 if (!len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>> + =A0 =A0 num_pages =3D get_numpages(cifs_sb->wsize, len, &cur_len);
>> +
>> + =A0 =A0 pages =3D kmalloc(sizeof(struct pages *)*num_pages, GFP_KE=
RNEL);
>> + =A0 =A0 if (!pages)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 to_send =3D kmalloc(sizeof(struct kvec)*(num_pages + 1), G=
=46P_KERNEL);
>> + =A0 =A0 if (!to_send) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D cifs_write_allocate_pages(pages, num_pages);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(to_send);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 xid =3D GetXid();
>> + =A0 =A0 open_file =3D file->private_data;
>> + =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>> + =A0 =A0 inode =3D file->f_path.dentry->d_inode;
>> +
>> + =A0 =A0 iov_iter_init(&it, iov, nr_segs, len, 0);
>> + =A0 =A0 npages =3D num_pages;
>> +
>> + =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 size_t save_len =3D cur_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D min_t(const siz=
e_t, cur_len, PAGE_CACHE_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D iov_iter_copy_f=
rom_user(pages[i], &it, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0copied);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_len -=3D copied;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov_iter_advance(&it, copi=
ed);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_base =3D =
kmap(pages[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_len =3D c=
opied;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D save_len - cur_len;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_len, *poffset, &written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0to_send, npages, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } while (rc =3D=3D -EAGAIN);
>> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^
> I think the above loop needs to be able to reclaim the filehandle if
> there was a reconnect event.

May I should add both checks: file->private_data =3D=3D NULL and
open_file->invalidHandle like we have them here
-http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/cifs/file.c#L963 ?

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(pages[i]);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (written) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D written;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_written +=3D written=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_update_eof(CIFS_I(ino=
de), *poffset, written);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffset +=3D written;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!total_written)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_writ=
ten =3D rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* get length and number of kvecs of the n=
ext write */
>> + =A0 =A0 =A0 =A0 =A0 =A0 npages =3D get_numpages(cifs_sb->wsize, le=
n, &cur_len);
>> + =A0 =A0 } while (len > 0);
>> +
>> + =A0 =A0 if (total_written > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&inode->i_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*poffset > inode->i_size)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, *poffs=
et);
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&inode->i_lock);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 cifs_stats_bytes_written(pTcon, total_written);
>> + =A0 =A0 mark_inode_dirty_sync(inode);
>> +
>> + =A0 =A0 for (i =3D 0; i < num_pages; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
>> + =A0 =A0 kfree(to_send);
>> + =A0 =A0 kfree(pages);
>> + =A0 =A0 FreeXid(xid);
>> + =A0 =A0 return total_written;
>> +}
>> +
>> +ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *io=
v,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_segs, =
loff_t pos)
>> +{
>> + =A0 =A0 ssize_t written;
>> + =A0 =A0 struct inode *inode;
>> +
>> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* BB - optimize the way when signing is disabled. We ca=
n drop this
>> + =A0 =A0 =A0* extra memory-to-memory copying and use iovec buffers =
for constructing
>> + =A0 =A0 =A0* write request.
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 written =3D cifs_iovec_write(iocb->ki_filp, iov, nr_segs, =
&pos);
>> + =A0 =A0 if (written > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->invalid_mapping =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos =3D pos;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return written;
>> +}
>> +
>> +ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *=
iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_se=
gs, loff_t pos)
>> +{
>> + =A0 =A0 struct inode *inode;
>> +
>> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> +
>> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov, n=
r_segs, pos);
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
>> + =A0 =A0 return cifs_user_writev(iocb, iov, nr_segs, pos);
>> +}
>> +
>> =A0static ssize_t
>> =A0cifs_iovec_read(struct file *file, const struct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_segs, loff_t *poffse=
t)
>
>
> ...and like in the read patch, please don't add global symbols until
> they're needed. Make things static where possible and only make them
> global as it becomes necessary.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
