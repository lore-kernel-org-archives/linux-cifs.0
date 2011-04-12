From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: add cifs_async_writev
Date: Tue, 12 Apr 2011 15:24:19 +0400
Message-ID: <BANLkTi=G1U591vh4cc6XxT=FRe0puir2Ew@mail.gmail.com>
References: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
	<1301747039-31411-5-git-send-email-jlayton@redhat.com>
	<BANLkTimHi_w55+bqFstXZZdjaMzw1mw_yA@mail.gmail.com>
	<20110412071120.75e45b38@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110412071120.75e45b38-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/12 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 12 Apr 2011 13:43:07 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/4/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > Add the ability for CIFS to do an asynchronous write. The kernel w=
ill
>> > set the frame up as it would for a "normal" SMBWrite2 request, and=
 use
>> > cifs_call_async to send it. The mid callback will then be configur=
ed to
>> > handle the result.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsproto.h | =A0 19 +++++
>> > =A0fs/cifs/cifssmb.c =A0 | =A0219 ++++++++++++++++++++++++++++++++=
+++++++++++++++++++
>> > =A02 files changed, 238 insertions(+), 0 deletions(-)
>>
>> Looks good too, except two small notes.
>>
>
> Thanks for looking. I respun this yesterday actually and the new patc=
h
> is a bit different. With the new patchset, we'll no longer be
> constrained by the current wsize limit of 14 pages. It should be able
> to handle an arbitrary wsize, which should also help performance.
>
>
>> >
>> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> > index e255a2b..7b964df 100644
>> > --- a/fs/cifs/cifsproto.h
>> > +++ b/fs/cifs/cifsproto.h
>> > @@ -21,6 +21,7 @@
>> > =A0#ifndef _CIFSPROTO_H
>> > =A0#define _CIFSPROTO_H
>> > =A0#include <linux/nls.h>
>> > +#include <linux/pagevec.h>
>> >
>> > =A0struct statfs;
>> > =A0struct smb_vol;
>> > @@ -433,4 +434,22 @@ extern int mdfour(unsigned char *, unsigned c=
har *, int);
>> > =A0extern int E_md4hash(const unsigned char *passwd, unsigned char=
 *p16);
