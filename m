From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/11] cifs: rename cifs_sign_smb2 to cifs_sign_smbv
Date: Wed, 25 Jul 2012 16:34:51 +0400
Message-ID: <CAKywueQkEQ05=VJp-PJKf5jtUdPpSV3dq8Uvmz1zKfZO5M90bg@mail.gmail.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
	<1342634346-22818-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> "smb2" makes me think of the SMB2.x protocol, which isn't at all what
> this function is for...
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |    4 ++--
>  fs/cifs/cifsproto.h   |    2 +-
>  fs/cifs/transport.c   |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index db768cb..6a0d741 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -99,7 +99,7 @@ static int cifs_calc_signature(const struct kvec *iov, int n_vec,
>  }
>
>  /* must be called with server->srv_mutex held */
> -int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
> +int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
>                    __u32 *pexpected_response_sequence_number)
>  {
>         int rc = 0;
> @@ -143,7 +143,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
>         iov.iov_base = cifs_pdu;
>         iov.iov_len = be32_to_cpu(cifs_pdu->smb_buf_length) + 4;
>
> -       return cifs_sign_smb2(&iov, 1, server,
> +       return cifs_sign_smbv(&iov, 1, server,
>                               pexpected_response_sequence_number);
>  }
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 0a6cbfe..b09aa22 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -398,7 +398,7 @@ extern struct cifs_tcon *tconInfoAlloc(void);
>  extern void tconInfoFree(struct cifs_tcon *);
>
>  extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
> -extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
> +extern int cifs_sign_smbv(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
>                           __u32 *);
>  extern int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
>                                  struct TCP_Server_Info *server,
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index fa51913..462130d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -366,7 +366,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
>         list_add_tail(&mid->qhead, &server->pending_mid_q);
>         spin_unlock(&GlobalMid_Lock);
>
> -       rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
> +       rc = cifs_sign_smbv(iov, nvec, server, &mid->sequence_number);
>         if (rc)
>                 delete_mid(mid);
>         *ret_mid = mid;
> @@ -522,7 +522,7 @@ cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
>         rc = allocate_mid(ses, hdr, &mid);
>         if (rc)
>                 return rc;
> -       rc = cifs_sign_smb2(iov, nvec, ses->server, &mid->sequence_number);
> +       rc = cifs_sign_smbv(iov, nvec, ses->server, &mid->sequence_number);
>         if (rc)
>                 delete_mid(mid);
>         *ret_mid = mid;
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
