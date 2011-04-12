From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: add cifs_async_writev
Date: Tue, 12 Apr 2011 07:11:20 -0400
Message-ID: <20110412071120.75e45b38@corrin.poochiereds.net>
References: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
	<1301747039-31411-5-git-send-email-jlayton@redhat.com>
	<BANLkTimHi_w55+bqFstXZZdjaMzw1mw_yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimHi_w55+bqFstXZZdjaMzw1mw_yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Apr 2011 13:43:07 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/4/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Add the ability for CIFS to do an asynchronous write. The kernel wi=
ll
> > set the frame up as it would for a "normal" SMBWrite2 request, and =
use
> > cifs_call_async to send it. The mid callback will then be configure=
d to
> > handle the result.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsproto.h | =C2=A0 19 +++++
> > =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0219 ++++++++++++++++++++++++=
+++++++++++++++++++++++++++
> > =C2=A02 files changed, 238 insertions(+), 0 deletions(-)
>=20
> Looks good too, except two small notes.
>=20

Thanks for looking. I respun this yesterday actually and the new patch
is a bit different. With the new patchset, we'll no longer be
constrained by the current wsize limit of 14 pages. It should be able
to handle an arbitrary wsize, which should also help performance.


> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index e255a2b..7b964df 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -21,6 +21,7 @@
> > =C2=A0#ifndef _CIFSPROTO_H
> > =C2=A0#define _CIFSPROTO_H
> > =C2=A0#include <linux/nls.h>
> > +#include <linux/pagevec.h>
> >
> > =C2=A0struct statfs;
> > =C2=A0struct smb_vol;
> > @@ -433,4 +434,22 @@ extern int mdfour(unsigned char *, unsigned ch=
ar *, int);
> > =C2=A0extern int E_md4hash(const unsigned char *passwd, unsigned ch=
ar *p16);
> > =C2=A0extern int SMBencrypt(unsigned char *passwd, const unsigned c=
har *c8,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0unsigned char *p24);
> > +
> > +/* asynchronous write support */
> > +struct cifs_writedata {
> > + =C2=A0 =C2=A0 =C2=A0 struct list_head =C2=A0 =C2=A0 =C2=A0 =C2=A0=
pending;
> > + =C2=A0 =C2=A0 =C2=A0 struct kref =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 refcount;
> > + =C2=A0 =C2=A0 =C2=A0 struct completion =C2=A0 =C2=A0 =C2=A0 compl=
etion;
> > + =C2=A0 =C2=A0 =C2=A0 struct work_struct =C2=A0 =C2=A0 =C2=A0work;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifsFileInfo =C2=A0 =C2=A0 *cfile;
> > + =C2=A0 =C2=A0 =C2=A0 __u64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 offset;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0bytes;
> > + =C2=A0 =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 result;
> > + =C2=A0 =C2=A0 =C2=A0 struct page =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 *pages[PAGEVEC_SIZE];
> > +};
> > +
> > +int cifs_async_writev(struct cifs_writedata *wdata);
> > +struct cifs_writedata *cifs_writedata_alloc(void);
> > +void cifs_writedata_release(struct kref *refcount);
> > +
> > =C2=A0#endif =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 /* _CIFSPROTO_H */
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 8de7e79..b308605 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -32,6 +32,7 @@
> > =C2=A0#include <linux/vfs.h>
> > =C2=A0#include <linux/slab.h>
> > =C2=A0#include <linux/posix_acl_xattr.h>
> > +#include <linux/pagemap.h>
> > =C2=A0#include <asm/uaccess.h>
> > =C2=A0#include "cifspdu.h"
> > =C2=A0#include "cifsglob.h"
> > @@ -1604,6 +1605,224 @@ CIFSSMBWrite(const int xid, struct cifs_tco=
n *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> >
> > +void
> > +cifs_writedata_release(struct kref *refcount)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata =3D container_o=
f(refcount,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct cifs_writedata, refcount);
> > + =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (wdata->cfile) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping =3D wdat=
a->cfile->dentry->d_inode->i_mapping;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&mappi=
ng->private_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&wdata-=
>pending);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&map=
ping->private_lock);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifsFileInfo_put=
(wdata->cfile);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 kfree(wdata);
> > +}
> > +
> > +static void
> > +cifs_writev_complete(struct work_struct *work)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata =3D container_o=
f(work,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata, work);
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon =3D tlink_tcon(wdata-=
>cfile->tlink);
>                              ^^^ this variable is unused.
>=20
				Not exactly.

