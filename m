From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 13/13] cifs: remove code for setting timeouts on requests
Date: Tue, 14 Dec 2010 10:25:38 +0300
Message-ID: <AANLkTinfGG7nt9osbihgN+RiBZiDDM5tJWFHKniukbw3@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-14-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-14-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Since we don't time out individual requests anymore, remove the code
> that we used to use for setting timeouts on different requests.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h =A0| =A0 =A09 +++------
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A08 ++++----
> =A0fs/cifs/connect.c =A0 | =A0 =A02 +-
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 44 +++++++------------------------=
-------------
> =A0fs/cifs/sess.c =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/cifs/transport.c | =A0 =A02 +-
> =A06 files changed, 17 insertions(+), 50 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index d924f3c..1e290fa 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -631,12 +631,9 @@ static inline void free_dfs_info_array(struct df=
s_info3_param *param,
> =A0#define =A0 CIFS_IOVEC =A0 =A0 =A0 =A0 =A0 =A04 =A0 =A0/* array of=
 response buffers */
>
> =A0/* Type of Request to SendReceive2 */
> -#define =A0 CIFS_STD_OP =A0 =A0 =A0 =A0 =A00 =A0 =A0/* normal reques=
t timeout */
> -#define =A0 CIFS_LONG_OP =A0 =A0 =A0 =A0 =A01 =A0 =A0/* long op (up =
to 45 sec, oplock time) */
> -#define =A0 CIFS_VLONG_OP =A0 =A0 =A0 =A0 2 =A0 =A0/* sloow op - can=
 take up to 180 seconds */
> -#define =A0 CIFS_BLOCKING_OP =A0 =A0 =A04 =A0 =A0/* operation can bl=
ock */
> -#define =A0 CIFS_ASYNC_OP =A0 =A0 =A0 =A0 8 =A0 =A0/* do not wait fo=
r response */
> -#define =A0 CIFS_TIMEOUT_MASK 0x00F =A0 =A0/* only one of 5 above se=
t in req */
> +#define =A0 CIFS_BLOCKING_OP =A0 =A0 =A01 =A0 =A0/* operation can bl=
ock */
> +#define =A0 CIFS_ASYNC_OP =A0 =A0 =A0 =A0 2 =A0 =A0/* do not wait fo=
r response */
> +#define =A0 CIFS_TIMEOUT_MASK 0x003 =A0 =A0/* only one of above set =
in req */
> =A0#define =A0 CIFS_LOG_ERROR =A0 =A00x010 =A0 =A0/* log NT STATUS if=
 non-zero */
> =A0#define =A0 CIFS_LARGE_BUF_OP 0x020 =A0 =A0/* large request buffer=
 */
> =A0#define =A0 CIFS_NO_RESP =A0 =A0 =A00x040 =A0 =A0/* no response bu=
ffer required */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index fc8145f..606deba 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1240,7 +1240,7 @@ OldOpenRetry:
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
> =A0 =A0 =A0 =A0/* long_op set to 1 to allow for oplock break timeouts=
 */
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr=
, &bytes_returned, CIFS_LONG_OP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr=
, &bytes_returned, 0);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_opens);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Error in Open =3D %d", rc);
> @@ -1353,7 +1353,7 @@ openRetry:
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
> =A0 =A0 =A0 =A0/* long_op set to 1 to allow for oplock break timeouts=
 */
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr=
, &bytes_returned, CIFS_LONG_OP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr=
, &bytes_returned, 0);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_opens);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Error in Open =3D %d", rc);
> @@ -1435,7 +1435,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo =
*tcon, const int netfid,
> =A0 =A0 =A0 =A0iov[0].iov_base =3D (char *)pSMB;
> =A0 =A0 =A0 =A0iov[0].iov_len =3D pSMB->hdr.smb_buf_length + 4;
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iove=
cs */,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&resp_buf_type, CIFS=
_STD_OP | CIFS_LOG_ERROR);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&resp_buf_type, CIFS=
_LOG_ERROR);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_reads);
> =A0 =A0 =A0 =A0pSMBr =3D (READ_RSP *)iov[0].iov_base;
> =A0 =A0 =A0 =A0if (rc) {
> @@ -3030,7 +3030,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTco=
nInfo *tcon, __u16 fid,
> =A0 =A0 =A0 =A0iov[0].iov_len =3D pSMB->hdr.smb_buf_length + 4;
>
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iove=
c */, &buf_type,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_acl_get);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Send error in QuerySecDesc =3D=
 %d", rc);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c596515..b8fb112 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3134,7 +3134,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, ses, smb_buffer, smb_buffer_re=
