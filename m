From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 06/16] CIFS: Fix cifs_writev_requeue when wsize changes
Date: Sun, 20 Jul 2014 14:49:29 -0500
Message-ID: <CADT32e+kGf-b989EFr4c_-e9+_MCVMkDShkh_30an8YKLiD6Zw@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-7-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-7-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

why bother setting rc (to ENOTSUPP, ENOMEM) if those errors are not returned
once we break out of do while loop?
Instead perhaps log an error message?

On Fri, Jun 27, 2014 at 4:57 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If wsize changes on reconnect we need to use new writedata structure
> that for retrying.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/cifssmb.c  | 84 +++++++++++++++++++++++++++++++++++++++++++-----------
>  fs/cifs/smb1ops.c  |  7 +++++
>  fs/cifs/smb2ops.c  | 10 +++++++
>  4 files changed, 87 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index de6aed8..8c53f20 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -404,6 +404,8 @@ struct smb_version_operations {
>                         const struct cifs_fid *, u32 *);
>         int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
>                         int);
> +       /* writepages retry size */
> +       unsigned int (*wp_retry_size)(struct inode *);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index b7e5b65..41c9067 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1899,27 +1899,79 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
>         int i, rc;
>         struct inode *inode = wdata->cfile->dentry->d_inode;
>         struct TCP_Server_Info *server;
> +       unsigned int rest_len;
>
> -       for (i = 0; i < wdata->nr_pages; i++) {
> -               lock_page(wdata->pages[i]);
> -               clear_page_dirty_for_io(wdata->pages[i]);
> -       }
> -
> +       server = tlink_tcon(wdata->cfile->tlink)->ses->server;
> +       i = 0;
> +       rest_len = wdata->bytes;
>         do {
> -               server = tlink_tcon(wdata->cfile->tlink)->ses->server;
> -               rc = server->ops->async_writev(wdata, cifs_writedata_release);
> -       } while (rc == -EAGAIN);
> +               struct cifs_writedata *wdata2;
> +               unsigned int j, nr_pages, wsize, tailsz, cur_len;
> +
> +               wsize = server->ops->wp_retry_size(inode);
> +               if (wsize < rest_len) {
> +                       nr_pages = wsize / PAGE_CACHE_SIZE;
> +                       if (!nr_pages) {
> +                               rc = -ENOTSUPP;
> +                               break;
> +                       }
> +                       cur_len = nr_pages * PAGE_CACHE_SIZE;
> +                       tailsz = PAGE_CACHE_SIZE;
> +               } else {
> +                       nr_pages = DIV_ROUND_UP(rest_len, PAGE_CACHE_SIZE);
> +                       cur_len = rest_len;
> +                       tailsz = rest_len - (nr_pages - 1) * PAGE_CACHE_SIZE;
> +               }
>
> -       for (i = 0; i < wdata->nr_pages; i++) {
> -               unlock_page(wdata->pages[i]);
> -               if (rc != 0) {
> -                       SetPageError(wdata->pages[i]);
> -                       end_page_writeback(wdata->pages[i]);
> -                       page_cache_release(wdata->pages[i]);
> +               wdata2 = cifs_writedata_alloc(nr_pages, cifs_writev_complete);
> +               if (!wdata2) {
> +                       rc = -ENOMEM;
> +                       break;
>                 }
> -       }
>
> -       mapping_set_error(inode->i_mapping, rc);
> +               for (j = 0; j < nr_pages; j++) {
> +                       wdata2->pages[j] = wdata->pages[i + j];
> +                       lock_page(wdata2->pages[j]);
> +                       clear_page_dirty_for_io(wdata2->pages[j]);
> +               }
> +
> +               wdata2->sync_mode = wdata->sync_mode;
> +               wdata2->nr_pages = nr_pages;
> +               wdata2->offset = page_offset(wdata2->pages[0]);
> +               wdata2->pagesz = PAGE_CACHE_SIZE;
> +               wdata2->tailsz = tailsz;
> +               wdata2->bytes = cur_len;
> +
> +               wdata2->cfile = find_writable_file(CIFS_I(inode), false);
> +               if (!wdata2->cfile) {
> +                       cifs_dbg(VFS, "No writable handles for inode\n");
> +                       rc = -EBADF;
> +                       break;
> +               }
> +               wdata2->pid = wdata2->cfile->pid;
> +               rc = server->ops->async_writev(wdata2, cifs_writedata_release);
> +
> +               for (j = 0; j < nr_pages; j++) {
> +                       unlock_page(wdata2->pages[j]);
> +                       if (rc != 0 && rc != -EAGAIN) {
> +                               SetPageError(wdata2->pages[j]);
> +                               end_page_writeback(wdata2->pages[j]);
> +                               page_cache_release(wdata2->pages[j]);
> +                       }
> +               }
> +
> +               if (rc) {
> +                       kref_put(&wdata2->refcount, cifs_writedata_release);
> +                       if (rc == -EAGAIN)
> +                               continue;
> +                       mapping_set_error(inode->i_mapping, rc);
> +                       break;
> +               }
> +
> +               rest_len -= cur_len;
> +               i += nr_pages;
> +       } while (i < wdata->nr_pages);
> +
>         kref_put(&wdata->refcount, cifs_writedata_release);
>  }
>
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index d1fdfa8..8a96342 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -1009,6 +1009,12 @@ cifs_is_read_op(__u32 oplock)
>         return oplock == OPLOCK_READ;
>  }
>
> +static unsigned int
> +cifs_wp_retry_size(struct inode *inode)
> +{
> +       return CIFS_SB(inode->i_sb)->wsize;
> +}
> +
>  struct smb_version_operations smb1_operations = {
>         .send_cancel = send_nt_cancel,
>         .compare_fids = cifs_compare_fids,
> @@ -1078,6 +1084,7 @@ struct smb_version_operations smb1_operations = {
>         .query_mf_symlink = cifs_query_mf_symlink,
>         .create_mf_symlink = cifs_create_mf_symlink,
>         .is_read_op = cifs_is_read_op,
> +       .wp_retry_size = cifs_wp_retry_size,
>  #ifdef CONFIG_CIFS_XATTR
>         .query_all_EAs = CIFSSMBQAllEAs,
>         .set_EA = CIFSSMBSetEA,
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 787844b..e35ce5b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1104,6 +1104,13 @@ smb3_parse_lease_buf(void *buf, unsigned int *epoch)
>         return le32_to_cpu(lc->lcontext.LeaseState);
>  }
>
> +static unsigned int
> +smb2_wp_retry_size(struct inode *inode)
> +{
> +       return min_t(unsigned int, CIFS_SB(inode->i_sb)->wsize,
> +                    SMB2_MAX_BUFFER_SIZE);
> +}
> +
>  struct smb_version_operations smb20_operations = {
>         .compare_fids = smb2_compare_fids,
>         .setup_request = smb2_setup_request,
> @@ -1177,6 +1184,7 @@ struct smb_version_operations smb20_operations = {
>         .create_lease_buf = smb2_create_lease_buf,
>         .parse_lease_buf = smb2_parse_lease_buf,
>         .clone_range = smb2_clone_range,
> +       .wp_retry_size = smb2_wp_retry_size,
>  };
>
>  struct smb_version_operations smb21_operations = {
> @@ -1252,6 +1260,7 @@ struct smb_version_operations smb21_operations = {
>         .create_lease_buf = smb2_create_lease_buf,
>         .parse_lease_buf = smb2_parse_lease_buf,
>         .clone_range = smb2_clone_range,
> +       .wp_retry_size = smb2_wp_retry_size,
>  };
>
>  struct smb_version_operations smb30_operations = {
> @@ -1330,6 +1339,7 @@ struct smb_version_operations smb30_operations = {
>         .parse_lease_buf = smb3_parse_lease_buf,
>         .clone_range = smb2_clone_range,
>         .validate_negotiate = smb3_validate_negotiate,
> +       .wp_retry_size = smb2_wp_retry_size,
>  };
>
>  struct smb_version_values smb20_values = {
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