> > + =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D wdata->cfile->dentry=
->d_inode;
> > + =C2=A0 =C2=A0 =C2=A0 struct page *page;
> > + =C2=A0 =C2=A0 =C2=A0 int i =3D 0;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (wdata->result =3D=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_update_eof(=
CIFS_I(inode), wdata->offset, wdata->bytes);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_stats_bytes=
_written(tcon, wdata->bytes);
					     ^^^^^=09
					The tcon is used here
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ARRAY_SIZE(wdata->pages) &=
& (page =3D wdata->pages[i]);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 i++) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wdata->resul=
t =3D=3D -EAGAIN)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __set_page_dirty_nobuffers(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (wdata->=
result < 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 SetPageError(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 end_page_writeba=
ck(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page_cache_relea=
se(page);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 if (wdata->result !=3D -EAGAIN)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping_set_erro=
r(inode->i_mapping, wdata->result);
> > + =C2=A0 =C2=A0 =C2=A0 complete(&wdata->completion);
> > + =C2=A0 =C2=A0 =C2=A0 kref_put(&wdata->refcount, cifs_writedata_re=
lease);
> > +}
> > +
> > +struct cifs_writedata *
> > +cifs_writedata_alloc(void)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 wdata =3D kzalloc(sizeof(*wdata), GFP_NOFS);
> > + =C2=A0 =C2=A0 =C2=A0 if (wdata !=3D NULL) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&=
wdata->pending);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_WORK(&wdata=
->work, cifs_writev_complete);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kref_init(&wdata=
->refcount);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 init_completion(=
&wdata->completion);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 return wdata;
> > +}
> > +
> > +/*
> > + * Check the midState and signature on received buffer (if any), a=
nd queue the
> > + * workqueue completion task.
> > + */
> > +static void
> > +cifs_writev_callback(struct mid_q_entry *mid)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata =3D mid->callba=
ck_data;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon =3D tlink_tcon(wdata-=
>cfile->tlink);
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int written;
> > + =C2=A0 =C2=A0 =C2=A0 WRITE_RSP *smb =3D (WRITE_RSP *)mid->resp_bu=
f;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 switch(mid->midState) {
> > + =C2=A0 =C2=A0 =C2=A0 case MID_RESPONSE_RECEIVED:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->result =3D=
 cifs_check_receive(mid, tcon->ses->server, 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wdata->resul=
t !=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 written =3D le16=
_to_cpu(smb->CountHigh);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 written <<=3D 16=
;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 written +=3D le1=
6_to_cpu(smb->Count);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Mask off=
 high 16 bits when bytes written as returned
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* by the s=
erver is greater than bytes requested by the
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* client. =
OS/2 servers are known to set incorrect
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* CountHig=
h values.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (written > wd=
ata->bytes)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 written &=3D 0xFFFF;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (written < wd=
ata->bytes)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wdata->result =3D -ENOSPC;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wdata->bytes =3D written;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 case MID_REQUEST_SUBMITTED:
> > + =C2=A0 =C2=A0 =C2=A0 case MID_RETRY_NEEDED:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->result =3D=
 -EAGAIN;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 default:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->result =3D=
 -EIO;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 queue_work(system_nrt_wq, &wdata->work);
> > + =C2=A0 =C2=A0 =C2=A0 DeleteMidQEntry(mid);
> > + =C2=A0 =C2=A0 =C2=A0 atomic_dec(&tcon->ses->server->inFlight);
> > + =C2=A0 =C2=A0 =C2=A0 wake_up(&tcon->ses->server->request_q);
> > +}
> > +
> > +/* cifs_async_writev - send an async write, and set up mid to hand=
le result */
> > +int
> > +cifs_async_writev(struct cifs_writedata *wdata)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int i, rc =3D -EACCES;
> > + =C2=A0 =C2=A0 =C2=A0 WRITE_REQ *smb =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 int wct;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon =3D tlink_tcon(wdata-=
>cfile->tlink);
> > + =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D wdata->cfile->dentry=
->d_inode;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int npages =3D ARRAY_SIZE(wdata->pa=
ges);
> > + =C2=A0 =C2=A0 =C2=A0 struct kvec *iov =3D NULL;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 cFYI(1, "async write at %llu %u bytes", wdat=
a->offset, wdata->bytes);
>                                                        ^^^^ bytes is
> zero here. You calculate it next - I suggest to move this info messag=
e
> after you get right bytes value.
>=20

Good catch. Will fix.

> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (tcon->ses->capabilities & CAP_LARGE_FILE=
S) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wct =3D 14;
> > + =C2=A0 =C2=A0 =C2=A0 } else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wct =3D 12;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wdata->offse=
t >> 32 > 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* can not handle big offset for old srv */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return -EIO;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wc=
t, tcon, (void **)&smb);
> > + =C2=A0 =C2=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto async_write=
v_out;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* FIXME: only allocate number of kvecs we n=
eed */
> > + =C2=A0 =C2=A0 =C2=A0 iov =3D kzalloc((npages + 1) * sizeof(*iov),=
 GFP_NOFS);
