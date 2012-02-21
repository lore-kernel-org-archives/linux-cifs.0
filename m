From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/8] cifs: convert cifs_iovec_write to use async
 writes
Date: Tue, 21 Feb 2012 06:54:55 -0500
Message-ID: <20120221065455.4f4b3ec5@tlielax.poochiereds.net>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-9-git-send-email-jlayton@redhat.com>
	<CAKywueT3Cmw4ffuE1wvMzxZniWyUUCU=8rtrB4Eu7Zz3FMtecQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT3Cmw4ffuE1wvMzxZniWyUUCU=8rtrB4Eu7Zz3FMtecQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 21 Feb 2012 12:06:49 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsproto.h | =C2=A0 =C2=A02 +
> > =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0 =C2=A04 +-
> > =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0| =C2=A0191 ++++++++++++++=
++++++++++++++++++-------------------
> > =C2=A03 files changed, 126 insertions(+), 71 deletions(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index bceadc5..a131ded 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -473,6 +473,8 @@ int cifs_async_readv(struct cifs_readdata *rdat=
a);
> > =C2=A0/* asynchronous write support */
> > =C2=A0struct cifs_writedata {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kref =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 refcount;
> > + =C2=A0 =C2=A0 =C2=A0 struct list_head =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0list;
> > + =C2=A0 =C2=A0 =C2=A0 struct completion =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 done;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0enum writeback_sync_modes =C2=A0 =C2=A0 =
=C2=A0 sync_mode;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct work_struct =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0work;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifsFileInfo =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 *cfile;
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 113b5af..6e93c9e 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -2034,8 +2034,10 @@ cifs_writedata_alloc(unsigned int nr_pages, =
work_func_t complete)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0wdata =3D kzalloc(sizeof(*wdata) +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0sizeof(struct page *) * (nr_pages - 1), GFP_NOFS);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (wdata !=3D NULL) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_WORK(&wdata=
->work, complete);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kref_init(&w=
data->refcount);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&=
wdata->list);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 init_completion(=
&wdata->done);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_WORK(&wdata=
->work, complete);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return wdata;
> > =C2=A0}
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index c7e47a2..ef25fc5 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -2057,23 +2057,55 @@ size_t get_numpages(const size_t wsize, con=
st size_t len, size_t *cur_len)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return num_pages;
> > =C2=A0}
> >
> > +static void
> > +cifs_uncached_marshal_iov(struct kvec *iov, struct cifs_writedata =
*wdata)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int i;
> > + =C2=A0 =C2=A0 =C2=A0 size_t bytes =3D wdata->bytes;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* marshal up the pages into iov array */
> > + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < wdata->nr_pages; i++) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[i + 1].iov_l=
en =3D min(bytes, PAGE_SIZE);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[i + 1].iov_b=
ase =3D kmap(wdata->pages[i]);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bytes -=3D iov[i=
 + 1].iov_len;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +}
