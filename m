From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 8/8] cifs: convert cifs_iovec_write to use async writes
Date: Tue, 21 Feb 2012 16:02:33 +0400
Message-ID: <CAKywueRRCSttySt0AbkoANBYVgz=p-p+FbMEx9EfcdLP+v4OcQ@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-9-git-send-email-jlayton@redhat.com>
	<CAKywueT3Cmw4ffuE1wvMzxZniWyUUCU=8rtrB4Eu7Zz3FMtecQ@mail.gmail.com>
	<20120221065455.4f4b3ec5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120221065455.4f4b3ec5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 21 Feb 2012 12:06:49 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsproto.h | =A0 =A02 +
>> > =A0fs/cifs/cifssmb.c =A0 | =A0 =A04 +-
>> > =A0fs/cifs/file.c =A0 =A0 =A0| =A0191 ++++++++++++++++++++++++++++=
++++-------------------
>> > =A03 files changed, 126 insertions(+), 71 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> > index bceadc5..a131ded 100644
>> > --- a/fs/cifs/cifsproto.h
>> > +++ b/fs/cifs/cifsproto.h
>> > @@ -473,6 +473,8 @@ int cifs_async_readv(struct cifs_readdata *rda=
ta);
>> > =A0/* asynchronous write support */
>> > =A0struct cifs_writedata {
>> > =A0 =A0 =A0 =A0struct kref =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 refcount;
>> > + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list=
;
>> > + =A0 =A0 =A0 struct completion =A0 =A0 =A0 =A0 =A0 =A0 =A0 done;
>> > =A0 =A0 =A0 =A0enum writeback_sync_modes =A0 =A0 =A0 sync_mode;
>> > =A0 =A0 =A0 =A0struct work_struct =A0 =A0 =A0 =A0 =A0 =A0 =A0work;
>> > =A0 =A0 =A0 =A0struct cifsFileInfo =A0 =A0 =A0 =A0 =A0 =A0 *cfile;
>> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> > index 113b5af..6e93c9e 100644
>> > --- a/fs/cifs/cifssmb.c
>> > +++ b/fs/cifs/cifssmb.c
>> > @@ -2034,8 +2034,10 @@ cifs_writedata_alloc(unsigned int nr_pages,=
 work_func_t complete)
>> > =A0 =A0 =A0 =A0wdata =3D kzalloc(sizeof(*wdata) +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct page =
*) * (nr_pages - 1), GFP_NOFS);
>> > =A0 =A0 =A0 =A0if (wdata !=3D NULL) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, complete);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kref_init(&wdata->refcount);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&wdata->list);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_completion(&wdata->done);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, complete);
>> > =A0 =A0 =A0 =A0}
>> > =A0 =A0 =A0 =A0return wdata;
>> > =A0}
>> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> > index c7e47a2..ef25fc5 100644
>> > --- a/fs/cifs/file.c
>> > +++ b/fs/cifs/file.c
>> > @@ -2057,23 +2057,55 @@ size_t get_numpages(const size_t wsize, co=
nst size_t len, size_t *cur_len)
>> > =A0 =A0 =A0 =A0return num_pages;
>> > =A0}
>> >
>> > +static void
>> > +cifs_uncached_marshal_iov(struct kvec *iov, struct cifs_writedata=
 *wdata)
