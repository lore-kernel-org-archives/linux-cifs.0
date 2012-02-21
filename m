From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 8/8] cifs: convert cifs_iovec_write to use async writes
Date: Tue, 21 Feb 2012 12:06:49 +0400
Message-ID: <CAKywueT3Cmw4ffuE1wvMzxZniWyUUCU=8rtrB4Eu7Zz3FMtecQ@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-9-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-9-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A02 +
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A04 +-
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0191 +++++++++++++++++++++++++++++++=
+-------------------
> =A03 files changed, 126 insertions(+), 71 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index bceadc5..a131ded 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -473,6 +473,8 @@ int cifs_async_readv(struct cifs_readdata *rdata)=
;
> =A0/* asynchronous write support */
> =A0struct cifs_writedata {
> =A0 =A0 =A0 =A0struct kref =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 re=
fcount;
> + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list;
> + =A0 =A0 =A0 struct completion =A0 =A0 =A0 =A0 =A0 =A0 =A0 done;
> =A0 =A0 =A0 =A0enum writeback_sync_modes =A0 =A0 =A0 sync_mode;
> =A0 =A0 =A0 =A0struct work_struct =A0 =A0 =A0 =A0 =A0 =A0 =A0work;
> =A0 =A0 =A0 =A0struct cifsFileInfo =A0 =A0 =A0 =A0 =A0 =A0 *cfile;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 113b5af..6e93c9e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2034,8 +2034,10 @@ cifs_writedata_alloc(unsigned int nr_pages, wo=
rk_func_t complete)
> =A0 =A0 =A0 =A0wdata =3D kzalloc(sizeof(*wdata) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct page *) =
* (nr_pages - 1), GFP_NOFS);
> =A0 =A0 =A0 =A0if (wdata !=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, complete);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kref_init(&wdata->refcount);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&wdata->list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_completion(&wdata->done);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, complete);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return wdata;
> =A0}
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c7e47a2..ef25fc5 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2057,23 +2057,55 @@ size_t get_numpages(const size_t wsize, const=
 size_t len, size_t *cur_len)