> > +
> > +static void
> > +cifs_uncached_writev_complete(struct work_struct *work)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int i;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata =3D container_o=
f(work,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct cifs_writedata, work);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 complete(&wdata->done);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (wdata->result !=3D -EAGAIN) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i =
< wdata->nr_pages; i++)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 put_page(wdata->pages[i]);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 kref_put(&wdata->refcount, cifs_writedata_re=
lease);
> > +}
> > +
> > =C2=A0static ssize_t
> > =C2=A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned lo=
ng nr_segs, loff_t *poffset)
> > =C2=A0{
> > - =C2=A0 =C2=A0 =C2=A0 unsigned int written;
> > - =C2=A0 =C2=A0 =C2=A0 unsigned long num_pages, npages, i;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned long nr_pages, i;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t copied, len, cur_len;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t total_written =3D 0;
> > - =C2=A0 =C2=A0 =C2=A0 struct kvec *to_send;
> > - =C2=A0 =C2=A0 =C2=A0 struct page **pages;
> > + =C2=A0 =C2=A0 =C2=A0 loff_t offset =3D *poffset;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iov_iter it;
> > - =C2=A0 =C2=A0 =C2=A0 struct inode *inode;
> > + =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file->f_path.dentry-=
>d_inode;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode=
);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifsFileInfo *open_file;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_tcon *tcon;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_sb_info *cifs_sb;
> > - =C2=A0 =C2=A0 =C2=A0 int xid, rc;
> > - =C2=A0 =C2=A0 =C2=A0 __u32 pid;
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata, *tmp;
> > + =C2=A0 =C2=A0 =C2=A0 struct list_head wdata_list;
> > + =C2=A0 =C2=A0 =C2=A0 int rc;
> > + =C2=A0 =C2=A0 =C2=A0 pid_t pid;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D iov_length(iov, nr_segs);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!len)
> > @@ -2083,103 +2115,122 @@ cifs_iovec_write(struct file *file, const=
 struct iovec *iov,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >
> > + =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&wdata_list);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb =3D CIFS_SB(file->f_path.dentry-=
>d_sb);
> > - =C2=A0 =C2=A0 =C2=A0 num_pages =3D get_numpages(cifs_sb->wsize, l=
en, &cur_len);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 pages =3D kmalloc(sizeof(struct pages *)*num=
_pages, GFP_KERNEL);
> > - =C2=A0 =C2=A0 =C2=A0 if (!pages)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> > -
> > - =C2=A0 =C2=A0 =C2=A0 to_send =3D kmalloc(sizeof(struct kvec)*(num=
_pages + 1), GFP_KERNEL);
> > - =C2=A0 =C2=A0 =C2=A0 if (!to_send) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(pages);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> > - =C2=A0 =C2=A0 =C2=A0 }
> > -
> > - =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_write_allocate_pages(pages, num_=
pages);
> > - =C2=A0 =C2=A0 =C2=A0 if (rc) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(pages);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(to_send);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> > - =C2=A0 =C2=A0 =C2=A0 }
> > -
> > - =C2=A0 =C2=A0 =C2=A0 xid =3D GetXid();
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0open_file =3D file->private_data;
> > + =C2=A0 =C2=A0 =C2=A0 tcon =3D tlink_tcon(open_file->tlink);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT=
_RWPIDFORWARD)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pid =3D open=
_file->pid;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pid =3D curr=
ent->tgid;
> >
> > - =C2=A0 =C2=A0 =C2=A0 tcon =3D tlink_tcon(open_file->tlink);
> > - =C2=A0 =C2=A0 =C2=A0 inode =3D file->f_path.dentry->d_inode;
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0iov_iter_init(&it, iov, nr_segs, len, 0)=
;
> > - =C2=A0 =C2=A0 =C2=A0 npages =3D num_pages;
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0do {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t save_len =
=3D cur_len;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i =
< npages; i++) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 copied =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 copied =3D iov_iter_copy_from_user(pages[i], &it, 0,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0copied);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t save_len;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nr_pages =3D get=
_numpages(cifs_sb->wsize, len, &cur_len);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata =3D cifs_w=
ritedata_alloc(nr_pages,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cifs_uncached_writev_complete);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!wdata) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D -ENOMEM;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_writ=
e_allocate_pages(wdata->pages, nr_pages);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 kfree(wdata);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 save_len =3D cur=
_len;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i =
< nr_pages; i++) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 copied =3D min_t(const size_t, cur_len, PAGE_SIZE);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 copied =3D iov_iter_copy_from_user(wdata->pages[i], &it,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00, copied);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cur_len -=3D copied;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0iov_iter_advance(&it, copied);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 to_send[i+1].iov_base =3D kmap(pages[i]);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 to_send[i+1].iov_len =3D copied;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cur_len =3D =
save_len - cur_len;
> >
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->sync_mode=
 =3D WB_SYNC_ALL;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->nr_pages =
=3D nr_pages;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->offset =3D=
 (__u64)offset;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->cfile =3D=
 cifsFileInfo_get(open_file);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->pid =3D p=
id;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->bytes =3D=
 cur_len;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdata->marshal_i=
