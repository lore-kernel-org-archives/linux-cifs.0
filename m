From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/11] cifs: change cifs_call_async to use smb_rqst structs
Date: Wed, 25 Jul 2012 16:30:47 +0400
Message-ID: <CAKywueQdKF8+RDW8tZ-fLXdkA1jE8qNrAPnwMx7gLxdiT3ekWA@mail.gmail.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
	<1342634346-22818-9-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-9-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> For now, none of the callers populate rq_pages. That will be done for
> writes in a later patch.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |    8 ++++----
>  fs/cifs/cifssmb.c   |   20 +++++++++++++-------
>  fs/cifs/transport.c |   18 +++++++++---------
>  3 files changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index b2daad4..dbb9c61 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -71,10 +71,10 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
>  extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
>                                         struct TCP_Server_Info *server);
>  extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
> -extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
> -                          unsigned int nvec, mid_receive_t *receive,
> -                          mid_callback_t *callback, void *cbdata,
> -                          bool ignore_pend);
> +extern int cifs_call_async(struct TCP_Server_Info *server,
> +                       struct smb_rqst *rqst, mid_receive_t *receive,
> +                       mid_callback_t *callback, void *cbdata,
> +                       bool ignore_pend);

This will cause merge conflicts with current Steve's for-next branch -
needs a respin.

>  extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
>                         struct smb_hdr * /* input */ ,
>                         struct smb_hdr * /* out */ ,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c010c279..727f35e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -753,6 +753,8 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
>         ECHO_REQ *smb;
>         int rc = 0;
>         struct kvec iov;
> +       struct smb_rqst rqst = { .rq_iov = &iov,
> +                                .rq_nvec = 1 };
>
>         cFYI(1, "In echo request");
>
> @@ -770,7 +772,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
>         iov.iov_base = smb;
>         iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
>
> -       rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
> +       rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback,
>                              server, true);
>         if (rc)
>                 cFYI(1, "Echo request failed: %d", rc);
> @@ -1602,6 +1604,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
>         READ_REQ *smb = NULL;
>         int wct;
>         struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
> +       struct smb_rqst rqst = { .rq_iov = rdata->iov,
> +                                .rq_nvec = 1 };
>
>         cFYI(1, "%s: offset=%llu bytes=%u", __func__,
>                 rdata->offset, rdata->bytes);
> @@ -1645,9 +1649,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
>         rdata->iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
>
>         kref_get(&rdata->refcount);
> -       rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
> -                            cifs_readv_receive, cifs_readv_callback,
> -                            rdata, false);
> +       rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
> +                            cifs_readv_callback, rdata, false);
>
>         if (rc == 0)
>                 cifs_stats_inc(&tcon->num_reads);
> @@ -2050,6 +2053,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
>         int wct;
>         struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
>         struct kvec *iov = NULL;
> +       struct smb_rqst rqst = { };
>
>         if (tcon->ses->capabilities & CAP_LARGE_FILES) {
>                 wct = 14;
> @@ -2066,11 +2070,13 @@ cifs_async_writev(struct cifs_writedata *wdata)
>                 goto async_writev_out;
>
>         /* 1 iov per page + 1 for header */
> -       iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
> +       rqst.rq_nvec = wdata->nr_pages + 1;
> +       iov = kzalloc((rqst.rq_nvec) * sizeof(*iov), GFP_NOFS);
>         if (iov == NULL) {
>                 rc = -ENOMEM;
>                 goto async_writev_out;
>         }
> +       rqst.rq_iov = iov;
>
>         smb->hdr.Pid = cpu_to_le16((__u16)wdata->pid);
>         smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->pid >> 16));
> @@ -2119,8 +2125,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
>         }
>
>         kref_get(&wdata->refcount);
> -       rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
> -                            NULL, cifs_writev_callback, wdata, false);
> +       rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
> +                               cifs_writev_callback, wdata, false);
>
>         if (rc == 0)
>                 cifs_stats_inc(&tcon->num_writes);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 8e689d1..83a1489 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -455,11 +455,11 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
>  }
>
>  static int
> -cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
> -                        unsigned int nvec, struct mid_q_entry **ret_mid)
> +cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst,
> +                        struct mid_q_entry **ret_mid)
>  {
>         int rc;
> -       struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
> +       struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
>         struct mid_q_entry *mid;
>
>         /* enable signing if server requires it */
> @@ -475,7 +475,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
>         list_add_tail(&mid->qhead, &server->pending_mid_q);
>         spin_unlock(&GlobalMid_Lock);
>
> -       rc = cifs_sign_smbv(iov, nvec, server, &mid->sequence_number);
> +       rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
>         if (rc)
>                 delete_mid(mid);
>         *ret_mid = mid;
> @@ -487,9 +487,9 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
>   * the result. Caller is responsible for dealing with timeouts.
>   */
>  int
> -cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
> -               unsigned int nvec, mid_receive_t *receive,
> -               mid_callback_t *callback, void *cbdata, bool ignore_pend)
> +cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
> +               mid_receive_t *receive, mid_callback_t *callback,
> +               void *cbdata, bool ignore_pend)
>  {
>         int rc;
>         struct mid_q_entry *mid;
> @@ -499,7 +499,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
>                 return rc;
>
>         mutex_lock(&server->srv_mutex);
> -       rc = cifs_setup_async_request(server, iov, nvec, &mid);
> +       rc = cifs_setup_async_request(server, rqst, &mid);
>         if (rc) {
>                 mutex_unlock(&server->srv_mutex);
>                 add_credits(server, 1);
> @@ -513,7 +513,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
>         mid->mid_state = MID_REQUEST_SUBMITTED;
>
>         cifs_in_send_inc(server);
> -       rc = smb_sendv(server, iov, nvec);
> +       rc = smb_send_rqst(server, rqst);
>         cifs_in_send_dec(server);
>         cifs_save_when_sent(mid);
>         mutex_unlock(&server->srv_mutex);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
