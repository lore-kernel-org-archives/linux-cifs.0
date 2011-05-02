From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Forward pid of process who opened file to writepages
Date: Mon, 2 May 2011 21:08:58 +0400
Message-ID: <BANLkTi=cne54kR-2VBzkvw+nB_yLraGZoA@mail.gmail.com>
References: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
	<20110502125106.32eebaa2@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502125106.32eebaa2-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/2 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Thu, 21 Apr 2011 17:26:34 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> We need it to make write work with mandatory locking style because
>> we can fail when kernel need to flush dirty pages and there is a loc=
k
>> held by process who opened file.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsproto.h | =A0 =A07 ++++---
>> =A0fs/cifs/cifssmb.c =A0 | =A0 12 ++++++++----
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 20 +++++++++++---------
>> =A03 files changed, 23 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 76c4dc7..a2eb860 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -344,9 +344,10 @@ extern int CIFSSMBWrite(const int xid, struct c=
ifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *buf, const c=
har __user *ubuf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
>> =A0extern int CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const un=
signed int count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 offset, unsign=
ed int *nbytes,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, const in=
t nvec, const int long_op);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const __=
u32 netpid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned int count, =
const __u64 offset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, stru=
ct kvec *iov, const int nvec,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
>> =A0extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon =
*tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *sea=
rchName, __u64 *inode_number,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *=
nls_codepage,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 3291770..17d1cbf 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -1603,10 +1603,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon=
 *tcon,
>> =A0}
>>
>> =A0int
>> -CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
>> - =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, struc=
t kvec *iov,
>> - =A0 =A0 =A0 =A0 =A0int n_vec, const int long_op)
>> +CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon, const int netf=
id,
>> + =A0 =A0 =A0 =A0 =A0 const __u32 netpid, const unsigned int count, =
const __u64 offset,
>> + =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, struct kvec *iov, int n_=
vec,
>> + =A0 =A0 =A0 =A0 =A0 const int long_op)
>
> Bleh, this argument list is getting to be huge. Some of these could b=
e
> dropped (specifically, the tcon, netfid, and netpid) if you passed in
> the cifsFileInfo pointer instead. Is there any reason not to do that
> here?
>

I agree - it is huge even without my patch. We have a lot of places
like that in cifs code - so, I can only guess it was an idea to give
CIFSSMB* functions all arguments as separate fields. If we change it
we should change all calls like that and it should be separate patch.
Cleanup all these calls is a good idea for next patch, I think, not
for this one.

>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> =A0 =A0 =A0 WRITE_REQ *pSMB =3D NULL;
>> @@ -1630,6 +1630,10 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon=
 *tcon,
>> =A0 =A0 =A0 rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (vo=
id **) &pSMB);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
>> + =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16));
>> +
>> =A0 =A0 =A0 /* tcon and ses pointer are checked in smb_init */
>> =A0 =A0 =A0 if (tcon->ses->server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECONNABORTED;
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 9c7f83f..838f06c 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -857,7 +857,7 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, lof=
f_t offset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsi->server_eof =3D end_of_write;
>> =A0}
>>
>> -static ssize_t cifs_write(struct cifsFileInfo *open_file,
>> +static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 net=
pid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *write_da=
ta, size_t write_size,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t *poffset)
>> =A0{
>> @@ -901,8 +901,9 @@ static ssize_t cifs_write(struct cifsFileInfo *o=
pen_file,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* iov[0] is reserved fo=
r smb header */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D (cha=
r *)write_data + total_written;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_len =3D len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid, len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 *poffset, &bytes_written, iov, 1, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0netpid, len, *poffset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&bytes_written, iov, 1, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (bytes_written =3D=3D 0)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_written)
>> @@ -1071,8 +1072,8 @@ static int cifs_partialpagewrite(struct page *=
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
>> @@ -1252,6 +1253,7 @@ retry_write:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
EBADF;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D C=
IFSSMBWrite2(xid, tcon, open_file->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file->pid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes_to_write, offset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, iov, n_iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
>> @@ -1391,8 +1393,8 @@ static int cifs_write_end(struct file *file, s=
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
>> @@ -1625,8 +1627,8 @@ cifs_iovec_write(struct file *file, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid=
, pTcon, open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_len, *poffset, &written,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0to_send, npages, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0current->tgid, cur_len, *poffset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&written, to_send, npages, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (rc =3D=3D -EAGAIN);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++)
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
