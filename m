From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Forward pid of process who opened file to writepages
Date: Mon, 2 May 2011 19:29:18 +0400
Message-ID: <BANLkTikVtW5mw1dit+m92KO6AHaOxURkNw@mail.gmail.com>
References: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303392395-9217-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/21 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> We need it to make write work with mandatory locking style because
> we can fail when kernel need to flush dirty pages and there is a lock
> held by process who opened file.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A07 ++++---
> =A0fs/cifs/cifssmb.c =A0 | =A0 12 ++++++++----
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 20 +++++++++++---------
> =A03 files changed, 23 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 76c4dc7..a2eb860 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -344,9 +344,10 @@ extern int CIFSSMBWrite(const int xid, struct ci=
fs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *buf, const=
 char __user *ubuf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const int long_op);
> =A0extern int CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 unsigned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 offset, uns=
igned int *nbytes,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, const=
 int nvec, const int long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 __u32 netpid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned int coun=
t, const __u64 offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, s=
truct kvec *iov, const int nvec,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
> =A0extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *=
tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *s=
earchName, __u64 *inode_number,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table=
 *nls_codepage,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 3291770..17d1cbf 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1603,10 +1603,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon =
*tcon,
> =A0}
>
> =A0int
> -CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, st=
ruct kvec *iov,
> - =A0 =A0 =A0 =A0 =A0 =A0int n_vec, const int long_op)
> +CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon, const int netfi=
d,
> + =A0 =A0 =A0 =A0 =A0 =A0 const __u32 netpid, const unsigned int coun=
t, const __u64 offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, struct kvec *iov, int=
 n_vec,
> + =A0 =A0 =A0 =A0 =A0 =A0 const int long_op)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D -EACCES;
> =A0 =A0 =A0 =A0WRITE_REQ *pSMB =3D NULL;
> @@ -1630,6 +1630,10 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon =
*tcon,
> =A0 =A0 =A0 =A0rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (=
void **) &pSMB);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> +
> + =A0 =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
> + =A0 =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16)=
);
> +
> =A0 =A0 =A0 =A0/* tcon and ses pointer are checked in smb_init */
> =A0 =A0 =A0 =A0if (tcon->ses->server =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECONNABORTED;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9c7f83f..838f06c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -857,7 +857,7 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff=
_t offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsi->server_eof =3D end_of_write;
> =A0}
>
> -static ssize_t cifs_write(struct cifsFileInfo *open_file,
> +static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 netp=
id,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *write_=
data, size_t write_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t *poffset)
> =A0{
> @@ -901,8 +901,9 @@ static ssize_t cifs_write(struct cifsFileInfo *op=
en_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* iov[0] is reserved =
for smb header */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov[1].iov_base =3D (c=
har *)write_data + total_written;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov[1].iov_len =3D len=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xi=
d, pTcon, open_file->netfid, len,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 *poffset, &bytes_written, iov, 1, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xi=
d, pTcon, open_file->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0netpid, len, *poffset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0&bytes_written, iov, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || (bytes_written =3D=3D 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (total_written)
> @@ -1071,8 +1072,8 @@ static int cifs_partialpagewrite(struct page *p=
age, unsigned from, unsigned to)
>
> =A0 =A0 =A0 =A0open_file =3D find_writable_file(CIFS_I(mapping->host)=
, false);
> =A0 =A0 =A0 =A0if (open_file) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_written =3D cifs_write(open_file,=
 write_data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0to - from, &offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_written =3D cifs_write(open_file,=
 open_file->pid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0write_data, to - from, &offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFileInfo_put(open_file);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Does mm or vfs already set times? *=
/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_atime =3D inode->i_mtime =3D =
current_fs_time(inode->i_sb);
> @@ -1252,6 +1253,7 @@ retry_write:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EBADF;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 CIFSSMBWrite2(xid, tcon, open_file->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file->pid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_to_write, offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, iov, n_iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0);
> @@ -1391,8 +1393,8 @@ static int cifs_write_end(struct file *file, st=
ruct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB check if anything else missing o=
ut of ppw
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 such as updating last write time =
*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_data =3D kmap(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_write(file->private_data, p=
age_data + offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied,=
 &pos);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_write(file->private_data, c=
urrent->tgid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_da=
ta + offset, copied, &pos);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* if (rc < 0) should we set writebehi=
nd rc? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kunmap(page);
>
> @@ -1625,8 +1627,8 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBWrite2(x=
id, pTcon, open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0cur_len, *poffset, &written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0to_send, npages, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0current->tgid, cur_len, *poffset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0&written, to_send, npages, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (rc =3D=3D -EAGAIN);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < npages; i++)
> --
> 1.7.1
>
>

Jeff, you put "Acked-by" tag on 2/2 patch - could you comment on this
1/2, please?

--=20
Best regards,
Pavel Shilovsky.
