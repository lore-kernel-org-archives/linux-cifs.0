From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix remaining rsp_iov issues
Date: Wed, 11 Oct 2017 11:33:06 -0700
Message-ID: <CAKywueSTNHYLKfyv1eJxvpp0XkTq=TE+v=ifh8AG3M+7CS6ZFQ@mail.gmail.com>
References: <20171011054140.26535-1-lsahlber@redhat.com> <20171011054140.26535-2-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011054140.26535-2-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-10-10 22:41 GMT-07:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This patch fixes the remaining issues with rsp_iov where
> we might dereference uninitialized pointers or pass them
> to free_rsp_buf().
> There is also one memory leak that is fixed.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 43 +++++++++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 18 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6ff4c275ca9a..fd2b2b8e86b0 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -470,7 +470,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>         struct smb2_negotiate_req *req;
>         struct smb2_negotiate_rsp *rsp;
>         struct kvec iov[1];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int resp_buftype;
>         struct TCP_Server_Info *server = ses->server;
> @@ -1884,7 +1884,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         struct smb2_sync_hdr *shdr;
>         struct cifs_ses *ses;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int resp_buftype;
>         int n_iov;
>         int rc = 0;
> @@ -1981,6 +1981,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
>         cifs_small_buf_release(req);
>         rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
> +       if (rsp == NULL)
> +               goto ioctl_exit;

Why do we need this? rsp pointer will be NULL if rc != 0 which is
covered by the code below. Note that resp_buftype will be set to
NO_BUFFER, so NULL/garbage pointer de-referencing shouldn't happen.

>
>         if ((rc != 0) && (rc != -EINVAL)) {
>                 cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> @@ -2064,7 +2066,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>         struct smb2_close_rsp *rsp;
>         struct cifs_ses *ses = tcon->ses;
>         struct kvec iov[1];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int resp_buftype;
>         int rc = 0;
>         int flags = 0;
> @@ -2168,9 +2170,9 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 u32 *dlen)
>  {
>         struct smb2_query_info_req *req;
> -       struct smb2_query_info_rsp *rsp = NULL;
> +       struct smb2_query_info_rsp *rsp;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int resp_buftype;
>         struct cifs_ses *ses = tcon->ses;
> @@ -2404,7 +2406,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         struct smb2_flush_req *req;
>         struct cifs_ses *ses = tcon->ses;
>         struct kvec iov[1];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int resp_buftype;
>         int rc = 0;
>         int flags = 0;
> @@ -2639,10 +2641,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>  {
>         int resp_buftype, rc = -EACCES;
>         struct smb2_read_plain_req *req = NULL;
> -       struct smb2_read_rsp *rsp = NULL;
> +       struct smb2_read_rsp *rsp;
>         struct smb2_sync_hdr *shdr;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         unsigned int total_len;
>         __be32 req_len;
>         struct smb_rqst rqst = { .rq_iov = iov,
> @@ -2669,6 +2671,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>         cifs_small_buf_release(req);
>
>         rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
> +       if (rsp == NULL) {
> +               cifs_dbg(VFS, "rsp is NULL in read\n");
> +               return -EIO;
> +       }
>         shdr = get_sync_hdr(rsp);

This is another long-term bug, thanks. We should probably refactor the
code a little bit here and move rc != 0 check before calling
get_sync_hdr().

>
>         if (shdr->Status == STATUS_END_OF_FILE) {
> @@ -2856,9 +2862,9 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>  {
>         int rc = 0;
>         struct smb2_write_req *req = NULL;
> -       struct smb2_write_rsp *rsp = NULL;
> +       struct smb2_write_rsp *rsp;
>         int resp_buftype;
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int flags = 0;
>
>         *nbytes = 0;
> @@ -2963,7 +2969,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
>         struct smb2_query_directory_req *req;
>         struct smb2_query_directory_rsp *rsp = NULL;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int len;
>         int resp_buftype = CIFS_NO_BUFFER;
> @@ -3093,9 +3099,9 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 void **data, unsigned int *size)
>  {
>         struct smb2_set_info_req *req;
> -       struct smb2_set_info_rsp *rsp = NULL;
> +       struct smb2_set_info_rsp *rsp;
>         struct kvec *iov;
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int resp_buftype;
>         unsigned int i;
> @@ -3376,9 +3382,9 @@ int
>  SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
>               u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
>  {
> -       struct smb2_query_info_rsp *rsp = NULL;
> +       struct smb2_query_info_rsp *rsp;
>         struct kvec iov;
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int resp_buftype;
>         struct cifs_ses *ses = tcon->ses;
> @@ -3419,9 +3425,9 @@ int
>  SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
>               u64 persistent_fid, u64 volatile_fid, int level)
>  {
> -       struct smb2_query_info_rsp *rsp = NULL;
> +       struct smb2_query_info_rsp *rsp;
>         struct kvec iov;
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int rc = 0;
>         int resp_buftype, max_len, min_len;
>         struct cifs_ses *ses = tcon->ses;
> @@ -3492,7 +3498,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
>         int rc = 0;
>         struct smb2_lock_req *req = NULL;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov = { NULL, 0 };
>         int resp_buf_type;
>         unsigned int count;
>         int flags = CIFS_NO_RESP;
> @@ -3525,6 +3531,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
>         rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, flags,
>                           &rsp_iov);
>         cifs_small_buf_release(req);
> +       free_rsp_buf(resp_buf_type, rsp_iov.iov_base);

flags == CIFS_NO_RESP above, so, no memory leak should happen and do
not need to call free_rsp_buf().

>         if (rc) {
>                 cifs_dbg(FYI, "Send error in smb2_lockv = %d\n", rc);
>                 cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

That's being said I think we need to merge "[PATCH 06/12] cifs:
initialize rsp_iov in SMB2_read and add check for NULL" with a stable
tag because it fixes the real bug.

I am not apposite of initializing struct kvec rsp_iov to { NULL, 0 }
but it doesn't seem suitable to stable kernels because like in
SMB2_ioctl() example we do not cause problems calling
free_rsp_buf(resp_buftype, rsp) with resp_buftype == CIFS_NO_BUFFER.

--
Best regards,
Pavel Shilovsky
