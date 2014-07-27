From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 16/16] CIFS: Use multicredits for SMB 2.1/3 reads
Date: Sun, 27 Jul 2014 08:05:55 -0500
Message-ID: <CADT32eKvR0xj3oi=BMkwGd5r4OcuEMkK_JxOosoxFkSFAcUe1A@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-17-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-17-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If we negotiate SMB 2.1 and higher version of the protocol and
> a server supports large read buffer size, we need to consume 1
> credit per 65536 bytes. So, we need to know how many credits
> we have and obtain the required number of them before constructing
> a readdata structure in readpages and user read.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  1 +
>  fs/cifs/file.c     | 35 ++++++++++++++++++++++++++++-------
>  fs/cifs/smb2ops.c  |  2 --
>  fs/cifs/smb2pdu.c  | 30 +++++++++++++++++++++++++++---
>  4 files changed, 56 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 54ca2b9..f33ff4c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1068,6 +1068,7 @@ struct cifs_readdata {
>         struct kvec                     iov;
>         unsigned int                    pagesz;
>         unsigned int                    tailsz;
> +       unsigned int                    credits;
>         unsigned int                    nr_pages;
>         struct page                     *pages[];
>  };
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 00b2a25..ebdeb56 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2917,7 +2917,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                      struct cifs_sb_info *cifs_sb, struct list_head *rdata_list)
>  {
>         struct cifs_readdata *rdata;
> -       unsigned int npages;
> +       unsigned int npages, rsize, credits;
>         size_t cur_len;
>         int rc;
>         pid_t pid;
> @@ -2931,13 +2931,19 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                 pid = current->tgid;
>
>         do {
> -               cur_len = min_t(const size_t, len, cifs_sb->rsize);
> +               rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
> +                                                  &rsize, &credits);
> +               if (rc)
> +                       break;
> +
> +               cur_len = min_t(const size_t, len, rsize);
>                 npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
>
>                 /* allocate a readdata struct */
>                 rdata = cifs_readdata_alloc(npages,
>                                             cifs_uncached_readv_complete);
>                 if (!rdata) {
> +                       add_credits_and_wake_if(server, credits, 0);
>                         rc = -ENOMEM;
>                         break;
>                 }
> @@ -2953,12 +2959,14 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                 rdata->pid = pid;
>                 rdata->pagesz = PAGE_SIZE;
>                 rdata->read_into_pages = cifs_uncached_read_into_pages;
> +               rdata->credits = credits;
>
>                 if (!rdata->cfile->invalidHandle ||
>                     !cifs_reopen_file(rdata->cfile, true))
>                         rc = server->ops->async_readv(rdata);
>  error:
>                 if (rc) {
> +                       add_credits_and_wake_if(server, rdata->credits, 0);
>                         kref_put(&rdata->refcount,
>                                  cifs_uncached_readdata_release);
>                         if (rc == -EAGAIN)
> @@ -3458,10 +3466,16 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>          * the rdata->pages, then we want them in increasing order.
>          */
>         while (!list_empty(page_list)) {
> -               unsigned int i, nr_pages, bytes;
> +               unsigned int i, nr_pages, bytes, rsize;
>                 loff_t offset;
>                 struct page *page, *tpage;
>                 struct cifs_readdata *rdata;
> +               unsigned credits;
> +
> +               rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
> +                                                  &rsize, &credits);
> +               if (rc)
> +                       break;
>
>                 /*
>                  * Give up immediately if rsize is too small to read an entire
> @@ -3469,13 +3483,17 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                  * reach this point however since we set ra_pages to 0 when the
>                  * rsize is smaller than a cache page.
>                  */
> -               if (unlikely(cifs_sb->rsize < PAGE_CACHE_SIZE))
> +               if (unlikely(rsize < PAGE_CACHE_SIZE)) {
> +                       add_credits_and_wake_if(server, credits, 0);
>                         return 0;
> +               }
>
> -               rc = readpages_get_pages(mapping, page_list, cifs_sb->rsize,
> -                                        &tmplist, &nr_pages, &offset, &bytes);
> -               if (rc)
> +               rc = readpages_get_pages(mapping, page_list, rsize, &tmplist,
> +                                        &nr_pages, &offset, &bytes);
> +               if (rc) {
> +                       add_credits_and_wake_if(server, credits, 0);
>                         break;
> +               }
>
>                 rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
>                 if (!rdata) {
> @@ -3487,6 +3505,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                                 page_cache_release(page);
>                         }
>                         rc = -ENOMEM;
> +                       add_credits_and_wake_if(server, credits, 0);
>                         break;
>                 }
>
> @@ -3497,6 +3516,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                 rdata->pid = pid;
>                 rdata->pagesz = PAGE_CACHE_SIZE;
>                 rdata->read_into_pages = cifs_readpages_read_into_pages;
> +               rdata->credits = credits;
>
>                 list_for_each_entry_safe(page, tpage, &tmplist, lru) {
>                         list_del(&page->lru);
> @@ -3507,6 +3527,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                     !cifs_reopen_file(rdata->cfile, true))
>                         rc = server->ops->async_readv(rdata);
>                 if (rc) {
> +                       add_credits_and_wake_if(server, rdata->credits, 0);
>                         for (i = 0; i < rdata->nr_pages; i++) {
>                                 page = rdata->pages[i];
>                                 lru_cache_add_file(page);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index fecc2de..081529f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -242,8 +242,6 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>         /* start with specified rsize, or default */
>         rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
>         rsize = min_t(unsigned int, rsize, server->max_read);
> -       /* set it to the maximum buffer size value we can send with 1 credit */
> -       rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
>
>         return rsize;
>  }
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index a1d89b7..26624ee 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1758,11 +1758,12 @@ smb2_readv_callback(struct mid_q_entry *mid)
>  int
>  smb2_async_readv(struct cifs_readdata *rdata)
>  {
> -       int rc;
> +       int rc, flags = 0;
>         struct smb2_hdr *buf;
>         struct cifs_io_parms io_parms;
>         struct smb_rqst rqst = { .rq_iov = &rdata->iov,
>                                  .rq_nvec = 1 };
> +       struct TCP_Server_Info *server;
>
>         cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
>                  __func__, rdata->offset, rdata->bytes);
> @@ -1773,18 +1774,41 @@ smb2_async_readv(struct cifs_readdata *rdata)
>         io_parms.persistent_fid = rdata->cfile->fid.persistent_fid;
>         io_parms.volatile_fid = rdata->cfile->fid.volatile_fid;
>         io_parms.pid = rdata->pid;
> +
> +       server = io_parms.tcon->ses->server;
> +
>         rc = smb2_new_read_req(&rdata->iov, &io_parms, 0, 0);
> -       if (rc)
> +       if (rc) {
> +               if (rc == -EAGAIN && rdata->credits) {
> +                       /* credits was reseted by reconnect */
> +                       rdata->credits = 0;
> +                       /* reduce in_flight value since we won't send the req */
> +                       spin_lock(&server->req_lock);
> +                       server->in_flight--;
> +                       spin_unlock(&server->req_lock);
> +               }
>                 return rc;
> +       }
>
>         buf = (struct smb2_hdr *)rdata->iov.iov_base;
>         /* 4 for rfc1002 length field */
>         rdata->iov.iov_len = get_rfc1002_length(rdata->iov.iov_base) + 4;
>
> +       if (rdata->credits) {
> +               buf->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
> +                                               SMB2_MAX_BUFFER_SIZE));
> +               spin_lock(&server->req_lock);
> +               server->credits += rdata->credits -
> +                                               le16_to_cpu(buf->CreditCharge);
> +               spin_unlock(&server->req_lock);
> +               wake_up(&server->request_q);
> +               flags = CIFS_HAS_CREDITS;
> +       }
> +
>         kref_get(&rdata->refcount);
>         rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
>                              cifs_readv_receive, smb2_readv_callback,
> -                            rdata, 0);
> +                            rdata, flags);
>         if (rc) {
>                 kref_put(&rdata->refcount, cifs_readdata_release);
>                 cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
