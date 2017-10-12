From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: initialize rsp_iov and check for NULL in SMB2_read
Date: Thu, 12 Oct 2017 11:11:14 -0700
Message-ID: <CAKywueTNw1uvSXTjFU=rw3zTPV2U+S16-s_ZmnDAA6Y4MnXq+Q@mail.gmail.com>
References: <20171011233840.10365-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011233840.10365-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-10-11 16:38 GMT-07:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6ff4c275ca9a..e6b62771a48e 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2639,10 +2639,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>  {
>         int resp_buftype, rc = -EACCES;
>         struct smb2_read_plain_req *req = NULL;
> -       struct smb2_read_rsp *rsp = NULL;
> +       struct smb2_read_rsp *rsp;
>         struct smb2_sync_hdr *shdr;
>         struct kvec iov[2];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov =  {NULL, 0};
>         unsigned int total_len;
>         __be32 req_len;
>         struct smb_rqst rqst = { .rq_iov = iov,
> @@ -2669,11 +2669,9 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>         cifs_small_buf_release(req);
>
>         rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
> -       shdr = get_sync_hdr(rsp);
> -
> -       if (shdr->Status == STATUS_END_OF_FILE) {
> -               free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> -               return 0;
> +       if (rsp == NULL) {
> +               cifs_dbg(VFS, "rsp is NULL in read\n");
> +               return -EIO;
>         }

Given that -EAGAIN might be returned in a case we couldn't send the
request (and there is no response) we will return a wrong error code.
If rsp is NULL here, I would suggest to simply return rc: no response
- nothing we can do about it. Also don't think we should print any
message in this case.

Or we can modify the code to something like this and eliminate check
for STATUS_END_OF_FILE below.

if (rc) {
    if (rc != -ENODATA) {
        cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
        cifs_dbg(VFS, "Send error in read = %d\n", rc);
    }
    free_rsp_buf(resp_buftype, rsp);
    return rc == -ENODATA ? 0: rc;
}

>
>         if (rc) {
> @@ -2690,6 +2688,13 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>                 }
>         }
>
> +       shdr = get_sync_hdr(rsp);
> +
> +       if (shdr->Status == STATUS_END_OF_FILE) {
> +               free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> +               return 0;
> +       }
> +

We already have checked rc and have already executed the block

if (rc) {
    cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
    cifs_dbg(VFS, "Send error in read = %d\n", rc);
}

so, returning 0 after the error message above seems misleading.

We can eliminate this check with the approach described previously or
if we end up with checking rsp pointer for NULL this code should go
right after that check.

>         if (*buf) {
>                 memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
>                 free_rsp_buf(resp_buftype, rsp_iov.iov_base);
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Best regards,
Pavel Shilovsky
