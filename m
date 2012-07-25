From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/11] cifs: change signing routines to deal with smb_rqst structs
Date: Wed, 25 Jul 2012 16:04:40 +0400
Message-ID: <CAKywueSeTmq6GH-8ifs86OXXKTMQK46_QQZh012DbNhCa7CjJQ@mail.gmail.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
	<1342634346-22818-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We need a way to represent a call to be sent on the wire that does not
> require having all of the page data kmapped. Behold the smb_rqst struct.
> This new struct represents an array of kvecs immediately followed by an
> array of pages.
>
> Convert the signing routines to use these structs under the hood and
> turn the existing functions for this into wrappers around that. For now,
> we're just changing these functions to take different args. Later, we'll
> teach them how to deal with arrays of pages.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   26 ++++++++++++++++++--------
>  fs/cifs/cifsproto.h   |   20 ++++++++++++++++++--
>  fs/cifs/cifssmb.c     |    6 ++++--
>  fs/cifs/transport.c   |    4 +++-
>  4 files changed, 43 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 6a0d741..e8953a0 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -37,11 +37,13 @@
>   * the sequence number before this function is called. Also, this function
>   * should be called with the server->srv_mutex held.
>   */
> -static int cifs_calc_signature(const struct kvec *iov, int n_vec,
> +static int cifs_calc_signature(struct smb_rqst *rqst,
>                         struct TCP_Server_Info *server, char *signature)
>  {
>         int i;
>         int rc;
> +       struct kvec *iov = rqst->rq_iov;
> +       int n_vec = rqst->rq_nvec;
>
>         if (iov == NULL || signature == NULL || server == NULL)
>                 return -EINVAL;
> @@ -99,12 +101,12 @@ static int cifs_calc_signature(const struct kvec *iov, int n_vec,
>  }
>
>  /* must be called with server->srv_mutex held */
> -int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
> +int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
>                    __u32 *pexpected_response_sequence_number)
>  {
>         int rc = 0;
>         char smb_signature[20];
> -       struct smb_hdr *cifs_pdu = (struct smb_hdr *)iov[0].iov_base;
> +       struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
>
>         if ((cifs_pdu == NULL) || (server == NULL))
>                 return -EINVAL;
> @@ -125,7 +127,7 @@ int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
>         *pexpected_response_sequence_number = server->sequence_number++;
>         server->sequence_number++;
>
> -       rc = cifs_calc_signature(iov, n_vec, server, smb_signature);
> +       rc = cifs_calc_signature(rqst, server, smb_signature);
>         if (rc)
>                 memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
>         else
> @@ -134,6 +136,15 @@ int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
>         return rc;
>  }
>
> +int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
> +                  __u32 *pexpected_response_sequence)
> +{
> +       struct smb_rqst rqst = { .rq_iov = iov,
> +                                .rq_nvec = n_vec };
> +
> +       return cifs_sign_rqst(&rqst, server, pexpected_response_sequence);
> +}
> +
>  /* must be called with server->srv_mutex held */
>  int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
>                   __u32 *pexpected_response_sequence_number)
> @@ -147,14 +158,14 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
>                               pexpected_response_sequence_number);
>  }
>
> -int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
> +int cifs_verify_signature(struct smb_rqst *rqst,
>                           struct TCP_Server_Info *server,
>                           __u32 expected_sequence_number)
>  {
>         unsigned int rc;
>         char server_response_sig[8];
>         char what_we_think_sig_should_be[20];
> -       struct smb_hdr *cifs_pdu = (struct smb_hdr *)iov[0].iov_base;
> +       struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
>
>         if (cifs_pdu == NULL || server == NULL)
>                 return -EINVAL;
> @@ -186,8 +197,7 @@ int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
>         cifs_pdu->Signature.Sequence.Reserved = 0;
>
>         mutex_lock(&server->srv_mutex);
> -       rc = cifs_calc_signature(iov, nr_iov, server,
> -                                what_we_think_sig_should_be);
> +       rc = cifs_calc_signature(rqst, server, what_we_think_sig_should_be);
>         mutex_unlock(&server->srv_mutex);
>
>         if (rc)
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index b09aa22..b59e066 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -397,10 +397,26 @@ extern void sesInfoFree(struct cifs_ses *);
>  extern struct cifs_tcon *tconInfoAlloc(void);
>  extern void tconInfoFree(struct cifs_tcon *);
>
> -extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
> +/*
> + * A smb_rqst represents a complete request to be issued to a server. It's
> + * formed by a kvec array, followed by an array of pages. Page data is assumed
> + * to start at the beginning of the first page.
> + */
> +struct smb_rqst {
> +       struct kvec     *rq_iov;        /* array of kvecs */
> +       unsigned int    rq_nvec;        /* number of kvecs in array */
> +       struct page     **rq_pages;     /* pointer to array of page ptrs */
> +       unsigned int    rq_npages;      /* number pages in array */
> +       unsigned int    rq_pagesz;      /* page size to use */
> +       unsigned int    rq_tailsz;      /* length of last page */
> +};

Why you are adding new struct into cifsproto.h file? It seems like
cifsproto.h has only function prototypes but all structs are in
cifsglob.h. I suggest to add new structs into cifsglob.h.

> +
> +extern int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
> +                  __u32 *pexpected_response_sequence_number);
>  extern int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
>                           __u32 *);
> -extern int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
> +extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
> +extern int cifs_verify_signature(struct smb_rqst *rqst,
>                                  struct TCP_Server_Info *server,
>                                 __u32 expected_sequence_number);
>  extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 1a05ab0..c010c279 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1562,6 +1562,8 @@ cifs_readv_callback(struct mid_q_entry *mid)
>         struct cifs_readdata *rdata = mid->callback_data;
>         struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
>         struct TCP_Server_Info *server = tcon->ses->server;
> +       struct smb_rqst rqst = { .rq_iov = rdata->iov,
> +                                .rq_nvec = rdata->nr_iov };
>
>         cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
>                 mid->mid, mid->mid_state, rdata->result, rdata->bytes);
> @@ -1571,8 +1573,8 @@ cifs_readv_callback(struct mid_q_entry *mid)
>                 /* result already set, check signature */
>                 if (server->sec_mode &
>                     (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
> -                       if (cifs_verify_signature(rdata->iov, rdata->nr_iov,
> -                                         server, mid->sequence_number + 1))
> +                       if (cifs_verify_signature(&rqst, server,
> +                                                 mid->sequence_number + 1))
>                                 cERROR(1, "Unexpected SMB signature");
>                 }
>                 /* FIXME: should this be counted toward the initiating task? */
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 462130d..531da42 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -498,11 +498,13 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>         /* convert the length into a more usable form */
>         if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
>                 struct kvec iov;
> +               struct smb_rqst rqst = { .rq_iov = &iov,
> +                                        .rq_nvec = 1 };
>
>                 iov.iov_base = mid->resp_buf;
>                 iov.iov_len = len;
>                 /* FIXME: add code to kill session */
> -               if (cifs_verify_signature(&iov, 1, server,
> +               if (cifs_verify_signature(&rqst, server,
>                                           mid->sequence_number + 1) != 0)
>                         cERROR(1, "Unexpected SMB signature");
>         }
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Other than the comment above it seems good.

-- 
Best regards,
Pavel Shilovsky.