sponse, &length,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
>
> =A0 =A0 =A0 =A0/* above now done in SendReceive */
> =A0 =A0 =A0 =A0if ((rc =3D=3D 0) && (tcon !=3D NULL)) {
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8e57370..5c7b4f0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -892,29 +892,6 @@ int cifs_lock(struct file *file, int cmd, struct=
 file_lock *pfLock)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -/*
> - * Set the timeout on write requests past EOF. For some servers (Win=
dows)
> - * these calls can be very long.
> - *
> - * If we're writing >10M past the EOF we give a 180s timeout. Anythi=
ng less
> - * than that gets a 45s timeout. Writes not past EOF get 15s timeout=
s.
> - * The 10M cutoff is totally arbitrary. A better scheme for this wou=
ld be
> - * welcome if someone wants to suggest one.
> - *
> - * We may be able to do a better job with this if there were some wa=
y to
> - * declare that a file should be sparse.
> - */
> -static int
> -cifs_write_timeout(struct cifsInodeInfo *cifsi, loff_t offset)
> -{
> - =A0 =A0 =A0 if (offset <=3D cifsi->server_eof)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return CIFS_STD_OP;
> - =A0 =A0 =A0 else if (offset > (cifsi->server_eof + (10 * 1024 * 102=
4)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return CIFS_VLONG_OP;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return CIFS_LONG_OP;
> -}
> -
> =A0/* update the file size (if needed) after a write */
> =A0static void
> =A0cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
> @@ -935,7 +912,7 @@ ssize_t cifs_user_write(struct file *file, const =
char __user *write_data,
> =A0 =A0 =A0 =A0unsigned int total_written;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 int xid, long_op;
> + =A0 =A0 =A0 int xid;
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
>
> @@ -956,7 +933,6 @@ ssize_t cifs_user_write(struct file *file, const =
char __user *write_data,
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 long_op =3D cifs_write_timeout(cifsi, *poffset);
> =A0 =A0 =A0 =A0for (total_written =3D 0; write_size > total_written;
> =A0 =A0 =A0 =A0 =A0 =A0 total_written +=3D bytes_written) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> @@ -984,7 +960,7 @@ ssize_t cifs_user_write(struct file *file, const =
char __user *write_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0min_t(=
const int, cifs_sb->wsize,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0write_size - total_written),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*poffs=
et, &bytes_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, w=
rite_data + total_written, long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, w=
rite_data + total_written, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || (bytes_written =3D=3D 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (total_written)
> @@ -997,8 +973,6 @@ ssize_t cifs_user_write(struct file *file, const =
char __user *write_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_update_eof(cifsi,=
 *poffset, bytes_written);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*poffset +=3D bytes_wr=
itten;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op =3D CIFS_STD_OP; /* subsequent =
writes fast -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 15 seconds is plenty */
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cifs_stats_bytes_written(pTcon, total_written);
> @@ -1027,7 +1001,7 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
> =A0 =A0 =A0 =A0unsigned int total_written;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 int xid, long_op;
> + =A0 =A0 =A0 int xid;
> =A0 =A0 =A0 =A0struct dentry *dentry =3D open_file->dentry;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsi =3D CIFS_I(dentry->d_inode=
);
>
> @@ -1040,7 +1014,6 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 long_op =3D cifs_write_timeout(cifsi, *poffset);
> =A0 =A0 =A0 =A0for (total_written =3D 0; write_size > total_written;
> =A0 =A0 =A0 =A0 =A0 =A0 total_written +=3D bytes_written) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> @@ -1070,7 +1043,7 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 CIFSSMBWrite2(xid, pTcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0open_file->netfid, len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0*poffset, &bytes_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 iov, 1, long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 iov, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 CIFSSMBWrite(xid, pTcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 open_file->netfid,
> @@ -1078,7 +1051,7 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 write_size - total_written),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 *poffset, &bytes_written,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 write_data + total_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0NULL, long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0NULL, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || (bytes_written =3D=3D 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (total_written)
> @@ -1091,8 +1064,6 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_update_eof(cifsi,=
 *poffset, bytes_written);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*poffset +=3D bytes_wr=
itten;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op =3D CIFS_STD_OP; /* subsequent =
writes fast -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 15 seconds is plenty */
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cifs_stats_bytes_written(pTcon, total_written);
> @@ -1292,7 +1263,7 @@ static int cifs_writepages(struct address_space=
 *mapping,
> =A0 =A0 =A0 =A0struct pagevec pvec;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int scanned =3D 0;
> - =A0 =A0 =A0 int xid, long_op;
> + =A0 =A0 =A0 int xid;
>
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(mapping->host->i_sb);
>
> @@ -1437,11 +1408,10 @@ retry_write:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "No writable handles for inode");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EBADF;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op=
 =3D cifs_write_timeout(cifsi, offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 CIFSSMBWrite2(xid, tcon, open_file->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_to_write, offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, iov, n_iov,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFi=
leInfo_put(open_file);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_u=
pdate_eof(cifsi, offset, bytes_written);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 2997533..50b74a5 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -881,7 +881,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0BCC_LE(smb_buf) =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, ses, iov, 3 /* num_iovecs */,=
 &resp_buf_type,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_STD_OP /* not =
long */ | CIFS_LOG_ERROR);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_LOG_ERROR);
> =A0 =A0 =A0 =A0/* SMB request buf freed in SendReceive2 */
>
> =A0 =A0 =A0 =A0pSMB =3D (SESSION_SETUP_ANDX *)iov[0].iov_base;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 2a0b14d..70873ab 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -791,7 +791,7 @@ send_lock_cancel(const unsigned int xid, struct c=
ifsTconInfo *tcon,
> =A0 =A0 =A0 =A0pSMB->hdr.Mid =3D GetNextMid(ses->server);
>
> =A0 =A0 =A0 =A0return SendReceive(xid, ses, in_buf, out_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_returned, CIFS_S=
TD_OP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_returned, 0);
> =A0}
>
> =A0int
> --
> 1.7.3.2
>

Good. Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
