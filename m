From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Implement cifs_strict_read (try #2)
Date: Wed, 22 Dec 2010 22:25:57 +0300
Message-ID: <AANLkTi=q1oWcrvJ_=HQBnsi7waqaPSFTG_XX584-H-Eh@mail.gmail.com>
References: <1292521052-5388-1-git-send-email-piastry@etersoft.ru>
	<1292521052-5388-2-git-send-email-piastry@etersoft.ru>
	<20101221132931.2e2e2a6f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101221132931.2e2e2a6f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 16 Dec 2010 20:37:32 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Read from the cache if we have at least Level II oplock - otherwise
>> read from the server. Add cifs_user_readv to let the client read int=
o
>> several buffers.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 38 ++++++++++++++++++-
>> =A0fs/cifs/cifsfs.h | =A0 =A04 +-
>> =A0fs/cifs/file.c =A0 | =A0108 +++++++++++++++++++++++++++++++++++++=
++---------------
>> =A03 files changed, 117 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index a218afe..bcb4d2c 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -572,6 +572,40 @@ cifs_do_mount(struct file_system_type *fs_type,
>> =A0 =A0 =A0 return dget(sb->s_root);
>> =A0}
>>
>> +static ssize_t cifs_strict_read(struct kiocb *iocb, const struct io=
vec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned l=
ong nr_segs, loff_t pos)
>> +{
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 ssize_t read =3D 0;
>> +
>> + =A0 =A0 if (!nr_segs)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return read;
>> +
>> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> + =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
>> +
>> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheRead)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_read(iocb, iov, nr=
_segs, pos);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* In strict cache mode we need to read from the server =
all the time
>> + =A0 =A0 =A0* if we don't have level II oplock because the server c=
an delay mtime
>> + =A0 =A0 =A0* change - so we can't make a decision about inode inva=
lidating.
>> + =A0 =A0 =A0* And we can also fail with pagereading if there are ma=
ndatory locks
>> + =A0 =A0 =A0* on pages affected by this read but not on the region =
from pos to
>> + =A0 =A0 =A0* pos+len-1.
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 read =3D cifs_user_readv(iocb->ki_filp, iov, nr_segs, &pos=
);
>> + =A0 =A0 if (read < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return read;
>> +
>> + =A0 =A0 iocb->ki_pos =3D pos;
>> +
>> + =A0 =A0 return read;
>> +}
>> +
>> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u=
nsigned long nr_segs, loff_t pos)
>> =A0{
>> @@ -713,7 +747,7 @@ const struct file_operations cifs_file_ops =3D {
>> =A0const struct file_operations cifs_file_strict_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> - =A0 =A0 .aio_read =3D generic_file_aio_read,
>> + =A0 =A0 .aio_read =3D cifs_strict_read,
>> =A0 =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> @@ -769,7 +803,7 @@ const struct file_operations cifs_file_nobrl_ops=
 =3D {
>> =A0const struct file_operations cifs_file_strict_nobrl_ops =3D {
>> =A0 =A0 =A0 .read =3D do_sync_read,
>> =A0 =A0 =A0 .write =3D do_sync_write,
>> - =A0 =A0 .aio_read =3D generic_file_aio_read,
>> + =A0 =A0 .aio_read =3D cifs_strict_read,
>> =A0 =A0 =A0 .aio_write =3D cifs_file_aio_write,
>> =A0 =A0 =A0 .open =3D cifs_open,
>> =A0 =A0 =A0 .release =3D cifs_close,
>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> index 657738f..f690d1c 100644
>> --- a/fs/cifs/cifsfs.h
>> +++ b/fs/cifs/cifsfs.h
>> @@ -81,7 +81,9 @@ extern int cifs_open(struct inode *inode, struct f=
ile *file);
>> =A0extern int cifs_close(struct inode *inode, struct file *file);
>> =A0extern int cifs_closedir(struct inode *inode, struct file *file);
>> =A0extern ssize_t cifs_user_read(struct file *file, char __user *rea=
d_data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t read_size, loff_=
t *poffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t read_si=
ze, loff_t *poffset);
>> +extern ssize_t cifs_user_readv(struct file *file, const struct iove=
c *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned lo=
ng nr_segs, loff_t *poffset);
>> =A0extern ssize_t cifs_user_write(struct file *file, const char __us=
er *write_data,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t write_size, lo=
ff_t *poffset);
>> =A0extern int cifs_lock(struct file *, int, struct file_lock *);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index d48723c..bc53e9e 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1677,20 +1677,60 @@ int cifs_flush(struct file *file, fl_owner_t=
 id)
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -ssize_t cifs_user_read(struct file *file, char __user *read_data,
>> - =A0 =A0 size_t read_size, loff_t *poffset)
>> +static int
>> +cifs_fill_iov(const struct iovec *iov, unsigned long nr_segs,
>> + =A0 =A0 =A0 =A0 =A0 unsigned long *last_len, unsigned long *last_i=
nd, char *data,
>> + =A0 =A0 =A0 =A0 =A0 size_t datalen)
>> =A0{
>
> I have to wonder if we already have generic helpers for this sort of =
thing?

Thanks, good idea. I've just found memcpy_toiovecend call that does
the same things. I think I should replace this try with variant that
uses memcpy_toiovecend.
>
>> - =A0 =A0 int rc =3D -EACCES;
>> - =A0 =A0 unsigned int bytes_read =3D 0;
>> - =A0 =A0 unsigned int total_read =3D 0;
>> - =A0 =A0 unsigned int current_read_size;
>> + =A0 =A0 const struct iovec *ciov;
>> + =A0 =A0 unsigned long cur_len;
>> +
>> + =A0 =A0 while (datalen) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(unsigned long, datalen,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 *last_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This can be on a single line...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 ciov =3D &iov[*last_ind];
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (copy_to_user(ciov->iov_base + (ciov->i=
ov_len - *last_len),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data, c=
ur_len))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 datalen -=3D cur_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 data +=3D cur_len;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 *last_len -=3D cur_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*last_len =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (*last_ind)++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *last_len =3D iov[*last_in=
d].iov_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +ssize_t cifs_user_readv(struct file *file, const struct iovec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, lof=
f_t *poffset)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 int xid;
>> + =A0 =A0 unsigned int bytes_read =3D 0, total_read =3D 0;
>> + =A0 =A0 unsigned long last_len =3D 0, len =3D 0, last_ind =3D 0;
>> + =A0 =A0 unsigned long cur_len, i;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 struct cifsTconInfo *pTcon;
>> - =A0 =A0 int xid;
>> =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> - =A0 =A0 char *smb_read_data;
>> - =A0 =A0 char __user *current_offset;
>> =A0 =A0 =A0 struct smb_com_read_rsp *pSMBr;
>> + =A0 =A0 char *read_data;
>> +
>> + =A0 =A0 if (!nr_segs)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 last_len =3D iov->iov_len;
>> +
>> + =A0 =A0 for (i =3D 0; i < nr_segs; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 len +=3D iov[i].iov_len;
>> +
>> + =A0 =A0 if (!len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>> @@ -1700,19 +1740,19 @@ ssize_t cifs_user_read(struct file *file, ch=
ar __user *read_data,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 open_file =3D file->private_data;
>> =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>>
>> =A0 =A0 =A0 if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "attempting read on write only f=
ile instance");
>>
>> - =A0 =A0 for (total_read =3D 0, current_offset =3D read_data;
>> - =A0 =A0 =A0 =A0 =A0read_size > total_read;
>> - =A0 =A0 =A0 =A0 =A0total_read +=3D bytes_read, current_offset +=3D=
 bytes_read) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 current_read_size =3D min_t(const int, rea=
d_size - total_read,
>> + =A0 =A0 for (total_read =3D 0; total_read < len; total_read +=3D b=
ytes_read) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(const int, len - total_r=
ead,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 cifs_sb->rsize);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EAGAIN;
>> - =A0 =A0 =A0 =A0 =A0 =A0 smb_read_data =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 read_data =3D NULL;
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (rc =3D=3D -EAGAIN) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int buf_type =3D CIFS_NO=
_BUFFER;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (open_file->invalidHa=
ndle) {
>> @@ -1721,26 +1761,24 @@ ssize_t cifs_user_read(struct file *file, ch=
ar __user *read_data,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, =
pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0current_read_size, *poffset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&bytes_read, &smb_read_data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&buf_type);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr =3D (struct smb_com_=
read_rsp *)smb_read_data;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (smb_read_data) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copy_t=
o_user(current_offset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 smb_read_data +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 4 /* RFC1001 length field */ +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(pSMBr->DataOffset),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 bytes_read))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0open_file->netfid, cur_len, *poffset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&bytes_read, &read_data, &buf_type);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr =3D (struct smb_com_=
read_rsp *)read_data;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (read_data) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *data=
_offset =3D read_data + 4 +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(pSMBr->DataOffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_f=
ill_iov(iov, nr_segs,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &last_len, &last_ind,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 data_offset, bytes_read))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -EFAULT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nit: it's generally be=
tter not to indent the inside of a block along with the conditions.
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buf_=
type =3D=3D CIFS_SMALL_BUFFER)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_small_buf_release(smb_read_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_small_buf_release(read_data);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if =
(buf_type =3D=3D CIFS_LARGE_BUFFER)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_buf_release(smb_read_data);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_read_d=
ata =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_buf_release(read_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_data =
=3D NULL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (bytes_read =3D=3D 0)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_read) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> @@ -1753,13 +1791,23 @@ ssize_t cifs_user_read(struct file *file, ch=
ar __user *read_data,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffset +=3D bytes_read=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 return total_read;
>> =A0}
>>
>> +ssize_t cifs_user_read(struct file *file, char __user *read_data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t read_size, loff_t *p=
offset)
>> +{
>> + =A0 =A0 struct iovec iov;
>> + =A0 =A0 iov.iov_base =3D read_data;
>> + =A0 =A0 iov.iov_len =3D read_size;
>> +
>> + =A0 =A0 return cifs_user_readv(file, &iov, 1, poffset);
>> +}
>>
>> =A0static ssize_t cifs_read(struct file *file, char *read_data, size=
_t read_size,
>> - =A0 =A0 loff_t *poffset)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t *poffset)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> =A0 =A0 =A0 unsigned int bytes_read =3D 0;
>
>
> Other than the minor nits above, it looks good to me.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--=20
Best regards,
Pavel Shilovsky.