> =A0 =A0 =A0 =A0return num_pages;
> =A0}
>
> +static void
> +cifs_uncached_marshal_iov(struct kvec *iov, struct cifs_writedata *w=
data)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 size_t bytes =3D wdata->bytes;
> +
> + =A0 =A0 =A0 /* marshal up the pages into iov array */
> + =A0 =A0 =A0 for (i =3D 0; i < wdata->nr_pages; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_len =3D min(bytes, PAGE_=
SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_base =3D kmap(wdata->pag=
es[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes -=3D iov[i + 1].iov_len;
> + =A0 =A0 =A0 }
> +}
> +
> +static void
> +cifs_uncached_writev_complete(struct work_struct *work)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 struct cifs_writedata *wdata =3D container_of(work,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct cifs_writedata, work);
> +
> + =A0 =A0 =A0 complete(&wdata->done);
> +
> + =A0 =A0 =A0 if (wdata->result !=3D -EAGAIN) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < wdata->nr_pages; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_page(wdata->pages[i=
]);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writedata_release);
> +}
> +
> =A0static ssize_t
> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poffse=
t)
> =A0{
> - =A0 =A0 =A0 unsigned int written;
> - =A0 =A0 =A0 unsigned long num_pages, npages, i;
> + =A0 =A0 =A0 unsigned long nr_pages, i;
> =A0 =A0 =A0 =A0size_t copied, len, cur_len;
> =A0 =A0 =A0 =A0ssize_t total_written =3D 0;
> - =A0 =A0 =A0 struct kvec *to_send;
> - =A0 =A0 =A0 struct page **pages;
> + =A0 =A0 =A0 loff_t offset =3D *poffset;
> =A0 =A0 =A0 =A0struct iov_iter it;
> - =A0 =A0 =A0 struct inode *inode;
> + =A0 =A0 =A0 struct inode *inode =3D file->f_path.dentry->d_inode;
> + =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 int xid, rc;
> - =A0 =A0 =A0 __u32 pid;
> + =A0 =A0 =A0 struct cifs_writedata *wdata, *tmp;
> + =A0 =A0 =A0 struct list_head wdata_list;
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 pid_t pid;
>
> =A0 =A0 =A0 =A0len =3D iov_length(iov, nr_segs);
> =A0 =A0 =A0 =A0if (!len)
> @@ -2083,103 +2115,122 @@ cifs_iovec_write(struct file *file, const s=
truct iovec *iov,
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> + =A0 =A0 =A0 INIT_LIST_HEAD(&wdata_list);
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> - =A0 =A0 =A0 num_pages =3D get_numpages(cifs_sb->wsize, len, &cur_le=
n);
> -
> - =A0 =A0 =A0 pages =3D kmalloc(sizeof(struct pages *)*num_pages, GFP=
_KERNEL);
> - =A0 =A0 =A0 if (!pages)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> -
> - =A0 =A0 =A0 to_send =3D kmalloc(sizeof(struct kvec)*(num_pages + 1)=
, GFP_KERNEL);
> - =A0 =A0 =A0 if (!to_send) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 rc =3D cifs_write_allocate_pages(pages, num_pages);
> - =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(to_send);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 xid =3D GetXid();
> =A0 =A0 =A0 =A0open_file =3D file->private_data;
> + =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
>
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D open_file->pid;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D current->tgid;
>
> - =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
> - =A0 =A0 =A0 inode =3D file->f_path.dentry->d_inode;
> -
> =A0 =A0 =A0 =A0iov_iter_init(&it, iov, nr_segs, len, 0);
> - =A0 =A0 =A0 npages =3D num_pages;
> -
> =A0 =A0 =A0 =A0do {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t save_len =3D cur_len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D min_t(const =
size_t, cur_len, PAGE_CACHE_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D iov_iter_cop=
y_from_user(pages[i], &it, 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0copied);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t save_len;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_pages =3D get_numpages(cifs_sb->wsiz=
e, len, &cur_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata =3D cifs_writedata_alloc(nr_pages=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0cifs_uncached_writev_complete);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!wdata) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_write_allocate_pages(wdata-=
>pages, nr_pages);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(wdata);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 save_len =3D cur_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < nr_pages; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D min_t(const =
size_t, cur_len, PAGE_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied =3D iov_iter_cop=
y_from_user(wdata->pages[i], &it,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, copied);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_len -=3D copied;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov_iter_advance(&it, =
copied);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_base =3D=
 kmap(pages[i]);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_send[i+1].iov_len =3D=
 copied;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cur_len =3D save_len - cur_len;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->sync_mode =3D WB_SYNC_ALL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->nr_pages =3D nr_pages;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->offset =3D (__u64)offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->cfile =3D cifsFileInfo_get(open_=
file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->pid =3D pid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->bytes =3D cur_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->marshal_iov =3D cifs_uncached_ma=
rshal_iov;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->invalid=
Handle) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 cifs_reopen_file(open_file, false);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc=
 !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}

When we reopen a file, we do it with the current pid, but in
cfile->pid leaves with the old value (and pid variable too).Should we
do reopen with cfile->pid to save the original state of the file (now
we don't restore locks, if we do it - it will be the problem)?

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.netfid =3D ope=
n_file->netfid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.pid =3D pid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.tcon =3D tcon;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.offset =3D *po=
ffset;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.length =3D cur=
_len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xi=
d, &io_parms, &written, to_send,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0npages, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_async_write=
v(wdata);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (rc =3D=3D -EAGAIN);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < npages; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(pages[i]);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (written) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D written;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_written +=3D writ=
ten;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_update_eof(CIFS_I(=
inode), *poffset, written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffset +=3D written;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!total_written)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_w=
ritten =3D rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcou=
nt, cifs_writedata_release);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* get length and number of kvecs of th=
e next write */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 npages =3D get_numpages(cifs_sb->wsize,=
 len, &cur_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&wdata->list, &wdata_list=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D cur_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D cur_len;
> =A0 =A0 =A0 =A0} while (len > 0);
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If at least one write was successfully sent, then =
discard any rc
> + =A0 =A0 =A0 =A0* value from the later writes. If the other write su=
cceeds, then
> + =A0 =A0 =A0 =A0* we'll end up returning whatever was written. If it=
 fails, then
> + =A0 =A0 =A0 =A0* we'll get a new rc value from that.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!list_empty(&wdata_list))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Wait for and collect replies for any successful se=
nds in order of
> + =A0 =A0 =A0 =A0* increasing offset. Once an error is hit or we get =
a fatal signal
> + =A0 =A0 =A0 =A0* while waiting, then return without waiting for any=
 more replies.
> + =A0 =A0 =A0 =A0*/
> +restart_loop:
> + =A0 =A0 =A0 list_for_each_entry_safe(wdata, tmp, &wdata_list, list)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: freezable too=
? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_for_complet=
ion_killable(&wdata->done);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wda=
ta->result)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D wdata->result;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 total_written +=3D wdata->bytes;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc =3D=3D -E=
AGAIN) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (open_file->invalidHandle) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_reopen_file(open_file,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 false);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D cifs_async_writev(wdata);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while=
 (rc =3D=3D -EAGAIN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto re=
start_loop;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&wdata->list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_put(&wdata->refcount, cifs_writeda=
ta_release);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (total_written > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_update_eof(cifsi, *poffset, total_=
written);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffset +=3D total_written;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&inode->i_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*poffset > inode->i_size)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, *po=
ffset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset > inode->i_size)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, cif=
si->server_eof);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&inode->i_lock);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cifs_stats_bytes_written(tcon, total_written);
> - =A0 =A0 =A0 mark_inode_dirty_sync(inode);
> -
> - =A0 =A0 =A0 for (i =3D 0; i < num_pages; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
> - =A0 =A0 =A0 kfree(to_send);
> - =A0 =A0 =A0 kfree(pages);
> - =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 return total_written;
> + =A0 =A0 =A0 return total_written ? total_written : (ssize_t)rc;
> =A0}
>
> =A0ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *i=
ov,
> --
> 1.7.7.6
>

The patch itself looks correct.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
