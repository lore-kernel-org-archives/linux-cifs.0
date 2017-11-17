From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 14/19] cifs: remove rfc1002 header from smb2_lease_ack
Date: Fri, 17 Nov 2017 14:56:54 -0800
Message-ID: <CAKywueS9n8wFAWYp=OJLV3WgHy3dRtyLsEqAMbf2thYBDeusBw@mail.gmail.com>
References: <20171109011433.14468-1-lsahlber@redhat.com> <20171109011433.14468-15-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109011433.14468-15-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-08 17:14 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 18 ++++++++++++++----
>  fs/cifs/smb2pdu.h |  2 +-
>  2 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 3ba9b2853902..d5c295cd44ea 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3572,24 +3572,34 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
>  {
>         int rc;
>         struct smb2_lease_ack *req = NULL;
> +       struct cifs_ses *ses = tcon->ses;
>         int flags = CIFS_OBREAK_OP;
> +       unsigned int total_len;
> +       struct kvec iov[1];
> +       struct kvec rsp_iov;
> +       int resp_buf_type;
>
>         cifs_dbg(FYI, "SMB2_lease_break\n");
> -       rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
> +       rc = smb2_plain_req_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req,
> +                            &total_len);
>         if (rc)
>                 return rc;
>
>         if (encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
> -       req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
> +       req->sync_hdr.CreditRequest = cpu_to_le16(1);
>         req->StructureSize = cpu_to_le16(36);
> -       inc_rfc1001_len(req, 12);

Originally, we increased length to 12 for lease break.

>
>         memcpy(req->LeaseKey, lease_key, 16);
>         req->LeaseState = lease_state;
>
> -       rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, flags);
> +       flags |= CIFS_NO_RESP;
> +
> +       iov[0].iov_base = (char *)req;
> +       iov[0].iov_len = total_len;
> +

Don't we need to increase iov_len as well above?


--
Best regards,
Pavel Shilovsky