> > + =C2=A0 =C2=A0 =C2=A0 if (iov =3D=3D NULL) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOMEM;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto async_write=
v_out;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 smb->AndXCommand =3D 0xFF; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* none */
> > + =C2=A0 =C2=A0 =C2=A0 smb->Fid =3D wdata->cfile->netfid;
> > + =C2=A0 =C2=A0 =C2=A0 smb->OffsetLow =3D cpu_to_le32(wdata->offset=
 & 0xFFFFFFFF);
> > + =C2=A0 =C2=A0 =C2=A0 if (wct =3D=3D 14)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smb->OffsetHigh =
=3D cpu_to_le32(wdata->offset >> 32);
> > + =C2=A0 =C2=A0 =C2=A0 smb->Reserved =3D 0xFFFFFFFF;
> > + =C2=A0 =C2=A0 =C2=A0 smb->WriteMode =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 smb->Remaining =3D 0;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 smb->DataOffset =3D
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16(offsetof(struct sm=
b_com_write_req, Data) - 4);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* 4 for RFC1001 length + 1 for BCC */
> > + =C2=A0 =C2=A0 =C2=A0 iov[0].iov_len =3D be32_to_cpu(smb->hdr.smb_=
buf_length) + 4 + 1;
> > + =C2=A0 =C2=A0 =C2=A0 iov[0].iov_base =3D smb;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* marshal up the pages into iov array */
> > + =C2=A0 =C2=A0 =C2=A0 npages =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 wdata->bytes =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ARRAY_SIZE(wdata->pages) &=
& wdata->pages[i]; i++) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wdata->bytes=
 + PAGE_CACHE_SIZE <=3D
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CI=
=46S_SB(inode->i_sb)->wsize) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 iov[i + 1].iov_len =3D min(inode->i_size -
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 page_offset(wdata->pages[i]),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 (loff_t)PAGE_CACHE_SIZE);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 iov[i + 1].iov_base =3D kmap(wdata->pages[i]);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wdata->bytes +=3D iov[i + 1].iov_len;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 npages++;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* if we're beyond wsize, then re-mark page dirty */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __set_page_dirty_nobuffers(wdata->pages[i]);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 smb->DataLengthLow =3D cpu_to_le16(wdata->by=
tes & 0xFFFF);
> > + =C2=A0 =C2=A0 =C2=A0 smb->DataLengthHigh =3D cpu_to_le16(wdata->b=
ytes >> 16);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (wct =3D=3D 14) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inc_rfc1001_len(=
&smb->hdr, wdata->bytes + 1);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_bcc(wdata->b=
ytes + 1, &smb->hdr);
> > + =C2=A0 =C2=A0 =C2=A0 } else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* wct =3D=3D 12=
 */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct smb_com_w=
ritex_req *smbw =3D
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (struct smb_com_writex_req *)smb=
;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inc_rfc1001_len(=
&smbw->hdr, wdata->bytes + 5);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_bcc(wdata->b=
ytes + 5, &smbw->hdr);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[0].iov_len +=
=3D 4; /* pad bigger by four bytes */
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 kref_get(&wdata->refcount);
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_call_async(tcon->ses->server, io=
v, npages + 1,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_writev_callback, wdata);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_stats_inc(&=
tcon->stats.cifs_stats.num_writes);
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kref_put(&wdata-=
>refcount, cifs_writedata_release);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* send is done, unmap pages */
> > + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < npages; i++)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kunmap(wdata->pa=
ges[i]);
> > +
> > +async_writev_out:
> > + =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release(smb);
> > + =C2=A0 =C2=A0 =C2=A0 kfree(iov);
> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> > +}
> > +
> > =C2=A0int
> > =C2=A0CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const int netfid, const u=
nsigned int count,
> > --
> > 1.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
> Anyway, it's good. You can my "Reviewed-by: Pavel Shilovsky
> <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>" tag when you fix the notes above.
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
