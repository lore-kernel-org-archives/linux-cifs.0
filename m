From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH V3 (resend) 3/7] CIFS: Add support for direct I/O read
Date: Fri, 21 Sep 2018 15:18:41 -0700
Message-ID: <CAKywueSskdYv-_qSU9qmjUGz148EZci90mXd5EVpj=GUGfZaJg@mail.gmail.com>
References: <20180920211842.13721-1-longli@linuxonhyperv.com> <20180920211842.13721-3-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920211842.13721-3-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

=D1=87=D1=82, 20 =D1=81=D0=B5=D0=BD=D1=82. 2018 =D0=B3. =D0=B2 14:22, Long =
Li <longli@linuxonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> With direct I/O read, we transfer the data directly from transport layer =
to
> the user data buffer.
>
> Change in v3: add support for kernel AIO
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/cifsfs.h   |   1 +
>  fs/cifs/cifsglob.h |   5 ++
>  fs/cifs/file.c     | 210 +++++++++++++++++++++++++++++++++++++++++++++--=
------
>  3 files changed, 187 insertions(+), 29 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index f047e87..ed5479c 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -101,6 +101,7 @@ extern int cifs_open(struct inode *inode, struct file=
 *file);
>  extern int cifs_close(struct inode *inode, struct file *file);
>  extern int cifs_closedir(struct inode *inode, struct file *file);
>  extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
> +extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to=
);
>  extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to=
);
>  extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *fro=
m);
>  extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *f=
rom);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 9dcaed0..2131fec 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1172,6 +1172,11 @@ struct cifs_aio_ctx {
>         unsigned int            len;
>         unsigned int            total_len;
>         bool                    should_dirty;
> +       /*
> +        * Indicates if this aio_ctx is for direct_io,
> +        * If yes, iter is a copy of the user passed iov_iter
> +        */
> +       bool                    direct_io;
>  };
>
>  struct cifs_readdata;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8d41ca7..6a939fa 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2965,7 +2965,6 @@ cifs_uncached_readdata_release(struct kref *refcoun=
t)
>         kref_put(&rdata->ctx->refcount, cifs_aio_ctx_release);
>         for (i =3D 0; i < rdata->nr_pages; i++) {
>                 put_page(rdata->pages[i]);
> -               rdata->pages[i] =3D NULL;

why is this needed?

>         }
>         cifs_readdata_release(refcount);
>  }
> @@ -3004,7 +3003,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, s=
truct iov_iter *iter)
>         return remaining ? -EFAULT : 0;
>  }
>
> -static void collect_uncached_read_data(struct cifs_aio_ctx *ctx);
> +static void collect_uncached_read_data(struct cifs_readdata *rdata, stru=
ct cifs_aio_ctx *ctx);
>
>  static void
>  cifs_uncached_readv_complete(struct work_struct *work)
> @@ -3013,7 +3012,7 @@ cifs_uncached_readv_complete(struct work_struct *wo=
rk)
>                                                 struct cifs_readdata, wor=
k);
>
>         complete(&rdata->done);
> -       collect_uncached_read_data(rdata->ctx);
> +       collect_uncached_read_data(rdata, rdata->ctx);
>         /* the below call can possibly free the last ref to aio ctx */
>         kref_put(&rdata->refcount, cifs_uncached_readdata_release);
>  }
> @@ -3103,6 +3102,9 @@ cifs_send_async_read(loff_t offset, size_t len, str=
uct cifsFileInfo *open_file,
>         int rc;
>         pid_t pid;
>         struct TCP_Server_Info *server;
> +       struct page **pagevec;
> +       size_t start;
> +       struct iov_iter direct_iov =3D ctx->iter;
>
>         server =3D tlink_tcon(open_file->tlink)->ses->server;
>
> @@ -3111,6 +3113,9 @@ cifs_send_async_read(loff_t offset, size_t len, str=
uct cifsFileInfo *open_file,
>         else
>                 pid =3D current->tgid;
>
> +       if (ctx->direct_io)
> +               iov_iter_advance(&direct_iov, offset - ctx->pos);
> +
>         do {
>                 rc =3D server->ops->wait_mtu_credits(server, cifs_sb->rsi=
ze,
>                                                    &rsize, &credits);
> @@ -3118,20 +3123,56 @@ cifs_send_async_read(loff_t offset, size_t len, s=
truct cifsFileInfo *open_file,
>                         break;
>
>                 cur_len =3D min_t(const size_t, len, rsize);
> -               npages =3D DIV_ROUND_UP(cur_len, PAGE_SIZE);
>
> -               /* allocate a readdata struct */
> -               rdata =3D cifs_readdata_alloc(npages,
> +               if (ctx->direct_io) {
> +
> +                       cur_len =3D iov_iter_get_pages_alloc(
> +                                       &direct_iov, &pagevec,
> +                                       cur_len, &start);
> +                       if (cur_len < 0) {
> +                               cifs_dbg(VFS,
> +                                       "couldn't get user pages (cur_len=
=3D%zd)"
> +                                       " iter type %d"
> +                                       " iov_offset %zd count %zd\n",
> +                                       cur_len, direct_iov.type, direct_=
iov.iov_offset,
> +                                       direct_iov.count);
> +                               dump_stack();
> +                               break;
> +                       }
> +                       iov_iter_advance(&direct_iov, cur_len);
> +
> +                       rdata =3D cifs_readdata_direct_alloc(
> +                                       pagevec, cifs_uncached_readv_comp=
lete);
> +                       if (!rdata) {
> +                               add_credits_and_wake_if(server, credits, =
0);
> +                               rc =3D -ENOMEM;
> +                               break;
> +                       }
> +
> +                       npages =3D (cur_len + start + PAGE_SIZE-1) / PAGE=
_SIZE;
> +                       rdata->page_offset =3D start;
> +                       rdata->tailsz =3D npages > 1 ?
> +                               cur_len-(PAGE_SIZE-start)-(npages-2)*PAGE=
_SIZE :
> +                               cur_len;
> +
> +               } else {
> +
> +                       npages =3D DIV_ROUND_UP(cur_len, PAGE_SIZE);
> +                       /* allocate a readdata struct */
> +                       rdata =3D cifs_readdata_alloc(npages,
>                                             cifs_uncached_readv_complete)=
;
> -               if (!rdata) {
> -                       add_credits_and_wake_if(server, credits, 0);
> -                       rc =3D -ENOMEM;
> -                       break;
> -               }
> +                       if (!rdata) {
> +                               add_credits_and_wake_if(server, credits, =
0);
> +                               rc =3D -ENOMEM;
> +                               break;
> +                       }
>
> -               rc =3D cifs_read_allocate_pages(rdata, npages);
> -               if (rc)
> -                       goto error;
> +                       rc =3D cifs_read_allocate_pages(rdata, npages);
> +                       if (rc)
> +                               goto error;
> +
> +                       rdata->tailsz =3D PAGE_SIZE;
> +               }
>
>                 rdata->cfile =3D cifsFileInfo_get(open_file);
>                 rdata->nr_pages =3D npages;
> @@ -3139,7 +3180,6 @@ cifs_send_async_read(loff_t offset, size_t len, str=
uct cifsFileInfo *open_file,
>                 rdata->bytes =3D cur_len;
>                 rdata->pid =3D pid;
>                 rdata->pagesz =3D PAGE_SIZE;
> -               rdata->tailsz =3D PAGE_SIZE;
>                 rdata->read_into_pages =3D cifs_uncached_read_into_pages;
>                 rdata->copy_into_pages =3D cifs_uncached_copy_into_pages;
>                 rdata->credits =3D credits;
> @@ -3153,13 +3193,17 @@ cifs_send_async_read(loff_t offset, size_t len, s=
truct cifsFileInfo *open_file,
>                 if (rc) {
>                         add_credits_and_wake_if(server, rdata->credits, 0=
);
>                         kref_put(&rdata->refcount,
> -                                cifs_uncached_readdata_release);
> -                       if (rc =3D=3D -EAGAIN)
> +                               cifs_uncached_readdata_release);
> +                       if (rc =3D=3D -EAGAIN) {
> +                               iov_iter_revert(&direct_iov, cur_len);
>                                 continue;
> +                       }
>                         break;
>                 }
>
> -               list_add_tail(&rdata->list, rdata_list);
> +               /* Add to aio pending list if it's not there */
> +               if (rdata_list)
> +                       list_add_tail(&rdata->list, rdata_list);
>                 offset +=3D cur_len;
>                 len -=3D cur_len;
>         } while (len > 0);
> @@ -3168,7 +3212,7 @@ cifs_send_async_read(loff_t offset, size_t len, str=
uct cifsFileInfo *open_file,
>  }
>
>  static void
> -collect_uncached_read_data(struct cifs_aio_ctx *ctx)
> +collect_uncached_read_data(struct cifs_readdata *uncached_rdata, struct =
cifs_aio_ctx *ctx)

Why do you need uncached_rdata argument? It doesn't seem you are using
it in this function.

>  {
>         struct cifs_readdata *rdata, *tmp;
>         struct iov_iter *to =3D &ctx->iter;
> @@ -3211,10 +3255,12 @@ collect_uncached_read_data(struct cifs_aio_ctx *c=
tx)
>                                  * reading.
>                                  */
>                                 if (got_bytes && got_bytes < rdata->bytes=
) {
> -                                       rc =3D cifs_readdata_to_iov(rdata=
, to);
> +                                       rc =3D 0;
> +                                       if (!ctx->direct_io)
> +                                               rc =3D cifs_readdata_to_i=
ov(rdata, to);
>                                         if (rc) {
>                                                 kref_put(&rdata->refcount=
,
> -                                               cifs_uncached_readdata_re=
lease);
> +                                                       cifs_uncached_rea=
ddata_release);
>                                                 continue;
>                                         }
>                                 }
> @@ -3228,28 +3274,32 @@ collect_uncached_read_data(struct cifs_aio_ctx *c=
tx)
>                                 list_splice(&tmp_list, &ctx->list);
>
>                                 kref_put(&rdata->refcount,
> -                                        cifs_uncached_readdata_release);
> +                                       cifs_uncached_readdata_release);
>                                 goto again;
>                         } else if (rdata->result)
>                                 rc =3D rdata->result;
> -                       else
> +                       else if (!ctx->direct_io)
>                                 rc =3D cifs_readdata_to_iov(rdata, to);
>
>                         /* if there was a short read -- discard anything =
left */
>                         if (rdata->got_bytes && rdata->got_bytes < rdata-=
>bytes)
>                                 rc =3D -ENODATA;
> +
> +                       ctx->total_len +=3D rdata->got_bytes;
>                 }
>                 list_del_init(&rdata->list);
>                 kref_put(&rdata->refcount, cifs_uncached_readdata_release=
);
>         }
>
> -       for (i =3D 0; i < ctx->npages; i++) {
> -               if (ctx->should_dirty)
> -                       set_page_dirty(ctx->bv[i].bv_page);
> -               put_page(ctx->bv[i].bv_page);
> -       }
> +       if (!ctx->direct_io) {
> +               for (i =3D 0; i < ctx->npages; i++) {
> +                       if (ctx->should_dirty)
> +                               set_page_dirty(ctx->bv[i].bv_page);
> +                       put_page(ctx->bv[i].bv_page);
> +               }
>
> -       ctx->total_len =3D ctx->len - iov_iter_count(to);
> +               ctx->total_len =3D ctx->len - iov_iter_count(to);
> +       }
>
>         cifs_stats_bytes_read(tcon, ctx->total_len);
>
> @@ -3267,6 +3317,108 @@ collect_uncached_read_data(struct cifs_aio_ctx *c=
tx)
>                 complete(&ctx->done);
>  }
>
> +ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to)
> +{
> +       size_t len;
> +       struct file *file;
> +       struct cifs_sb_info *cifs_sb;
> +       struct cifsFileInfo *cfile;
> +       struct cifs_tcon *tcon;
> +       ssize_t rc, total_read =3D 0;
> +       struct TCP_Server_Info *server;
> +       loff_t offset =3D iocb->ki_pos;
> +       pid_t pid;
> +       struct cifs_aio_ctx *ctx;
> +
> +       /*
> +        * iov_iter_get_pages_alloc() doesn't work with ITER_KVEC,
> +        * fall back to data copy read path
> +        * this could be improved by getting pages directly in ITER_KVEC
> +        */
> +       if (to->type & ITER_KVEC) {
> +               cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/=
O\n");
> +               return cifs_user_readv(iocb, to);
> +       }
> +
> +       len =3D iov_iter_count(to);
> +       if (!len)
> +               return 0;
> +
> +       file =3D iocb->ki_filp;
> +       cifs_sb =3D CIFS_FILE_SB(file);
> +       cfile =3D file->private_data;
> +       tcon =3D tlink_tcon(cfile->tlink);
> +       server =3D tcon->ses->server;
> +
> +       if (!server->ops->async_readv)
> +               return -ENOSYS;
> +
> +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +               pid =3D cfile->pid;
> +       else
> +               pid =3D current->tgid;
> +

pid variable is not being used.

> +       if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
> +               cifs_dbg(FYI, "attempting read on write only file instanc=
e\n");
> +
> +       ctx =3D cifs_aio_ctx_alloc();
> +       if (!ctx)
> +               return -ENOMEM;
> +
> +       ctx->cfile =3D cifsFileInfo_get(cfile);
> +
> +       if (!is_sync_kiocb(iocb))
> +               ctx->iocb =3D iocb;
> +
> +       if (to->type =3D=3D ITER_IOVEC)
> +               ctx->should_dirty =3D true;
> +
> +       ctx->pos =3D offset;
> +       ctx->direct_io =3D true;
> +       ctx->iter =3D *to;
> +       ctx->len =3D len;
> +
> +       /* grab a lock here due to read response handlers can access ctx =
*/
> +       mutex_lock(&ctx->aio_mutex);
> +
> +       rc =3D cifs_send_async_read(offset, len, cfile, cifs_sb, &ctx->li=
st, ctx);
> +
> +       /* if at least one read request send succeeded, then reset rc */
> +       if (!list_empty(&ctx->list))
> +               rc =3D 0;
> +
> +       mutex_unlock(&ctx->aio_mutex);
> +
> +       if (rc) {
> +               kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +               return rc;
> +       }
> +
> +       if (!is_sync_kiocb(iocb)) {
> +               kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +               return -EIOCBQUEUED;
> +       }
> +
> +       rc =3D wait_for_completion_killable(&ctx->done);
> +       if (rc) {
> +               mutex_lock(&ctx->aio_mutex);
> +               ctx->rc =3D rc =3D -EINTR;
> +               total_read =3D ctx->total_len;
> +               mutex_unlock(&ctx->aio_mutex);
> +       } else {
> +               rc =3D ctx->rc;
> +               total_read =3D ctx->total_len;
> +       }
> +
> +       kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +
> +       if (total_read) {
> +               iocb->ki_pos +=3D total_read;
> +               return total_read;
> +       }
> +       return rc;

This function is almost identical to cifs_user_readv. Can the latter
be refactored to avoid code duplication?

> +}
> +
>  ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>  {
>         struct file *file =3D iocb->ki_filp;
> --
> 2.7.4
>
