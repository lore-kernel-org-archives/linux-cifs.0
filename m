From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: add cifs_async_readv
Date: Tue, 11 Oct 2011 14:51:56 +0400
Message-ID: <CAKywueSoKaAQhZ8Ru0HnxyMbuRHT4a4eiUnrh3-da0idT5w-Bg@mail.gmail.com>
References: <1315319241-21637-1-git-send-email-jlayton@redhat.com>
	<1315319241-21637-3-git-send-email-jlayton@redhat.com>
	<CAKywueRSTX8BT3BJymT+PdCEkVbzCEd+mV=UZa0e3-PZLej7qw@mail.gmail.com>
	<20111011062617.25376724@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111011062617.25376724-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 11 Oct 2011 13:30:14 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/9/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > ...which will allow cifs to do an asynchronous read call to the se=
rver.
>> > The caller will allocate and set up cifs_readdata for each READ_AN=
D_X
>> > call that should be issued on the wire. The pages passed in are ad=
ded
>> > to the pagecache, but not placed on the LRU list yet (as we need t=
he
>> > page->lru to keep the pages on the list in the readdata).
>> >
>> > When cifsd identifies the mid, it will see that there is a special
>> > receive handler for the call, and use that to receive the rest of =
the
>> > frame. cifs_readv_receive will then marshal up a kvec array with
>> > kmapped pages from the pagecache, which eliminates one copy of the
>> > data. Once the data is received, the pages are added to the LRU li=
st,
>> > set uptodate, and unlocked.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsproto.h | =A0 24 ++++
>> > =A0fs/cifs/cifssmb.c =A0 | =A0356 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++
>> > =A0fs/cifs/connect.c =A0 | =A0 26 ++--
>> > =A03 files changed, 393 insertions(+), 13 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> > index 51c0ebc..38406e5 100644
>> > --- a/fs/cifs/cifsproto.h
>> > +++ b/fs/cifs/cifsproto.h
>> > @@ -152,6 +152,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct =
cifs_sb_info *, struct inode *,
>> > =A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode=
 *,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0con=