>> > +{
>> > + =A0 =A0 =A0 int i;
>> > + =A0 =A0 =A0 size_t bytes =3D wdata->bytes;
>> > +
>> > + =A0 =A0 =A0 /* marshal up the pages into iov array */
>> > + =A0 =A0 =A0 for (i =3D 0; i < wdata->nr_pages; i++) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_len =3D min(bytes, PA=
GE_SIZE);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_base =3D kmap(wdata->=
pages[i]);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes -=3D iov[i + 1].iov_len;
>> > + =A0 =A0 =A0 }
>> > +}
>> > +
>> > +static void
>> > +cifs_uncached_writev_complete(struct work_struct *work)
>> > +{
>> > + =A0 =A0 =A0 int i;
>> > + =A0 =A0 =A0 struct cifs_writedata *wdata =3D container_of(work,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 struct cifs_writedata, work);
>> > +
>> > + =A0 =A0 =A0 complete(&wdata->done);
>> > +
>> > + =A0 =A0 =A0 if (wdata->result !=3D -EAGAIN) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < wdata->nr_pages; i=
++)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_page(wdata->page=
s[i]);
>> > + =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writedata_release);
>> > +}
>> > +
>> > =A0static ssize_t
>> > =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *pof=
fset)
>> > =A0{
>> > - =A0 =A0 =A0 unsigned int written;
>> > - =A0 =A0 =A0 unsigned long num_pages, npages, i;
>> > + =A0 =A0 =A0 unsigned long nr_pages, i;
>> > =A0 =A0 =A0 =A0size_t copied, len, cur_len;
>> > =A0 =A0 =A0 =A0ssize_t total_written =3D 0;
>> > - =A0 =A0 =A0 struct kvec *to_send;
>> > - =A0 =A0 =A0 struct page **pages;
>> > + =A0 =A0 =A0 loff_t offset =3D *poffset;
>> > =A0 =A0 =A0 =A0struct iov_iter it;
>> > - =A0 =A0 =A0 struct inode *inode;
>> > + =A0 =A0 =A0 struct inode *inode =3D file->f_path.dentry->d_inode=
;
>> > + =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
>> > =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
>> > =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
>> > =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
>> > - =A0 =A0 =A0 int xid, rc;
>> > - =A0 =A0 =A0 __u32 pid;
>> > + =A0 =A0 =A0 struct cifs_writedata *wdata, *tmp;
>> > + =A0 =A0 =A0 struct list_head wdata_list;
>> > + =A0 =A0 =A0 int rc;
>> > + =A0 =A0 =A0 pid_t pid;
>> >
>> > =A0 =A0 =A0 =A0len =3D iov_length(iov, nr_segs);
>> > =A0 =A0 =A0 =A0if (!len)
>> > @@ -2083,103 +2115,122 @@ cifs_iovec_write(struct file *file, cons=
t struct iovec *iov,
>> > =A0 =A0 =A0 =A0if (rc)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> >
>> > + =A0 =A0 =A0 INIT_LIST_HEAD(&wdata_list);
>> > =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>> > - =A0 =A0 =A0 num_pages =3D get_numpages(cifs_sb->wsize, len, &cur=
_len);
>> > -
>> > - =A0 =A0 =A0 pages =3D kmalloc(sizeof(struct pages *)*num_pages, =
GFP_KERNEL);
>> > - =A0 =A0 =A0 if (!pages)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> > -
>> > - =A0 =A0 =A0 to_send =3D kmalloc(sizeof(struct kvec)*(num_pages +=
 1), GFP_KERNEL);
>> > - =A0 =A0 =A0 if (!to_send) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> > - =A0 =A0 =A0 }
>> > -
>> > - =A0 =A0 =A0 rc =3D cifs_write_allocate_pages(pages, num_pages);
>> > - =A0 =A0 =A0 if (rc) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(to_send);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> > - =A0 =A0 =A0 }
>> > -
>> > - =A0 =A0 =A0 xid =3D GetXid();
>> > =A0 =A0 =A0 =A0open_file =3D file->private_data;
>> > + =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
>> >
>> > =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWA=
RD)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D open_file->pid;
>> > =A0 =A0 =A0 =A0else
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D current->tgid;
>> >
>> > - =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
>> > - =A0 =A0 =A0 inode =3D file->f_path.dentry->d_inode;
>> > -
>> > =A0 =A0 =A0 =A0iov_iter_init(&it, iov, nr_segs, len, 0);
>> > - =A0 =A0 =A0 npages =3D num_pages;
>> > -
>> > =A0 =A0 =A0 =A0do {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t save_len =3D cur_len;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D min_t(con=
st size_t, cur_len, PAGE_CACHE_SIZE);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D iov_iter_=
copy_from_user(pages[i], &it, 0,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0copied);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t save_len;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pages =3D get_numpages(cifs_sb->w=
size, len, &cur_len);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata =3D cifs_writedata_alloc(nr_pa=
ges,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0cifs_uncached_writev_complete);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!wdata) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_write_allocate_pages(wda=
ta->pages, nr_pages);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(wdata);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 save_len =3D cur_len;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < nr_pages; i++) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D min_t(con=
st size_t, cur_len, PAGE_SIZE);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D iov_iter_=
copy_from_user(wdata->pages[i], &it,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, copied);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_len -=3D copied=
;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov_iter_advance(&i=
t, copied);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_bas=
e =3D kmap(pages[i]);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_len=
 =3D copied;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> > -
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_len =3D save_len - cur_len;
>> >
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->sync_mode =3D WB_SYNC_ALL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->nr_pages =3D nr_pages;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->offset =3D (__u64)offset;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->cfile =3D cifsFileInfo_get(op=
en_file);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->pid =3D pid;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->bytes =3D cur_len;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->marshal_iov =3D cifs_uncached=
_marshal_iov;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->inva=
lidHandle) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =
=3D cifs_reopen_file(open_file, false);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if =
(rc !=3D 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0break;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> When we reopen a file, we do it with the current pid, but in
>> cfile->pid leaves with the old value (and pid variable too).Should w=
e
>> do reopen with cfile->pid to save the original state of the file (no=
w
>> we don't restore locks, if we do it - it will be the problem)?
>>
>
> Yes, that does sound like something that should be fixed. That said, =
we
> have a lot of problems in the code that handles open files, and that'=
s
> just one of them. At this point, I'm not going to fix that in this
> patchset since it's an existing bug and unrelated to what I'm changin=
g
> here. It certainly wouldn't hurt to fix that at some point though.
>

I agree - this doesn't related to the patch, it simply pointed me to
this existing problem.

--=20
Best regards,
Pavel Shilovsky.
