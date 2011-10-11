From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: add cifs_async_readv
Date: Tue, 11 Oct 2011 13:30:14 +0400
Message-ID: <CAKywueRSTX8BT3BJymT+PdCEkVbzCEd+mV=UZa0e3-PZLej7qw@mail.gmail.com>
References: <1315319241-21637-1-git-send-email-jlayton@redhat.com>
	<1315319241-21637-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315319241-21637-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/9/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> ...which will allow cifs to do an asynchronous read call to the serve=
r.
> The caller will allocate and set up cifs_readdata for each READ_AND_X
> call that should be issued on the wire. The pages passed in are added
> to the pagecache, but not placed on the LRU list yet (as we need the
> page->lru to keep the pages on the list in the readdata).
>
> When cifsd identifies the mid, it will see that there is a special
> receive handler for the call, and use that to receive the rest of the
> frame. cifs_readv_receive will then marshal up a kvec array with
> kmapped pages from the pagecache, which eliminates one copy of the
> data. Once the data is received, the pages are added to the LRU list,
> set uptodate, and unlocked.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 24 ++++
> =A0fs/cifs/cifssmb.c =A0 | =A0356 +++++++++++++++++++++++++++++++++++=
++++++++++++++++
> =A0fs/cifs/connect.c =A0 | =A0 26 ++--
> =A03 files changed, 393 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 51c0ebc..38406e5 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -152,6 +152,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct cif=
s_sb_info *, struct inode *,
> =A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const =
char *);
>
> +extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
> +extern int cifs_read_from_socket(struct TCP_Server_Info *server, cha=
r *buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int to_read);
> +extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov_orig, unsigned int nr_=
segs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int to_read);
> =A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ci=
fs_sb_info *cifs_sb);
> =A0extern int cifs_match_super(struct super_block *, void *);
> @@ -441,6 +447,24 @@ extern int E_md4hash(const unsigned char *passwd=
, unsigned char *p16);
> =A0extern int SMBencrypt(unsigned char *passwd, const unsigned char *=
c8,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
>
> +/* asynchronous read support */
> +struct cifs_readdata {
> + =A0 =A0 =A0 struct cifsFileInfo =A0 =A0 =A0 =A0 =A0 =A0 *cfile;
> + =A0 =A0 =A0 struct address_space =A0 =A0 =A0 =A0 =A0 =A0*mapping;
> + =A0 =A0 =A0 __u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 offset;
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0byt=
es;
> + =A0 =A0 =A0 pid_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 pid;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 result;
> + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pages;
> + =A0 =A0 =A0 struct work_struct =A0 =A0 =A0 =A0 =A0 =A0 =A0work;
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_=
iov;
> + =A0 =A0 =A0 struct kvec =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov=
[1];
> +};
> +
> +struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
> +void cifs_readdata_free(struct cifs_readdata *rdata);
> +int cifs_async_readv(struct cifs_readdata *rdata);
> +
> =A0/* asynchronous write support */
> =A0struct cifs_writedata {
> =A0 =A0 =A0 =A0struct kref =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 re=
fcount;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index ae1ce01..ac72f28 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -33,6 +33,8 @@
> =A0#include <linux/slab.h>
> =A0#include <linux/posix_acl_xattr.h>
> =A0#include <linux/pagemap.h>
> +#include <linux/swap.h>
> +#include <linux/task_io_accounting_ops.h>
> =A0#include <asm/uaccess.h>
> =A0#include "cifspdu.h"
> =A0#include "cifsglob.h"
> @@ -40,6 +42,7 @@
> =A0#include "cifsproto.h"
> =A0#include "cifs_unicode.h"
> =A0#include "cifs_debug.h"
> +#include "fscache.h"
>
> =A0#ifdef CONFIG_CIFS_POSIX
> =A0static struct {
> @@ -83,6 +86,9 @@ static struct {
> =A0#endif /* CONFIG_CIFS_WEAK_PW_HASH */
> =A0#endif /* CIFS_POSIX */
>
> +/* Forward declarations */
> +static void cifs_readv_complete(struct work_struct *work);
> +
> =A0/* Mark as invalid, all open files on tree connections since they
> =A0 =A0were closed when session to server was lost */
> =A0static void mark_open_files_invalid(struct cifs_tcon *pTcon)
> @@ -1375,6 +1381,356 @@ openRetry:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +struct cifs_readdata *
> +cifs_readdata_alloc(unsigned int nr_pages)
> +{
> + =A0 =A0 =A0 struct cifs_readdata *rdata;
> +
> + =A0 =A0 =A0 /* readdata + 1 kvec for each page */
> + =A0 =A0 =A0 rdata =3D kzalloc(sizeof(*rdata) +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct kvec) * n=
r_pages, GFP_KERNEL);
> + =A0 =A0 =A0 if (rdata !=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&rdata->work, cifs_readv_comp=
lete);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&rdata->pages);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return rdata;
> +}
> +
> +void
> +cifs_readdata_free(struct cifs_readdata *rdata)
> +{
> + =A0 =A0 =A0 cifsFileInfo_put(rdata->cfile);
> + =A0 =A0 =A0 kfree(rdata);
> +}
> +
> +/*
> + * Discard any remaining data in the current SMB. To do this, we bor=
row the
> + * current bigbuf.
> + */
> +static int
> +cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entr=
y *mid)
> +{
> + =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
> + =A0 =A0 =A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_buf_le=
ngth);
> + =A0 =A0 =A0 int remaining =3D rfclen + 4 - server->total_read;
> + =A0 =A0 =A0 struct cifs_readdata *rdata =3D mid->callback_data;
> +
> + =A0 =A0 =A0 while (remaining > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int length;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D cifs_read_from_socket(server=
, server->bigbuf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min_t(u=
nsigned int, remaining,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->total_read +=3D length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 remaining -=3D length;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 dequeue_mid(mid, rdata->result);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int
> +cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entr=
y *mid)
> +{
> + =A0 =A0 =A0 int length, len;
> + =A0 =A0 =A0 unsigned int data_offset, remaining, data_len;
> + =A0 =A0 =A0 struct cifs_readdata *rdata =3D mid->callback_data;
> + =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
> + =A0 =A0 =A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_buf_le=
ngth) + 4;
> + =A0 =A0 =A0 u64 eof;
> + =A0 =A0 =A0 pgoff_t eof_index;
> + =A0 =A0 =A0 struct page *page, *tpage;
> +
> + =A0 =A0 =A0 cFYI(1, "%s: mid=3D%u offset=3D%llu bytes=3D%u", __func=
__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid, rdata->offset, rdata->bytes);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* read the rest of READ_RSP header (sans Data array)=
, or whatever we
> + =A0 =A0 =A0 =A0* can if there's not enough data. At this point, we'=
ve read down to
> + =A0 =A0 =A0 =A0* the Mid.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 len =3D min_t(unsigned int, rfclen, sizeof(*rsp)) -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct smb_hdr) =
+ 1;
> +
> + =A0 =A0 =A0 rdata->iov[0].iov_base =3D server->smallbuf + sizeof(st=
ruct smb_hdr) - 1;
> + =A0 =A0 =A0 rdata->iov[0].iov_len =3D len;
> +
> + =A0 =A0 =A0 length =3D cifs_readv_from_socket(server, rdata->iov, 1=
, len);
> + =A0 =A0 =A0 if (length < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return length;
> + =A0 =A0 =A0 server->total_read +=3D length;
> +
> + =A0 =A0 =A0 /* Was the SMB read successful? */
> + =A0 =A0 =A0 rdata->result =3D map_smb_to_linux_error(&rsp->hdr, fal=
se);
> + =A0 =A0 =A0 if (rdata->result !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: server returned error %d",=
 __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_readv_discard(server, mid);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Is there enough to get to the rest of the READ_RSP h=
eader? */
> + =A0 =A0 =A0 if (server->total_read < sizeof(READ_RSP)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: server returned short head=
er. got=3D%u expected=3D%lu",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, server->total=
_read, sizeof(READ_RSP));

sizeof should be casted to unsigned long to prevent compiler warnings.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_readv_discard(server, mid);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 data_offset =3D le16_to_cpu(rsp->DataOffset) + 4;
> + =A0 =A0 =A0 if (data_offset < server->total_read) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* win2k8 sometimes sends an offset o=
f 0 when the read
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is beyond the EOF. Treat it as if =
the data starts just after
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the header.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: data offset (%u) inside re=
ad response header",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, data_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_offset =3D server->total_read;
> + =A0 =A0 =A0 } else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* data_offset is beyond the end of sma=
llbuf */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: data offset (%u) beyond en=
d of smallbuf",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, data_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_readv_discard(server, mid);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 cFYI(1, "%s: total_read=3D%u data_offset=3D%u", __func_=
_,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->total_read, data_offset);
> +
> + =A0 =A0 =A0 len =3D data_offset - server->total_read;
> + =A0 =A0 =A0 if (len > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* read any junk before data into the r=
est of smallbuf */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[0].iov_base =3D server->smal=
lbuf + server->total_read;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[0].iov_len =3D len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D cifs_readv_from_socket(serve=
r, rdata->iov, 1, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->total_read +=3D length;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* set up first iov for signature check */
> + =A0 =A0 =A0 rdata->iov[0].iov_base =3D server->smallbuf;
> + =A0 =A0 =A0 rdata->iov[0].iov_len =3D server->total_read;
> + =A0 =A0 =A0 cFYI(1, "0: iov_base=3D%p iov_len=3D%lu",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[0].iov_base, rdata->iov[0].i=
ov_len);

iov_len should be casted to unsigned long to prevent compiler warnings.

> +
> + =A0 =A0 =A0 /* how much data is in the response? */
> + =A0 =A0 =A0 data_len =3D le16_to_cpu(rsp->DataLengthHigh) << 16;
> + =A0 =A0 =A0 data_len +=3D le16_to_cpu(rsp->DataLength);
> + =A0 =A0 =A0 if (data_offset + data_len > rfclen) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* data_len is corrupt -- discard frame=
 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_readv_discard(server, mid);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* marshal up the page array */
> + =A0 =A0 =A0 len =3D 0;
> + =A0 =A0 =A0 remaining =3D data_len;
> + =A0 =A0 =A0 rdata->nr_iov =3D 1;
> +
> + =A0 =A0 =A0 /* determine the eof that the server (probably) has */
> + =A0 =A0 =A0 eof =3D CIFS_I(rdata->mapping->host)->server_eof;
> + =A0 =A0 =A0 eof_index =3D eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
> + =A0 =A0 =A0 cFYI(1, "eof=3D%llu eof_index=3D%lu", eof, eof_index);
> +
> + =A0 =A0 =A0 list_for_each_entry_safe(page, tpage, &rdata->pages, lr=
u) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (remaining >=3D PAGE_CACHE_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* enough data to fill =
the page */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[rdata->nr_io=
v].iov_base =3D kmap(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[rdata->nr_io=
v].iov_len =3D PAGE_CACHE_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%u: idx=3D%lu =
iov_base=3D%p iov_len=3D%lu",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->=
nr_iov, page->index,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->=
iov[rdata->nr_iov].iov_base,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->=
iov[rdata->nr_iov].iov_len);

iov_len should be casted to unsigned long to prevent compiler warnings.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++rdata->nr_iov;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len +=3D PAGE_CACHE_SIZ=
E;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 remaining -=3D PAGE_CAC=
HE_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (remaining > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* enough for partial p=
age, fill and zero the rest */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[rdata->nr_io=
v].iov_base =3D kmap(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->iov[rdata->nr_io=
v].iov_len =3D remaining;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%u: idx=3D%lu =
iov_base=3D%p iov_len=3D%lu",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->=
nr_iov, page->index,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->=
iov[rdata->nr_iov].iov_base,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->=
iov[rdata->nr_iov].iov_len);

iov_len should be casted to unsigned long to prevent compiler warnings.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(rdata->iov[rdata=
->nr_iov].iov_base + remaining,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 '\0', P=
AGE_CACHE_SIZE - remaining);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++rdata->nr_iov;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len +=3D remaining;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 remaining =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (page->index > eof_index) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The VFS will not t=
ry to do readahead past the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* i_size, but it's p=
ossible that we have outstanding
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* writes with gaps i=
n the middle and the i_size hasn't
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* caught up yet. Pop=
ulate those with zeroed out pages
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to prevent the VFS=
 from repeatedly attempting to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fill them until th=
e writes are flushed.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_user(page, 0, PAGE=
_CACHE_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&page->lru);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_cache_add_file(page=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_dcache_page(page)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no need to hold page=
 hostage */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&page->lru);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_cache_add_file(page=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* issue the read if we have any iovecs left to fill */
> + =A0 =A0 =A0 if (rdata->nr_iov > 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D cifs_readv_from_socket(serve=
r, &rdata->iov[1],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 rdata->nr_iov - 1, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->total_read +=3D length;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 rdata->bytes =3D length;
> +
> + =A0 =A0 =A0 cFYI(1, "total_read=3D%u rfclen=3D%u remaining=3D%u", s=
erver->total_read,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfclen, remaining);
> +
> + =A0 =A0 =A0 /* discard anything left over */
> + =A0 =A0 =A0 if (server->total_read < rfclen)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_readv_discard(server, mid);
> +
> + =A0 =A0 =A0 dequeue_mid(mid, false);
> + =A0 =A0 =A0 return length;
> +}
> +
> +static void
> +cifs_readv_complete(struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct cifs_readdata *rdata =3D container_of(work,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_readdata, work);
> + =A0 =A0 =A0 struct page *page, *tpage;
> +
> + =A0 =A0 =A0 list_for_each_entry_safe(page, tpage, &rdata->pages, lr=
u) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&page->lru);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_cache_add_file(page);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rdata->result =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_dcache_page(page)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_readpage_to_fscach=
e(rdata->mapping->host, page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 cifs_readdata_free(rdata);
> +}
> +
> +static void
> +cifs_readv_callback(struct mid_q_entry *mid)
> +{
> + =A0 =A0 =A0 struct cifs_readdata *rdata =3D mid->callback_data;
> + =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(rdata->cfile->tli=
nk);
> + =A0 =A0 =A0 struct TCP_Server_Info *server =3D tcon->ses->server;
> +
> + =A0 =A0 =A0 cFYI(1, "%s: mid=3D%u state=3D%d result=3D%d bytes=3D%u=
", __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid, mid->midState, rdata->result,=
 rdata->bytes);
> +
> + =A0 =A0 =A0 switch (mid->midState) {
> + =A0 =A0 =A0 case MID_RESPONSE_RECEIVED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* result already set, check signature =
*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->sec_mode &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED | SECMOD=
E_SIGN_ENABLED)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_verify_signatu=
re(rdata->iov, rdata->nr_iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 server, mid->sequence_number + 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Unexpected SMB signature");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: should this be counted toward=
 the initiating task? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_io_account_read(rdata->bytes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_bytes_read(tcon, rdata->byte=
s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case MID_REQUEST_SUBMITTED:
> + =A0 =A0 =A0 case MID_RETRY_NEEDED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result =3D -EAGAIN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result =3D -EIO;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 queue_work(system_nrt_wq, &rdata->work);
> + =A0 =A0 =A0 DeleteMidQEntry(mid);
> + =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 wake_up(&server->request_q);
> +}
> +
> +/* cifs_async_readv - send an async write, and set up mid to handle =
result */
> +int
> +cifs_async_readv(struct cifs_readdata *rdata)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 READ_REQ *smb =3D NULL;
> + =A0 =A0 =A0 int wct;
> + =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(rdata->cfile->tli=
nk);
> +
> + =A0 =A0 =A0 cFYI(1, "%s: offset=3D%llu bytes=3D%u", __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->offset, rdata->bytes);
> +
> + =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_LARGE_FILES)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wct =3D 12;
> + =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wct =3D 10; /* old style read */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((rdata->offset >> 32) > 0) =A0{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* can not handle this =
big offset for old */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 rc =3D small_smb_init(SMB_COM_READ_ANDX, wct, tcon, (vo=
id **)&smb);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 smb->hdr.Pid =3D cpu_to_le16((__u16)rdata->pid);
> + =A0 =A0 =A0 smb->hdr.PidHigh =3D cpu_to_le16((__u16)(rdata->pid >> =
16));
> +
> + =A0 =A0 =A0 smb->AndXCommand =3D 0xFF; =A0 =A0 =A0 =A0/* none */
> + =A0 =A0 =A0 smb->Fid =3D rdata->cfile->netfid;
> + =A0 =A0 =A0 smb->OffsetLow =3D cpu_to_le32(rdata->offset & 0xFFFFFF=
=46F);
> + =A0 =A0 =A0 if (wct =3D=3D 12)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->OffsetHigh =3D cpu_to_le32(rdata->=
offset >> 32);
> + =A0 =A0 =A0 smb->Remaining =3D 0;
> + =A0 =A0 =A0 smb->MaxCount =3D cpu_to_le16(rdata->bytes & 0xFFFF);
> + =A0 =A0 =A0 smb->MaxCountHigh =3D cpu_to_le32(rdata->bytes >> 16);
> + =A0 =A0 =A0 if (wct =3D=3D 12)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->ByteCount =3D 0;
> + =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* old style read */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_com_readx_req *smbr =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_com_readx_r=
eq *)smb;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smbr->ByteCount =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* 4 for RFC1001 length + 1 for BCC */
> + =A0 =A0 =A0 rdata->iov[0].iov_base =3D smb;
> + =A0 =A0 =A0 rdata->iov[0].iov_len =3D be32_to_cpu(smb->hdr.smb_buf_=
length) + 4;
> +
> + =A0 =A0 =A0 rc =3D cifs_call_async(tcon->ses->server, rdata->iov, 1=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_readv_r=
eceive, cifs_readv_callback,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, false=
);
> +
> + =A0 =A0 =A0 if (rc =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_reads);
> +
> + =A0 =A0 =A0 cifs_small_buf_release(smb);
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0int
> =A0CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigne=
d int *nbytes,
> =A0 =A0 =A0 =A0 =A0 =A0char **buf, int *pbuf_type)
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5dc6df0..6f663ea 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -422,9 +422,9 @@ get_server_iovec(struct TCP_Server_Info *server, =
unsigned int nr_segs)
> =A0 =A0 =A0 =A0return new_iov;
> =A0}
>
> -static int
> -readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_o=
rig,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nr_segs, unsigned int =
to_read)
> +int
> +cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *=
iov_orig,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nr_segs, un=
signed int to_read)
> =A0{
> =A0 =A0 =A0 =A0int length =3D 0;
> =A0 =A0 =A0 =A0int total_read;
> @@ -479,16 +479,16 @@ readv_from_socket(struct TCP_Server_Info *serve=
r, struct kvec *iov_orig,
> =A0 =A0 =A0 =A0return total_read;
> =A0}
>
> -static int
> -read_from_socket(struct TCP_Server_Info *server, char *buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int to_read)
> +int
> +cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int to_read)
> =A0{
> =A0 =A0 =A0 =A0struct kvec iov;
>
> =A0 =A0 =A0 =A0iov.iov_base =3D buf;
> =A0 =A0 =A0 =A0iov.iov_len =3D to_read;
>
> - =A0 =A0 =A0 return readv_from_socket(server, &iov, 1, to_read);
> + =A0 =A0 =A0 return cifs_readv_from_socket(server, &iov, 1, to_read)=
;
> =A0}
>
> =A0static bool
> @@ -553,8 +553,8 @@ find_mid(struct TCP_Server_Info *server, struct s=
mb_hdr *buf)
> =A0 =A0 =A0 =A0return NULL;
> =A0}
>
> -static void
> -dequeue_mid(struct mid_q_entry *mid, int malformed)
> +void
> +dequeue_mid(struct mid_q_entry *mid, bool malformed)
> =A0{
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0mid->when_received =3D jiffies;
> @@ -731,7 +731,7 @@ standard_receive3(struct TCP_Server_Info *server,=
 struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* now read the rest */
> - =A0 =A0 =A0 length =3D read_from_socket(server,
> + =A0 =A0 =A0 length =3D cifs_read_from_socket(server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf + sizeof(struc=
t smb_hdr) - 1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length - sizeo=
f(struct smb_hdr) + 1 + 4);
> =A0 =A0 =A0 =A0if (length < 0)
> @@ -792,7 +792,7 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf =3D server->smallbuf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length =3D 4; /* enough to get RFC=
1001 header */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D read_from_socket(server, buf=
, pdu_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D cifs_read_from_socket(server=
, buf, pdu_length);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (length < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->total_read =3D length;
> @@ -817,8 +817,8 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* read down to the MID */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D read_from_socket(server, buf=
 + 4,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 sizeof(struct smb_hdr) - 1 - 4);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D cifs_read_from_socket(server=
, buf + 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct smb_hdr) - 1 - 4);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (length < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->total_read +=3D length;
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
