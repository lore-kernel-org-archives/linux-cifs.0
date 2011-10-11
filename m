From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: add cifs_async_readv
Date: Tue, 11 Oct 2011 06:26:17 -0400
Message-ID: <20111011062617.25376724@tlielax.poochiereds.net>
References: <1315319241-21637-1-git-send-email-jlayton@redhat.com>
	<1315319241-21637-3-git-send-email-jlayton@redhat.com>
	<CAKywueRSTX8BT3BJymT+PdCEkVbzCEd+mV=UZa0e3-PZLej7qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRSTX8BT3BJymT+PdCEkVbzCEd+mV=UZa0e3-PZLej7qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 13:30:14 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/9/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > ...which will allow cifs to do an asynchronous read call to the ser=
ver.
> > The caller will allocate and set up cifs_readdata for each READ_AND=
_X
> > call that should be issued on the wire. The pages passed in are add=
ed
> > to the pagecache, but not placed on the LRU list yet (as we need th=
e
> > page->lru to keep the pages on the list in the readdata).
> >
> > When cifsd identifies the mid, it will see that there is a special
> > receive handler for the call, and use that to receive the rest of t=
he
> > frame. cifs_readv_receive will then marshal up a kvec array with
> > kmapped pages from the pagecache, which eliminates one copy of the
> > data. Once the data is received, the pages are added to the LRU lis=
t,
> > set uptodate, and unlocked.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsproto.h | =C2=A0 24 ++++
> > =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0356 ++++++++++++++++++++++++=
+++++++++++++++++++++++++++
> > =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0 26 ++--
> > =C2=A03 files changed, 393 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index 51c0ebc..38406e5 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -152,6 +152,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct c=
ifs_sb_info *, struct inode *,
> > =C2=A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct ino=
de *,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *);
> >
> > +extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
> > +extern int cifs_read_from_socket(struct TCP_Server_Info *server, c=
har *buf,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0unsigned int to_read);
> > +extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvec *iov=
_orig, unsigned int nr_segs,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int to_=
read);
> > =C2=A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb);
> > =C2=A0extern int cifs_match_super(struct super_block *, void *);
> > @@ -441,6 +447,24 @@ extern int E_md4hash(const unsigned char *pass=
wd, unsigned char *p16);
> > =C2=A0extern int SMBencrypt(unsigned char *passwd, const unsigned c=
har *c8,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0unsigned char *p24);
> >
> > +/* asynchronous read support */
> > +struct cifs_readdata {
> > + =C2=A0 =C2=A0 =C2=A0 struct cifsFileInfo =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 *cfile;
> > + =C2=A0 =C2=A0 =C2=A0 struct address_space =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*mapping;
> > + =C2=A0 =C2=A0 =C2=A0 __u64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 offset;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bytes;
> > + =C2=A0 =C2=A0 =C2=A0 pid_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pid;
> > + =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result;
> > + =C2=A0 =C2=A0 =C2=A0 struct list_head =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0pages;
> > + =C2=A0 =C2=A0 =C2=A0 struct work_struct =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0work;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nr_iov;
> > + =C2=A0 =C2=A0 =C2=A0 struct kvec =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[1];
> > +};
> > +
> > +struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
> > +void cifs_readdata_free(struct cifs_readdata *rdata);
> > +int cifs_async_readv(struct cifs_readdata *rdata);
> > +
> > =C2=A0/* asynchronous write support */
> > =C2=A0struct cifs_writedata {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kref =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 refcount;
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index ae1ce01..ac72f28 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -33,6 +33,8 @@
> > =C2=A0#include <linux/slab.h>
> > =C2=A0#include <linux/posix_acl_xattr.h>
> > =C2=A0#include <linux/pagemap.h>
> > +#include <linux/swap.h>
> > +#include <linux/task_io_accounting_ops.h>
> > =C2=A0#include <asm/uaccess.h>
> > =C2=A0#include "cifspdu.h"
> > =C2=A0#include "cifsglob.h"
> > @@ -40,6 +42,7 @@
> > =C2=A0#include "cifsproto.h"
> > =C2=A0#include "cifs_unicode.h"
> > =C2=A0#include "cifs_debug.h"
> > +#include "fscache.h"
> >
> > =C2=A0#ifdef CONFIG_CIFS_POSIX
> > =C2=A0static struct {
> > @@ -83,6 +86,9 @@ static struct {
> > =C2=A0#endif /* CONFIG_CIFS_WEAK_PW_HASH */
> > =C2=A0#endif /* CIFS_POSIX */
> >
> > +/* Forward declarations */
> > +static void cifs_readv_complete(struct work_struct *work);
> > +
> > =C2=A0/* Mark as invalid, all open files on tree connections since =
they
> > =C2=A0 =C2=A0were closed when session to server was lost */
> > =C2=A0static void mark_open_files_invalid(struct cifs_tcon *pTcon)
> > @@ -1375,6 +1381,356 @@ openRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> >
> > +struct cifs_readdata *
> > +cifs_readdata_alloc(unsigned int nr_pages)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata *rdata;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* readdata + 1 kvec for each page */
> > + =C2=A0 =C2=A0 =C2=A0 rdata =3D kzalloc(sizeof(*rdata) +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sizeof(struct kvec) * nr_pages, GFP_KERNEL);
> > + =C2=A0 =C2=A0 =C2=A0 if (rdata !=3D NULL) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_WORK(&rdata=
->work, cifs_readv_complete);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&=
rdata->pages);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 return rdata;
> > +}
> > +
> > +void
> > +cifs_readdata_free(struct cifs_readdata *rdata)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 cifsFileInfo_put(rdata->cfile);
> > + =C2=A0 =C2=A0 =C2=A0 kfree(rdata);
> > +}
> > +
> > +/*
> > + * Discard any remaining data in the current SMB. To do this, we b=
orrow the
> > + * current bigbuf.
> > + */
> > +static int
> > +cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_en=
try *mid)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 READ_RSP *rsp =3D (READ_RSP *)server->smallb=
uf;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr=
=2Esmb_buf_length);
> > + =C2=A0 =C2=A0 =C2=A0 int remaining =3D rfclen + 4 - server->total=
_read;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata *rdata =3D mid->callbac=
k_data;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 while (remaining > 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int length;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 length =3D cifs_=
read_from_socket(server, server->bigbuf,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 min_t(unsigned int, remaining,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS=
MaxBufSize + MAX_CIFS_HDR_SIZE));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (length < 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return length;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->total_re=
ad +=3D length;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remaining -=3D l=
ength;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 dequeue_mid(mid, rdata->result);
> > + =C2=A0 =C2=A0 =C2=A0 return 0;
> > +}
> > +
> > +static int
> > +cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_en=
try *mid)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int length, len;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int data_offset, remaining, data_le=
n;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata *rdata =3D mid->callbac=
k_data;
> > + =C2=A0 =C2=A0 =C2=A0 READ_RSP *rsp =3D (READ_RSP *)server->smallb=
uf;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr=
=2Esmb_buf_length) + 4;
> > + =C2=A0 =C2=A0 =C2=A0 u64 eof;
> > + =C2=A0 =C2=A0 =C2=A0 pgoff_t eof_index;
> > + =C2=A0 =C2=A0 =C2=A0 struct page *page, *tpage;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: mid=3D%u offset=3D%llu bytes=3D=
%u", __func__,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mid->mid, rdata-=
>offset, rdata->bytes);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* read the rest of READ_RSP header (sa=
ns Data array), or whatever we
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* can if there's not enough data. At t=
his point, we've read down to
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* the Mid.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 len =3D min_t(unsigned int, rfclen, sizeof(*=
rsp)) -
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sizeof(struct smb_hdr) + 1;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov_base =3D server->smallbuf =
+ sizeof(struct smb_hdr) - 1;
> > + =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov_len =3D len;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 length =3D cifs_readv_from_socket(server, rd=
ata->iov, 1, len);
> > + =C2=A0 =C2=A0 =C2=A0 if (length < 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return length;
> > + =C2=A0 =C2=A0 =C2=A0 server->total_read +=3D length;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* Was the SMB read successful? */
> > + =C2=A0 =C2=A0 =C2=A0 rdata->result =3D map_smb_to_linux_error(&rs=
p->hdr, false);
> > + =C2=A0 =C2=A0 =C2=A0 if (rdata->result !=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: ser=
ver returned error %d", __func__,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rdata->result);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return cifs_read=
v_discard(server, mid);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* Is there enough to get to the rest of the=
 READ_RSP header? */
> > + =C2=A0 =C2=A0 =C2=A0 if (server->total_read < sizeof(READ_RSP)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: ser=
ver returned short header. got=3D%u expected=3D%lu",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __func__, server->total_read, sizeof(READ_RSP));
>=20
> sizeof should be casted to unsigned long to prevent compiler warnings=
=2E
>=20

Actually...I think what I need to do here and in the other places you
pointed out is to use "%z". I'll fix and respin.

Thanks for the review...
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