st char *);
>> >
>> > +extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
>> > +extern int cifs_read_from_socket(struct TCP_Server_Info *server, =
char *buf,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int to_read);
>> > +extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov_orig, unsigned int =
nr_segs,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int to_read);
>> > =A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 cifs_sb_info *cifs_sb);
>> > =A0extern int cifs_match_super(struct super_block *, void *);
>> > @@ -441,6 +447,24 @@ extern int E_md4hash(const unsigned char *pas=
swd, unsigned char *p16);
>> > =A0extern int SMBencrypt(unsigned char *passwd, const unsigned cha=
r *c8,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24)=
;
>> >
>> > +/* asynchronous read support */
>> > +struct cifs_readdata {
>> > + =A0 =A0 =A0 struct cifsFileInfo =A0 =A0 =A0 =A0 =A0 =A0 *cfile;
>> > + =A0 =A0 =A0 struct address_space =A0 =A0 =A0 =A0 =A0 =A0*mapping=
;
>> > + =A0 =A0 =A0 __u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 offset;
>> > + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
bytes;
>> > + =A0 =A0 =A0 pid_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pid;
>> > + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 result;
>> > + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page=
s;
>> > + =A0 =A0 =A0 struct work_struct =A0 =A0 =A0 =A0 =A0 =A0 =A0work;
>> > + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
nr_iov;
>> > + =A0 =A0 =A0 struct kvec =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
iov[1];
>> > +};
>> > +
>> > +struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
>> > +void cifs_readdata_free(struct cifs_readdata *rdata);
>> > +int cifs_async_readv(struct cifs_readdata *rdata);
>> > +
>> > =A0/* asynchronous write support */
>> > =A0struct cifs_writedata {
>> > =A0 =A0 =A0 =A0struct kref =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 refcount;
>> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> > index ae1ce01..ac72f28 100644
>> > --- a/fs/cifs/cifssmb.c
>> > +++ b/fs/cifs/cifssmb.c
>> > @@ -33,6 +33,8 @@
>> > =A0#include <linux/slab.h>
>> > =A0#include <linux/posix_acl_xattr.h>
>> > =A0#include <linux/pagemap.h>
>> > +#include <linux/swap.h>
>> > +#include <linux/task_io_accounting_ops.h>
>> > =A0#include <asm/uaccess.h>
>> > =A0#include "cifspdu.h"
>> > =A0#include "cifsglob.h"
>> > @@ -40,6 +42,7 @@
>> > =A0#include "cifsproto.h"
>> > =A0#include "cifs_unicode.h"
>> > =A0#include "cifs_debug.h"
>> > +#include "fscache.h"
>> >
>> > =A0#ifdef CONFIG_CIFS_POSIX
>> > =A0static struct {
>> > @@ -83,6 +86,9 @@ static struct {
>> > =A0#endif /* CONFIG_CIFS_WEAK_PW_HASH */
>> > =A0#endif /* CIFS_POSIX */
>> >
>> > +/* Forward declarations */
>> > +static void cifs_readv_complete(struct work_struct *work);
>> > +
>> > =A0/* Mark as invalid, all open files on tree connections since th=
ey
>> > =A0 =A0were closed when session to server was lost */
>> > =A0static void mark_open_files_invalid(struct cifs_tcon *pTcon)
>> > @@ -1375,6 +1381,356 @@ openRetry:
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> >
>> > +struct cifs_readdata *
>> > +cifs_readdata_alloc(unsigned int nr_pages)
>> > +{
>> > + =A0 =A0 =A0 struct cifs_readdata *rdata;
>> > +
>> > + =A0 =A0 =A0 /* readdata + 1 kvec for each page */
>> > + =A0 =A0 =A0 rdata =3D kzalloc(sizeof(*rdata) +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct kvec) =
* nr_pages, GFP_KERNEL);
>> > + =A0 =A0 =A0 if (rdata !=3D NULL) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&rdata->work, cifs_readv_c=
omplete);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&rdata->pages);
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 return rdata;
>> > +}
>> > +
>> > +void
>> > +cifs_readdata_free(struct cifs_readdata *rdata)
>> > +{
>> > + =A0 =A0 =A0 cifsFileInfo_put(rdata->cfile);
>> > + =A0 =A0 =A0 kfree(rdata);
>> > +}
>> > +
>> > +/*
>> > + * Discard any remaining data in the current SMB. To do this, we =
borrow the
>> > + * current bigbuf.
>> > + */
>> > +static int
>> > +cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_e=
ntry *mid)
>> > +{
>> > + =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
>> > + =A0 =A0 =A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_buf=
_length);
>> > + =A0 =A0 =A0 int remaining =3D rfclen + 4 - server->total_read;
>> > + =A0 =A0 =A0 struct cifs_readdata *rdata =3D mid->callback_data;
>> > +
>> > + =A0 =A0 =A0 while (remaining > 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int length;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D cifs_read_from_socket(ser=
ver, server->bigbuf,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min_=
t(unsigned int, remaining,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length < 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return length;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->total_read +=3D length;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 remaining -=3D length;
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 dequeue_mid(mid, rdata->result);
>> > + =A0 =A0 =A0 return 0;
>> > +}
>> > +
>> > +static int
>> > +cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_e=
ntry *mid)
>> > +{
>> > + =A0 =A0 =A0 int length, len;
>> > + =A0 =A0 =A0 unsigned int data_offset, remaining, data_len;
>> > + =A0 =A0 =A0 struct cifs_readdata *rdata =3D mid->callback_data;
>> > + =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
>> > + =A0 =A0 =A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_buf=
_length) + 4;
>> > + =A0 =A0 =A0 u64 eof;
>> > + =A0 =A0 =A0 pgoff_t eof_index;
>> > + =A0 =A0 =A0 struct page *page, *tpage;
>> > +
>> > + =A0 =A0 =A0 cFYI(1, "%s: mid=3D%u offset=3D%llu bytes=3D%u", __f=
unc__,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->mid, rdata->offset, rdata->byte=
s);
>> > +
>> > + =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0* read the rest of READ_RSP header (sans Data arr=
ay), or whatever we
>> > + =A0 =A0 =A0 =A0* can if there's not enough data. At this point, =
we've read down to
>> > + =A0 =A0 =A0 =A0* the Mid.
>> > + =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 len =3D min_t(unsigned int, rfclen, sizeof(*rsp)) -
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct smb_hd=
r) + 1;
>> > +
>> > + =A0 =A0 =A0 rdata->iov[0].iov_base =3D server->smallbuf + sizeof=
(struct smb_hdr) - 1;
>> > + =A0 =A0 =A0 rdata->iov[0].iov_len =3D len;
>> > +
>> > + =A0 =A0 =A0 length =3D cifs_readv_from_socket(server, rdata->iov=
, 1, len);
>> > + =A0 =A0 =A0 if (length < 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return length;
>> > + =A0 =A0 =A0 server->total_read +=3D length;
>> > +
>> > + =A0 =A0 =A0 /* Was the SMB read successful? */
>> > + =A0 =A0 =A0 rdata->result =3D map_smb_to_linux_error(&rsp->hdr, =
false);
>> > + =A0 =A0 =A0 if (rdata->result !=3D 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: server returned error %=
d", __func__,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdata->result);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_readv_discard(server, mi=
d);
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 /* Is there enough to get to the rest of the READ_RS=
P header? */
>> > + =A0 =A0 =A0 if (server->total_read < sizeof(READ_RSP)) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: server returned short h=
eader. got=3D%u expected=3D%lu",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, server->to=
tal_read, sizeof(READ_RSP));
>>
>> sizeof should be casted to unsigned long to prevent compiler warning=
s.
>>
>
> Actually...I think what I need to do here and in the other places you
> pointed out is to use "%z". I'll fix and respin.
>
> Thanks for the review...
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

No problem. Yes, %z is ok too.

--=20
Best regards,
Pavel Shilovsky.
