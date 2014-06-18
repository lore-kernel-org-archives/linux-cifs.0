From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs: replace code with free_rsp_buf()
Date: Tue, 17 Jun 2014 23:33:42 -0500
Message-ID: <CADT32eJ40ZDx+jCW1LF=Y2pPVNsJacRwgtLYQ6wi_W-5MmsLiw@mail.gmail.com>
References: <1402929328-12866-1-git-send-email-sprabhu@redhat.com>
	<1402929328-12866-2-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402929328-12866-2-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jun 16, 2014 at 9:35 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The functionality provided by free_rsp_buf() is duplicated in a number
> of places. Replace these instances with a call to free_rsp_buf().
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |  1 +
>  fs/cifs/cifssmb.c   | 20 ++++----------------
>  fs/cifs/misc.c      |  9 +++++++++
>  fs/cifs/smb2pdu.c   | 10 ----------
>  4 files changed, 14 insertions(+), 26 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index ca7980a..de49d7a 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -36,6 +36,7 @@ extern struct smb_hdr *cifs_buf_get(void);
>  extern void cifs_buf_release(void *);
>  extern struct smb_hdr *cifs_small_buf_get(void);
>  extern void cifs_small_buf_release(void *);
> +extern void free_rsp_buf(int, void *);
>  extern void cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned int idx,
>                                         struct kvec *iov);
>  extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 6ce4e09..b7e5b65 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1734,10 +1734,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
>
>  /*     cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
>         if (*buf) {
> -               if (resp_buf_type == CIFS_SMALL_BUFFER)
> -                       cifs_small_buf_release(iov[0].iov_base);
> -               else if (resp_buf_type == CIFS_LARGE_BUFFER)
> -                       cifs_buf_release(iov[0].iov_base);
> +               free_rsp_buf(resp_buf_type, iov[0].iov_base);
>         } else if (resp_buf_type != CIFS_NO_BUFFER) {
>                 /* return buffer to caller to free */
>                 *buf = iov[0].iov_base;
> @@ -2203,10 +2200,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
>         }
>
>  /*     cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
> -       if (resp_buf_type == CIFS_SMALL_BUFFER)
> -               cifs_small_buf_release(iov[0].iov_base);
> -       else if (resp_buf_type == CIFS_LARGE_BUFFER)
> -               cifs_buf_release(iov[0].iov_base);
> +       free_rsp_buf(resp_buf_type, iov[0].iov_base);
>
>         /* Note: On -EAGAIN error only caller can retry on handle based calls
>                 since file handle passed in no longer valid */
> @@ -2451,10 +2445,7 @@ plk_err_exit:
>         if (pSMB)
>                 cifs_small_buf_release(pSMB);
>
> -       if (resp_buf_type == CIFS_SMALL_BUFFER)
> -               cifs_small_buf_release(iov[0].iov_base);
> -       else if (resp_buf_type == CIFS_LARGE_BUFFER)
> -               cifs_buf_release(iov[0].iov_base);
> +       free_rsp_buf(resp_buf_type, iov[0].iov_base);
>
>         /* Note: On -EAGAIN error only caller can retry on handle based calls
>            since file handle passed in no longer valid */
> @@ -3838,10 +3829,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
>                 }
>         }
>  qsec_out:
> -       if (buf_type == CIFS_SMALL_BUFFER)
> -               cifs_small_buf_release(iov[0].iov_base);
> -       else if (buf_type == CIFS_LARGE_BUFFER)
> -               cifs_buf_release(iov[0].iov_base);
> +       free_rsp_buf(buf_type, iov[0].iov_base);
>  /*     cifs_small_buf_release(pSMB); */ /* Freed earlier now in SendReceive2 */
>         return rc;
>  }
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 3b0c62e..64997a0 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -226,6 +226,15 @@ cifs_small_buf_release(void *buf_to_free)
>         return;
>  }
>
> +void
> +free_rsp_buf(int resp_buftype, void *rsp)
> +{
> +       if (resp_buftype == CIFS_SMALL_BUFFER)
> +               cifs_small_buf_release(rsp);
> +       else if (resp_buftype == CIFS_LARGE_BUFFER)
> +               cifs_buf_release(rsp);
> +}
> +
>  /* NB: MID can not be set if treeCon not passed in, in that
>     case it is responsbility of caller to set the mid */
>  void
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index b0b260d..0158104 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -309,16 +309,6 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> -static void
> -free_rsp_buf(int resp_buftype, void *rsp)
> -{
> -       if (resp_buftype == CIFS_SMALL_BUFFER)
> -               cifs_small_buf_release(rsp);
> -       else if (resp_buftype == CIFS_LARGE_BUFFER)
> -               cifs_buf_release(rsp);
> -}
> -
> -
>  /*
>   *
>   *     SMB2 Worker functions follow:
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
