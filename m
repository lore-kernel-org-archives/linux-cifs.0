From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Use pid saved from cifsFileInfo in writepages
 and set_file_size
Date: Thu, 26 May 2011 22:56:50 +0400
Message-ID: <BANLkTimeB9KDcQXuXUk7UZhAgp0BWSR0Og@mail.gmail.com>
References: <1306389721-28550-1-git-send-email-piastry@etersoft.ru>
	<1306389721-28550-2-git-send-email-piastry@etersoft.ru>
	<20110526145147.4fa2ba35@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110526145147.4fa2ba35-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 26 May 2011 10:01:59 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> We need it to make them work with mandatory locking style because
>> we can fail in a situation like when kernel need to flush dirty page=
s
>> and there is a lock held by a process who opened file.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A08 ++++++++
>> =A0fs/cifs/cifsproto.h | =A0 13 +++++--------
>> =A0fs/cifs/cifssmb.c =A0 | =A0 33 ++++++++++++++++++++++++++-------
>> =A0fs/cifs/dir.c =A0 =A0 =A0 | =A0 18 ++++++++++--------
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 31 +++++++++++++++++++++---------=
-
>> =A0fs/cifs/inode.c =A0 =A0 | =A0 24 ++++++++++++++++++------
>> =A0fs/cifs/link.c =A0 =A0 =A0| =A0 12 ++++++++----
>> =A07 files changed, 96 insertions(+), 43 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 7f90488..ca0c378 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -529,6 +529,14 @@ struct cifsFileInfo {
>> =A0 =A0 =A0 struct work_struct oplock_break; /* work for oplock brea=
ks */
>> =A0};
>>
>> +struct cifs_io_parms {
>> + =A0 =A0 __u16 netfid;
>> + =A0 =A0 __u32 pid;
>> + =A0 =A0 __u64 offset;
>> + =A0 =A0 unsigned int length;
>> + =A0 =A0 struct cifsTconInfo *tcon;
>> +};
>> +
> =A0 =A0 =A0 =A0^^^^^^^^^^
> I'm not sure this is really needed -- it seems like it would make mor=
e
> sense to just pass in a cifsFileInfo pointer to these functions. That
> already contains most of these args, aside from the offset and length=
=2E

I thought about it but let's look: cifsFileInfo pointer has only
netfid and tcon - it has pid, but we don't always need the pid of
process who opened the file - so sometimes we overwrite it. That's why
I decided to create new struct - it seems cleaner to me.