>> > =A0extern int SMBencrypt(unsigned char *passwd, const unsigned cha=
r *c8,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24)=
;
>> > +
>> > +/* asynchronous write support */
>> > +struct cifs_writedata {
>> > + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0pending;
>> > + =A0 =A0 =A0 struct kref =A0 =A0 =A0 =A0 =A0 =A0 refcount;
>> > + =A0 =A0 =A0 struct completion =A0 =A0 =A0 completion;
>> > + =A0 =A0 =A0 struct work_struct =A0 =A0 =A0work;
>> > + =A0 =A0 =A0 struct cifsFileInfo =A0 =A0 *cfile;
>> > + =A0 =A0 =A0 __u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset;
>> > + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0bytes;
>> > + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 result;
>> > + =A0 =A0 =A0 struct page =A0 =A0 =A0 =A0 =A0 =A0 *pages[PAGEVEC_S=
IZE];
>> > +};
>> > +
>> > +int cifs_async_writev(struct cifs_writedata *wdata);
>> > +struct cifs_writedata *cifs_writedata_alloc(void);
>> > +void cifs_writedata_release(struct kref *refcount);
>> > +
>> > =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSPROTO_H */
>> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> > index 8de7e79..b308605 100644
>> > --- a/fs/cifs/cifssmb.c
>> > +++ b/fs/cifs/cifssmb.c
>> > @@ -32,6 +32,7 @@
>> > =A0#include <linux/vfs.h>
>> > =A0#include <linux/slab.h>
>> > =A0#include <linux/posix_acl_xattr.h>
>> > +#include <linux/pagemap.h>
>> > =A0#include <asm/uaccess.h>
>> > =A0#include "cifspdu.h"
>> > =A0#include "cifsglob.h"
>> > @@ -1604,6 +1605,224 @@ CIFSSMBWrite(const int xid, struct cifs_tc=
on *tcon,
>> > =A0 =A0 =A0 =A0return rc;
>> > =A0}
>> >
>> > +void
>> > +cifs_writedata_release(struct kref *refcount)
>> > +{
>> > + =A0 =A0 =A0 struct cifs_writedata *wdata =3D container_of(refcou=
nt,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 struct cifs_writedata, refcount);
>> > + =A0 =A0 =A0 struct address_space *mapping;
>> > +
>> > + =A0 =A0 =A0 if (wdata->cfile) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping =3D wdata->cfile->dentry->d_=
inode->i_mapping;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&mapping->private_lock);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&wdata->pending);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&mapping->private_lock);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(wdata->cfile);
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 kfree(wdata);
>> > +}
>> > +
>> > +static void
>> > +cifs_writev_complete(struct work_struct *work)
>> > +{
>> > + =A0 =A0 =A0 struct cifs_writedata *wdata =3D container_of(work,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_writedata, work);
>> > + =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(wdata->cfile->=
tlink);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^ this =
variable is unused.
>>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Not ex=
actly.
>
>> > + =A0 =A0 =A0 struct inode *inode =3D wdata->cfile->dentry->d_inod=
e;
>> > + =A0 =A0 =A0 struct page *page;
>> > + =A0 =A0 =A0 int i =3D 0;
>> > +
>> > + =A0 =A0 =A0 if (wdata->result =3D=3D 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_update_eof(CIFS_I(inode), wdata=
->offset, wdata->bytes);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_bytes_written(tcon, wdata=
->bytes);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 ^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0The tcon is used here

Strange, the compiler (gcc-4.4.4-1ubuntu2) reports it:
/home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: In function
=91cifs_writev_complete=92:
/home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c:1633: warning: unused
variable =91tcon=92

but you are right - it is used.

>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(wdata->pages) && (page =
=3D wdata->pages[i]);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wdata->result =3D=3D -EAGAIN)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __set_page_dirty_nob=
uffers(page);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (wdata->result < 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageError(page);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 end_page_writeback(page);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 if (wdata->result !=3D -EAGAIN)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, =
wdata->result);
>> > + =A0 =A0 =A0 complete(&wdata->completion);
>> > + =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writedata_release);
>> > +}
>> > +
>> > +struct cifs_writedata *
>> > +cifs_writedata_alloc(void)
>> > +{
>> > + =A0 =A0 =A0 struct cifs_writedata *wdata;
>> > +
>> > + =A0 =A0 =A0 wdata =3D kzalloc(sizeof(*wdata), GFP_NOFS);
>> > + =A0 =A0 =A0 if (wdata !=3D NULL) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&wdata->pending);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, cifs_writev_=
complete);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_init(&wdata->refcount);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_completion(&wdata->completion);
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 return wdata;
>> > +}
>> > +
>> > +/*
>> > + * Check the midState and signature on received buffer (if any), =
and queue the
>> > + * workqueue completion task.
>> > + */
>> > +static void
>> > +cifs_writev_callback(struct mid_q_entry *mid)
>> > +{
>> > + =A0 =A0 =A0 struct cifs_writedata *wdata =3D mid->callback_data;
>> > + =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(wdata->cfile->=
tlink);
>> > + =A0 =A0 =A0 unsigned int written;
>> > + =A0 =A0 =A0 WRITE_RSP *smb =3D (WRITE_RSP *)mid->resp_buf;
>> > +
>> > + =A0 =A0 =A0 switch(mid->midState) {
>> > + =A0 =A0 =A0 case MID_RESPONSE_RECEIVED:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->result =3D cifs_check_receive=
(mid, tcon->ses->server, 0);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wdata->result !=3D 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written =3D le16_to_cpu(smb->CountHi=
gh);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written <<=3D 16;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written +=3D le16_to_cpu(smb->Count)=
;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mask off high 16 bits when byte=
s written as returned
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* by the server is greater than b=
ytes requested by the
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* client. OS/2 servers are known =
to set incorrect
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* CountHigh values.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (written > wdata->bytes)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 written &=3D 0xFFFF;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (written < wdata->bytes)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->result =3D -E=
NOSPC;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->bytes =3D wri=
tten;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 case MID_REQUEST_SUBMITTED:
>> > + =A0 =A0 =A0 case MID_RETRY_NEEDED:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->result =3D -EAGAIN;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 default:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->result =3D -EIO;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 queue_work(system_nrt_wq, &wdata->work);
>> > + =A0 =A0 =A0 DeleteMidQEntry(mid);
>> > + =A0 =A0 =A0 atomic_dec(&tcon->ses->server->inFlight);
>> > + =A0 =A0 =A0 wake_up(&tcon->ses->server->request_q);
>> > +}
>> > +
>> > +/* cifs_async_writev - send an async write, and set up mid to han=
dle result */
>> > +int
>> > +cifs_async_writev(struct cifs_writedata *wdata)
>> > +{
>> > + =A0 =A0 =A0 int i, rc =3D -EACCES;
>> > + =A0 =A0 =A0 WRITE_REQ *smb =3D NULL;
>> > + =A0 =A0 =A0 int wct;
>> > + =A0 =A0 =A0 struct cifs_tcon *tcon =3D tlink_tcon(wdata->cfile->=
tlink);
>> > + =A0 =A0 =A0 struct inode *inode =3D wdata->cfile->dentry->d_inod=
e;
>> > + =A0 =A0 =A0 unsigned int npages =3D ARRAY_SIZE(wdata->pages);
>> > + =A0 =A0 =A0 struct kvec *iov =3D NULL;
>> > +
>> > + =A0 =A0 =A0 cFYI(1, "async write at %llu %u bytes", wdata->offse=
t, wdata->bytes);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^ bytes is
>> zero here. You calculate it next - I suggest to move this info messa=
ge
>> after you get right bytes value.
>>
>
> Good catch. Will fix.
>
>> > +
>> > + =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_LARGE_FILES) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wct =3D 14;
>> > + =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wct =3D 12;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wdata->offset >> 32 > 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* can not handle bi=
g offset for old srv */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon,=
 (void **)&smb);
