From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/19] cifs: remove rfc1002 header from smb2 read/write requests
Date: Thu, 16 Nov 2017 17:42:07 -0800
Message-ID: <CAKywueRU_HM44i04yv_gKza=tgsuxwfF4h-XfstbXTZe3AZQeg@mail.gmail.com>
References: <20171109011433.14468-1-lsahlber@redhat.com> <20171109011433.14468-14-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109011433.14468-14-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-08 17:14 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 42 ++++++++++++++++++++----------------------
>  fs/cifs/smb2pdu.h |  2 +-
>  2 files changed, 21 insertions(+), 23 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index a44d54ea946b..3ba9b2853902 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2471,7 +2471,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>         struct smb2_sync_hdr *shdr;
>
>         rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &req,
> -                                total_len);
> +                            total_len);
>         if (rc)
>                 return rc;
>         if (io_parms->tcon->ses->server == NULL)
> @@ -2681,7 +2681,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>
>         iov[0].iov_base = &req_len;
>         iov[0].iov_len = sizeof(__be32);
> -       iov[1].iov_base = req;
> +       iov[1].iov_base = (char *)req;
>         iov[1].iov_len = total_len;
>
>         rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);

Why do not convert it to use new smb2_send_recv() function?

--
Best regards,
Pavel Shilovsky