>
>> =A0/*
>> =A0 * Take a reference on the file private data. Must be called with
>> =A0 * cifs_file_list_lock held.
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index bba7470..e41f607 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -349,15 +349,12 @@ extern int CIFSSMBRead(const int xid, struct c=
ifsTconInfo *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, unsign=
ed int count,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 lseek, unsig=
ned int *nbytes, char **buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *return_buf_type);
>> -extern int CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const un=
signed int count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 lseek, unsigne=
d int *nbytes,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *buf, const cha=
r __user *ubuf,
>> +extern int CIFSSMBWrite(const int xid, struct cifs_io_parms *io_par=
ms,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, cons=
t char *buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char __user *ubuf, c=
onst int long_op);
>> +extern int CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_pa=
rms,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, stru=
ct kvec *iov, const int nvec,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
>> -extern int CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const un=
signed int count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 offset, unsign=
ed int *nbytes,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, const in=
t nvec, const int long_op);
>> =A0extern int CIFSGetSrvInodeNumber(const int xid, struct cifsTconIn=
fo *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *sea=
rchName, __u64 *inode_number,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *=
nls_codepage,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 136df01..f39fa08 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -1487,9 +1487,8 @@ CIFSSMBRead(const int xid, struct cifsTconInfo=
 *tcon, const int netfid,
>>
>>
>> =A0int
>> -CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
>> - =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
>> - =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, const=
 char *buf,
>> +CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
>> + =A0 =A0 =A0 =A0 =A0unsigned int *nbytes, const char *buf,
>> =A0 =A0 =A0 =A0 =A0 =A0const char __user *ubuf, const int long_op)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> @@ -1498,6 +1497,11 @@ CIFSSMBWrite(const int xid, struct cifsTconIn=
fo *tcon,
>> =A0 =A0 =A0 int bytes_returned, wct;
>> =A0 =A0 =A0 __u32 bytes_sent;
>> =A0 =A0 =A0 __u16 byte_count;
>> + =A0 =A0 __u32 pid =3D io_parms->pid;
>> + =A0 =A0 __u16 netfid =3D io_parms->netfid;
>> + =A0 =A0 __u64 offset =3D io_parms->offset;
>> + =A0 =A0 struct cifsTconInfo *tcon =3D io_parms->tcon;
>> + =A0 =A0 unsigned int count =3D io_parms->length;
>>
>> =A0 =A0 =A0 *nbytes =3D 0;
>>
>> @@ -1519,6 +1523,10 @@ CIFSSMBWrite(const int xid, struct cifsTconIn=
fo *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void **) &pSMBr);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)pid);
>> + =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(pid >> 16));
>> +
>> =A0 =A0 =A0 /* tcon and ses pointer are checked in smb_init */
>> =A0 =A0 =A0 if (tcon->ses->server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECONNABORTED;
>> @@ -1778,6 +1786,9 @@ cifs_async_writev(struct cifs_writedata *wdata=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto async_writev_out;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 smb->hdr.Pid =3D cpu_to_le16((__u16)wdata->cfile->pid);
>> + =A0 =A0 smb->hdr.PidHigh =3D cpu_to_le16((__u16)(wdata->cfile->pid=
 >> 16));
>> +
>> =A0 =A0 =A0 smb->AndXCommand =3D 0xFF; =A0 =A0 =A0 =A0/* none */
>> =A0 =A0 =A0 smb->Fid =3D wdata->cfile->netfid;
>> =A0 =A0 =A0 smb->OffsetLow =3D cpu_to_le32(wdata->offset & 0xFFFFFFF=
=46);
>> @@ -1841,16 +1852,20 @@ async_writev_out:
>> =A0}
>>
>> =A0int
>> -CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
>> - =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
>> - =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, struc=
t kvec *iov,
>> - =A0 =A0 =A0 =A0 =A0int n_vec, const int long_op)
>> +CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
>> + =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, struct kvec *iov, int n_=
vec,
>> + =A0 =A0 =A0 =A0 =A0 const int long_op)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> =A0 =A0 =A0 WRITE_REQ *pSMB =3D NULL;
>> =A0 =A0 =A0 int wct;
>> =A0 =A0 =A0 int smb_hdr_len;
>> =A0 =A0 =A0 int resp_buf_type =3D 0;
>> + =A0 =A0 __u32 pid =3D io_parms->pid;
>> + =A0 =A0 __u16 netfid =3D io_parms->netfid;
>> + =A0 =A0 __u64 offset =3D io_parms->offset;
>> + =A0 =A0 struct cifsTconInfo *tcon =3D io_parms->tcon;
>> + =A0 =A0 unsigned int count =3D io_parms->length;
>>
>> =A0 =A0 =A0 *nbytes =3D 0;
>>
>> @@ -1868,6 +1883,10 @@ CIFSSMBWrite2(const int xid, struct cifsTconI=
nfo *tcon,
>> =A0 =A0 =A0 rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (vo=
id **) &pSMB);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)pid);
>> + =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(pid >> 16));
>> +
>> =A0 =A0 =A0 /* tcon and ses pointer are checked in smb_init */
>> =A0 =A0 =A0 if (tcon->ses->server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECONNABORTED;
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index c33446d..aa0669a 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -354,6 +354,7 @@ int cifs_mknod(struct inode *inode, struct dentr=
y *direntry, int mode,
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 struct tcon_link *tlink;
>> =A0 =A0 =A0 struct cifsTconInfo *pTcon;
>> + =A0 =A0 struct cifs_io_parms io_parms;
>> =A0 =A0 =A0 char *full_path =3D NULL;
>> =A0 =A0 =A0 struct inode *newinode =3D NULL;
>> =A0 =A0 =A0 int oplock =3D 0;
>> @@ -436,16 +437,19 @@ int cifs_mknod(struct inode *inode, struct den=
try *direntry, int mode,
>> =A0 =A0 =A0 =A0* timestamps in, but we can reuse it safely */
>>
>> =A0 =A0 =A0 pdev =3D (struct win_dev *)buf;
>> + =A0 =A0 io_parms.netfid =3D fileHandle;
>> + =A0 =A0 io_parms.pid =3D current->tgid;
>> + =A0 =A0 io_parms.tcon =3D pTcon;
>> + =A0 =A0 io_parms.offset =3D 0;
>> + =A0 =A0 io_parms.length =3D sizeof(struct win_dev);
>> =A0 =A0 =A0 if (S_ISCHR(mode)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(pdev->type, "IntxCHR", 8);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->major =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le64(MAJOR(device_num=
ber));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->minor =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le64(MINOR(device_num=
ber));
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct win_dev),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, &bytes_written, (char *=
)pdev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, &io_parms,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, (char *)pd=
ev,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 0);
>> =A0 =A0 =A0 } else if (S_ISBLK(mode)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(pdev->type, "IntxBLK", 8);
>> @@ -453,10 +457,8 @@ int cifs_mknod(struct inode *inode, struct dent=
ry *direntry, int mode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le64(MAJOR(device_num=
ber));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->minor =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le64(MINOR(device_num=
ber));
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct win_dev),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, &bytes_written, (char *=
)pdev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, &io_parms,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, (char *)pd=
ev,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 0);
>> =A0 =A0 =A0 } /* else if (S_ISFIFO) */
>> =A0 =A0 =A0 CIFSSMBClose(xid, pTcon, fileHandle);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 00b926c..dfc0d35 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -857,7 +857,7 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, lof=
f_t offset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsi->server_eof =3D end_of_write;
>> =A0}
>>
>> -static ssize_t cifs_write(struct cifsFileInfo *open_file,
>> +static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *write_da=
ta, size_t write_size,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t *poffset)
>> =A0{
>> @@ -869,6 +869,7 @@ static ssize_t cifs_write(struct cifsFileInfo *o=
pen_file,
>> =A0 =A0 =A0 int xid;
>> =A0 =A0 =A0 struct dentry *dentry =3D open_file->dentry;
>> =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(dentry->d_inode);
>> + =A0 =A0 struct cifs_io_parms io_parms;
>>
>> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(dentry->d_sb);
>>
>> @@ -901,8 +902,13 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* iov[0] is reserved fo=
r smb header */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D (cha=
r *)write_data + total_written;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_len =3D len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid, len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0*poffset, &bytes_written, iov, 1, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.netfid =3D open_f=
ile->netfid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.pid =3D pid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.tcon =3D pTcon;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.offset =3D *poffs=
et;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.length =3D len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
&io_parms, &bytes_written, iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A01, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (bytes_written =3D=3D 0)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_written)
>> @@ -1071,8 +1077,8 @@ static int cifs_partialpagewrite(struct page *=
page, unsigned from, unsigned to)
>>
>> =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host), =
false);
>> =A0 =A0 =A0 if (open_file) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 bytes_written =3D cifs_write(open_file, wr=
ite_data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0to - from, &offset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bytes_written =3D cifs_write(open_file, op=
en_file->pid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0write_data, to - from, &offset);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(open_file);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Does mm or vfs already set times? */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_atime =3D inode->i_mtime =3D cu=
rrent_fs_time(inode->i_sb);
>> @@ -1363,8 +1369,8 @@ static int cifs_write_end(struct file *file, s=
truct address_space *mapping,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB check if anything else missing out=
 of ppw
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0such as updating last write time =
*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_data =3D kmap(page);
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_write(file->private_data, page=
_data + offset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied, &p=
os);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_write(file->private_data, curr=
ent->tgid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_data =
+ offset, copied, &pos);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if (rc < 0) should we set writebehind=
 rc? */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(page);
>>
>> @@ -1515,6 +1521,7 @@ cifs_iovec_write(struct file *file, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> =A0 =A0 =A0 struct cifsTconInfo *pTcon;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 struct cifs_io_parms io_parms;
>> =A0 =A0 =A0 int xid, rc;
>>
>> =A0 =A0 =A0 len =3D iov_length(iov, nr_segs);
>> @@ -1573,9 +1580,13 @@ cifs_iovec_write(struct file *file, const str=
uct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=
=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_len, *poffset, &written,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0to_send, npages, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.netfid =3D open_f=
ile->netfid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.pid =3D current->=
tgid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.tcon =3D pTcon;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.offset =3D *poffs=
et;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.length =3D cur_le=
n;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
&io_parms, &written, to_send,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0npages, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (rc =3D=3D -EAGAIN);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++)
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 791d85e..53ea625 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1866,6 +1866,7 @@ cifs_set_file_size(struct inode *inode, struct=
 iattr *attrs,
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>> =A0 =A0 =A0 struct tcon_link *tlink =3D NULL;
>> =A0 =A0 =A0 struct cifsTconInfo *pTcon =3D NULL;
>> + =A0 =A0 struct cifs_io_parms io_parms;
>>
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* To avoid spurious oplock breaks from server, in the=
 case of
>> @@ -1887,8 +1888,14 @@ cifs_set_file_size(struct inode *inode, struc=
t iattr *attrs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "SetFSize for attrs rc =3D %d", =
rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((rc =3D=3D -EINVAL) || (rc =3D=3D -E=
OPNOTSUPP)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int bytes_writt=
en;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, p=
Tcon, nfid, 0, attrs->ia_size,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &bytes_written, NULL, NULL, 1);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.netfid =3D nfid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.pid =3D npid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.tcon =3D pTcon;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.offset =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.length =3D attrs-=
>ia_size;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, &=
io_parms, &bytes_written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 NULL, NULL, 1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Wrt seteof rc %=
d", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else
>> @@ -1923,10 +1930,15 @@ cifs_set_file_size(struct inode *inode, stru=
ct iattr *attrs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned=
 int bytes_written;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBWrite(xid, pTcon, netfid, 0,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 attrs->ia_size,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, NULL,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 1);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.n=
etfid =3D netfid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.p=
id =3D current->tgid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.t=
con =3D pTcon;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.o=
ffset =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.l=
ength =3D attrs->ia_size;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBWrite(xid, &io_parms,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NULL, NULL, =A01);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, =
"wrt seteof rc %d", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBC=
lose(xid, pTcon, netfid);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
>> index ce417a9..1a6a388 100644
>> --- a/fs/cifs/link.c
>> +++ b/fs/cifs/link.c
>> @@ -184,6 +184,7 @@ CIFSCreateMFSymLink(const int xid, struct cifsTc=
onInfo *tcon,
>> =A0 =A0 =A0 __u16 netfid =3D 0;
>> =A0 =A0 =A0 u8 *buf;
>> =A0 =A0 =A0 unsigned int bytes_written =3D 0;
>> + =A0 =A0 struct cifs_io_parms io_parms;
>>
>> =A0 =A0 =A0 buf =3D kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
>> =A0 =A0 =A0 if (!buf)
>> @@ -203,10 +204,13 @@ CIFSCreateMFSymLink(const int xid, struct cifs=
TconInfo *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D CIFSSMBWrite(xid, tcon, netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MF_SYMLINK_FILE_S=
IZE /* length */,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 /* offset */,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, buf, N=
ULL, 0);
>> + =A0 =A0 io_parms.netfid =3D netfid;
>> + =A0 =A0 io_parms.pid =3D current->tgid;
>> + =A0 =A0 io_parms.tcon =3D tcon;
>> + =A0 =A0 io_parms.offset =3D 0;
>> + =A0 =A0 io_parms.length =3D CIFS_MF_SYMLINK_FILE_SIZE;
>> +
>> + =A0 =A0 rc =3D CIFSSMBWrite(xid, &io_parms, &bytes_written, buf, N=
ULL, 0);
>> =A0 =A0 =A0 CIFSSMBClose(xid, tcon, netfid);
>> =A0 =A0 =A0 kfree(buf);
>> =A0 =A0 =A0 if (rc !=3D 0)
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