>> > + =A0 =A0 =A0 if (rc)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto async_writev_out;
>> > +
>> > + =A0 =A0 =A0 /* FIXME: only allocate number of kvecs we need */
>> > + =A0 =A0 =A0 iov =3D kzalloc((npages + 1) * sizeof(*iov), GFP_NOF=
S);
>> > + =A0 =A0 =A0 if (iov =3D=3D NULL) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto async_writev_out;
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 smb->AndXCommand =3D 0xFF; =A0 =A0 =A0 =A0/* none */
>> > + =A0 =A0 =A0 smb->Fid =3D wdata->cfile->netfid;
>> > + =A0 =A0 =A0 smb->OffsetLow =3D cpu_to_le32(wdata->offset & 0xFFF=
=46FFFF);
>> > + =A0 =A0 =A0 if (wct =3D=3D 14)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->OffsetHigh =3D cpu_to_le32(wdat=
a->offset >> 32);
>> > + =A0 =A0 =A0 smb->Reserved =3D 0xFFFFFFFF;
>> > + =A0 =A0 =A0 smb->WriteMode =3D 0;
>> > + =A0 =A0 =A0 smb->Remaining =3D 0;
>> > +
>> > + =A0 =A0 =A0 smb->DataOffset =3D
>> > + =A0 =A0 =A0 =A0 =A0 cpu_to_le16(offsetof(struct smb_com_write_re=
q, Data) - 4);
>> > +
>> > + =A0 =A0 =A0 /* 4 for RFC1001 length + 1 for BCC */
>> > + =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(smb->hdr.smb_buf_leng=
th) + 4 + 1;
>> > + =A0 =A0 =A0 iov[0].iov_base =3D smb;
>> > +
>> > + =A0 =A0 =A0 /* marshal up the pages into iov array */
>> > + =A0 =A0 =A0 npages =3D 0;
>> > + =A0 =A0 =A0 wdata->bytes =3D 0;
>> > + =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(wdata->pages) && wdata-=
>pages[i]; i++) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wdata->bytes + PAGE_CACHE_SIZE <=
=3D
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_SB(inode->i_sb)->wsize)=
 {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_len =3D=
 min(inode->i_size -
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 page_offset(wdata->pages[i]),
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 (loff_t)PAGE_CACHE_SIZE);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_base =
=3D kmap(wdata->pages[i]);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->bytes +=3D io=
v[i + 1].iov_len;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 npages++;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if we're beyond w=
size, then re-mark page dirty */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __set_page_dirty_nob=
uffers(wdata->pages[i]);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 smb->DataLengthLow =3D cpu_to_le16(wdata->bytes & 0x=
=46FFF);
>> > + =A0 =A0 =A0 smb->DataLengthHigh =3D cpu_to_le16(wdata->bytes >> =
16);
>> > +
>> > + =A0 =A0 =A0 if (wct =3D=3D 14) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_rfc1001_len(&smb->hdr, wdata->by=
tes + 1);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(wdata->bytes + 1, &smb->hdr)=
;
>> > + =A0 =A0 =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* wct =3D=3D 12 */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_com_writex_req *smbw =3D
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (str=
uct smb_com_writex_req *)smb;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_rfc1001_len(&smbw->hdr, wdata->b=
ytes + 5);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(wdata->bytes + 5, &smbw->hdr=
);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_len +=3D 4; /* pad bigger=
 by four bytes */
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 kref_get(&wdata->refcount);
>> > + =A0 =A0 =A0 rc =3D cifs_call_async(tcon->ses->server, iov, npage=
s + 1,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_writ=
ev_callback, wdata);
>> > +
>> > + =A0 =A0 =A0 if (rc =3D=3D 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->stats.cifs_sta=
ts.num_writes);
>> > + =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writ=
edata_release);
>> > +
>> > + =A0 =A0 =A0 /* send is done, unmap pages */
>> > + =A0 =A0 =A0 for (i =3D 0; i < npages; i++)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(wdata->pages[i]);
>> > +
>> > +async_writev_out:
>> > + =A0 =A0 =A0 cifs_small_buf_release(smb);
>> > + =A0 =A0 =A0 kfree(iov);
>> > + =A0 =A0 =A0 return rc;
>> > +}
>> > +
>> > =A0int
>> > =A0CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
>> > =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const unsigned int count=
,
>> > --
>> > 1.7.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>> Anyway, it's good. You can my "Reviewed-by: Pavel Shilovsky
>> <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>" tag when you fix the notes above.
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
