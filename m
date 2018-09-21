From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH V3 (resend) 4/7] CIFS: Add support for direct I/O write
Date: Fri, 21 Sep 2018 15:30:18 -0700
Message-ID: <CAKywueTc7AHR-NEJu9dgWv9m_2A-MkOpsdQGZSt+X3u9kyX54Q@mail.gmail.com>
References: <20180920211842.13721-1-longli@linuxonhyperv.com> <20180920211842.13721-4-longli@linuxonhyperv.com>
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
In-Reply-To: <20180920211842.13721-4-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

=D1=87=D1=82, 20 =D1=81=D0=B5=D0=BD=D1=82. 2018 =D0=B3. =D0=B2 14:22, Long =
Li <longli@linuxonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> With direct I/O write, user supplied buffers are pinned to the memory and=
 data
> are transferred directly from user buffers to the transport layer.
>
> Change in v3: add support for kernel AIO
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/cifsfs.h |   1 +
>  fs/cifs/file.c   | 196 ++++++++++++++++++++++++++++++++++++++++++++++---=
------
>  2 files changed, 166 insertions(+), 31 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index ed5479c..cc54051 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -104,6 +104,7 @@ extern ssize_t cifs_user_readv(struct kiocb *iocb, st=
ruct iov_iter *to);
>  extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to=
);
>  extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to=
);
>  extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *fro=
m);
> +extern ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *f=
rom);
>  extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *f=
rom);
>  extern int cifs_lock(struct file *, int, struct file_lock *);
>  extern int cifs_fsync(struct file *, loff_t, loff_t, int);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6a939fa..2a5d209 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2537,6 +2537,8 @@ cifs_write_from_iter(loff_t offset, size_t len, str=
uct iov_iter *from,
>         loff_t saved_offset =3D offset;
>         pid_t pid;
>         struct TCP_Server_Info *server;
> +       struct page **pagevec;
> +       size_t start;
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>                 pid =3D open_file->pid;
> @@ -2553,38 +2555,74 @@ cifs_write_from_iter(loff_t offset, size_t len, s=
truct iov_iter *from,
>                 if (rc)
>                         break;
>
> -               nr_pages =3D get_numpages(wsize, len, &cur_len);
> -               wdata =3D cifs_writedata_alloc(nr_pages,
> +               if (ctx->direct_io) {
> +                       cur_len =3D iov_iter_get_pages_alloc(
> +                               from, &pagevec, wsize, &start);
> +                       if (cur_len < 0) {
> +                               cifs_dbg(VFS,
> +                                       "direct_writev couldn't get user =
pages "
> +                                       "(rc=3D%zd) iter type %d iov_offs=
et %zd count"
> +                                       " %zd\n",
> +                                       cur_len, from->type,
> +                                       from->iov_offset, from->count);
> +                               dump_stack();
> +                               break;
> +                       }
> +                       iov_iter_advance(from, cur_len);
> +
> +                       nr_pages =3D (cur_len + start + PAGE_SIZE - 1) / =
PAGE_SIZE;
> +
> +                       wdata =3D cifs_writedata_direct_alloc(pagevec,
>                                              cifs_uncached_writev_complet=
e);
> -               if (!wdata) {
> -                       rc =3D -ENOMEM;
> -                       add_credits_and_wake_if(server, credits, 0);
> -                       break;
> -               }
> +                       if (!wdata) {
> +                               rc =3D -ENOMEM;
> +                               add_credits_and_wake_if(server, credits, =
0);
> +                               break;
> +                       }
>
> -               rc =3D cifs_write_allocate_pages(wdata->pages, nr_pages);
> -               if (rc) {
> -                       kfree(wdata);
> -                       add_credits_and_wake_if(server, credits, 0);
> -                       break;
> -               }
>
> -               num_pages =3D nr_pages;
> -               rc =3D wdata_fill_from_iovec(wdata, from, &cur_len, &num_=
pages);
> -               if (rc) {
> -                       for (i =3D 0; i < nr_pages; i++)
> -                               put_page(wdata->pages[i]);
> -                       kfree(wdata);
> -                       add_credits_and_wake_if(server, credits, 0);
> -                       break;
> -               }
> +                       wdata->page_offset =3D start;
> +                       wdata->tailsz =3D
> +                               nr_pages > 1 ?
> +                                       cur_len - (PAGE_SIZE - start) -
> +                                       (nr_pages - 2) * PAGE_SIZE :
> +                                       cur_len;
> +               } else {
> +                       nr_pages =3D get_numpages(wsize, len, &cur_len);
> +                       wdata =3D cifs_writedata_alloc(nr_pages,
> +                                            cifs_uncached_writev_complet=
e);
> +                       if (!wdata) {
> +                               rc =3D -ENOMEM;
> +                               add_credits_and_wake_if(server, credits, =
0);
> +                               break;
> +                       }
>
> -               /*
> -                * Bring nr_pages down to the number of pages we actually=
 used,
> -                * and free any pages that we didn't use.
> -                */
> -               for ( ; nr_pages > num_pages; nr_pages--)
> -                       put_page(wdata->pages[nr_pages - 1]);
> +                       rc =3D cifs_write_allocate_pages(wdata->pages, nr=
_pages);
> +                       if (rc) {
> +                               kfree(wdata);
> +                               add_credits_and_wake_if(server, credits, =
0);
> +                               break;
> +                       }
> +
> +                       num_pages =3D nr_pages;
> +                       rc =3D wdata_fill_from_iovec(wdata, from, &cur_le=
n, &num_pages);
> +                       if (rc) {
> +                               for (i =3D 0; i < nr_pages; i++)
> +                                       put_page(wdata->pages[i]);
> +                               kfree(wdata);
> +                               add_credits_and_wake_if(server, credits, =
0);
> +                               break;
> +                       }
> +
> +                       /*
> +                        * Bring nr_pages down to the number of pages we =
actually used,
> +                        * and free any pages that we didn't use.
> +                        */
> +                       for ( ; nr_pages > num_pages; nr_pages--)
> +                               put_page(wdata->pages[nr_pages - 1]);
> +
> +                       wdata->tailsz =3D cur_len - ((nr_pages - 1) * PAG=
E_SIZE);
> +               }
>
>                 wdata->sync_mode =3D WB_SYNC_ALL;
>                 wdata->nr_pages =3D nr_pages;
> @@ -2593,7 +2631,6 @@ cifs_write_from_iter(loff_t offset, size_t len, str=
uct iov_iter *from,
>                 wdata->pid =3D pid;
>                 wdata->bytes =3D cur_len;
>                 wdata->pagesz =3D PAGE_SIZE;
> -               wdata->tailsz =3D cur_len - ((nr_pages - 1) * PAGE_SIZE);
>                 wdata->credits =3D credits;
>                 wdata->ctx =3D ctx;
>                 kref_get(&ctx->refcount);
> @@ -2687,8 +2724,9 @@ static void collect_uncached_write_data(struct cifs=
_aio_ctx *ctx)
>                 kref_put(&wdata->refcount, cifs_uncached_writedata_releas=
e);
>         }
>
> -       for (i =3D 0; i < ctx->npages; i++)
> -               put_page(ctx->bv[i].bv_page);
> +       if (!ctx->direct_io)
> +               for (i =3D 0; i < ctx->npages; i++)
> +                       put_page(ctx->bv[i].bv_page);
>
>         cifs_stats_bytes_written(tcon, ctx->total_len);
>         set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags=
);
> @@ -2703,6 +2741,102 @@ static void collect_uncached_write_data(struct ci=
fs_aio_ctx *ctx)
>                 complete(&ctx->done);
>  }
>
> +ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)