ov =3D cifs_uncached_marshal_iov;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (open_file->invalidHandle) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D cifs_reopen_file(open_=
file, false);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc !=3D 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
reak;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
>=20
> When we reopen a file, we do it with the current pid, but in
> cfile->pid leaves with the old value (and pid variable too).Should we
> do reopen with cfile->pid to save the original state of the file (now
> we don't restore locks, if we do it - it will be the problem)?
>=20

Yes, that does sound like something that should be fixed. That said, we
have a lot of problems in the code that handles open files, and that's
just one of them. At this point, I'm not going to fix that in this
patchset since it's an existing bug and unrelated to what I'm changing
here. It certainly wouldn't hurt to fix that at some point though.

> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_parms.netfid =3D open_file->netfid;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_parms.pid =3D pid;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_parms.tcon =3D tcon;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_parms.offset =3D *poffset;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 io_parms.length =3D cur_len;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D CIFSSMBWrite2(xid, &io_parms, &written, to_send,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0npages, 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D cifs_async_writev(wdata);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} while (rc =
=3D=3D -EAGAIN);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i =
< npages; i++)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 kunmap(pages[i]);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (written) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len -=3D written;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 total_written +=3D written;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_update_eof(CIFS_I(inode), *poffset, written);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 *poffset +=3D written;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (rc < =
0) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!total_written)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 total_written =3D rc;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 kref_put(&wdata->refcount, cifs_writedata_release);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* get length an=
d number of kvecs of the next write */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 npages =3D get_n=
umpages(cifs_sb->wsize, len, &cur_len);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&w=
data->list, &wdata_list);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 offset +=3D cur_=
len;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len -=3D cur_len=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} while (len > 0);
> >
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* If at least one write was successful=
ly sent, then discard any rc
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* value from the later writes. If the =
other write succeeds, then
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* we'll end up returning whatever was =
written. If it fails, then
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* we'll get a new rc value from that.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 if (!list_empty(&wdata_list))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Wait for and collect replies for any=
 successful sends in order of
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* increasing offset. Once an error is =
hit or we get a fatal signal
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* while waiting, then return without w=
aiting for any more replies.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > +restart_loop:
> > + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(wdata, tmp, &wdata_=
list, list) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* FIXME: freezable too? */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D wait_for_completion_killable(&wdata->done);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!rc) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wdata->result)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D=
 wdata->result;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tota=
l_written +=3D wdata->bytes;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else if (rc =3D=3D -EAGAIN) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 do {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (=
open_file->invalidHandle) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_reopen_file(open_file,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 false);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 if (rc !=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D=
 cifs_async_writev(wdata);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } while (rc =3D=3D -EAGAIN);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto restart_loop;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del_init(&w=
data->list);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kref_put(&wdata-=
>refcount, cifs_writedata_release);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (total_written > 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_update_eof(=
cifsi, *poffset, total_written);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *poffset +=3D to=
tal_written;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&i=
node->i_lock);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (*poffset > i=
node->i_size)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 i_size_write(inode, *poffset);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (offset > ino=
de->i_size)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 i_size_write(inode, cifsi->server_eof);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(=
&inode->i_lock);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_stats_bytes_written(tcon, total_wri=
tten);
> > - =C2=A0 =C2=A0 =C2=A0 mark_inode_dirty_sync(inode);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < num_pages; i++)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_page(pages[i=
]);
> > - =C2=A0 =C2=A0 =C2=A0 kfree(to_send);
> > - =C2=A0 =C2=A0 =C2=A0 kfree(pages);
> > - =C2=A0 =C2=A0 =C2=A0 FreeXid(xid);
> > - =C2=A0 =C2=A0 =C2=A0 return total_written;
> > + =C2=A0 =C2=A0 =C2=A0 return total_written ? total_written : (ssiz=
e_t)rc;
> > =C2=A0}
> >
> > =C2=A0ssize_t cifs_user_writev(struct kiocb *iocb, const struct iov=
ec *iov,
> > --
> > 1.7.7.6
> >
>=20
> The patch itself looks correct.
>=20
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