the same comment as for readv: this function is almost identical to
cifs_user_writev, can't the latter be refactored to avoid code
duplication?

> +{
> +       struct file *file =3D iocb->ki_filp;
> +       ssize_t total_written =3D 0;
> +       struct cifsFileInfo *cfile;
> +       struct cifs_tcon *tcon;
> +       struct cifs_sb_info *cifs_sb;
> +       struct TCP_Server_Info *server;
> +       size_t len =3D iov_iter_count(from);
> +       int rc;
> +       struct cifs_aio_ctx *ctx;
> +
> +       /*
> +        * iov_iter_get_pages_alloc doesn't work with ITER_KVEC.
> +        * In this case, fall back to non-direct write function.
> +        * this could be improved by getting pages directly in ITER_KVEC
> +        */
> +       if (from->type & ITER_KVEC) {
> +               cifs_dbg(FYI, "use non-direct cifs_user_writev for kvec I=
/O\n");
> +               return cifs_user_writev(iocb, from);
> +       }
> +
> +       rc =3D generic_write_checks(iocb, from);
> +       if (rc <=3D 0)
> +               return rc;
> +
> +       cifs_sb =3D CIFS_FILE_SB(file);
> +       cfile =3D file->private_data;
> +       tcon =3D tlink_tcon(cfile->tlink);
> +       server =3D tcon->ses->server;
> +
> +       if (!server->ops->async_writev)
> +               return -ENOSYS;
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
> +       ctx->pos =3D iocb->ki_pos;
> +
> +       ctx->direct_io =3D true;
> +       ctx->iter =3D *from;
> +       ctx->len =3D len;
> +
> +       /* grab a lock here due to read response handlers can access ctx =
*/
> +       mutex_lock(&ctx->aio_mutex);
> +
> +       rc =3D cifs_write_from_iter(iocb->ki_pos, ctx->len, from,
> +                                 cfile, cifs_sb, &ctx->list, ctx);
> +
> +       /*
> +        * If at least one write was successfully sent, then discard any =
rc
> +        * value from the later writes. If the other write succeeds, then
> +        * we'll end up returning whatever was written. If it fails, then
> +        * we'll get a new rc value from that.
> +        */
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
> +               total_written =3D ctx->total_len;
> +               mutex_unlock(&ctx->aio_mutex);
> +       } else {
> +               rc =3D ctx->rc;
> +               total_written =3D ctx->total_len;
> +       }
> +
> +       kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +
> +       if (unlikely(!total_written))
> +               return rc;
> +
> +       iocb->ki_pos +=3D total_written;
> +       return total_written;
> +}
> +
>  ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
>  {
>         struct file *file =3D iocb->ki_filp;
> --
> 2.7.4
>


--
Best regards,
Pavel Shilovsky
