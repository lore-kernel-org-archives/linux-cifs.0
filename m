From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add smb2_send_recv
Date: Mon, 20 Nov 2017 13:50:52 -0800
Message-ID: <CAKywueSFic+_oPy9tw7WAWLtP9v2H19cy6kpsieT7cD2w=CVuw@mail.gmail.com>
References: <20171120002447.32322-1-lsahlber@redhat.com> <20171120002447.32322-2-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120002447.32322-2-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-19 16:24 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This function is similar to SendReceive2 except it does not expect
> a 4 byte rfc1002 length header in the first io vector.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |  4 ++++
>  fs/cifs/transport.c | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 4143c9dec463..6d86cd120349 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -106,6 +106,10 @@ extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
>                         struct kvec *, int /* nvec to send */,
>                         int * /* type of buf returned */, const int flags,
>                         struct kvec * /* resp vec */);
> +extern int smb2_send_recv(const unsigned int /* xid */ , struct cifs_ses *,
> +                         struct kvec *, int /* nvec to send */,
> +                         int * /* type of buf returned */, const int flags,
> +                         struct kvec * /* resp vec */);
>  extern int SendReceiveBlockingLock(const unsigned int xid,
>                         struct cifs_tcon *ptcon,
>                         struct smb_hdr *in_buf ,
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 7efbab013957..e678307bb7a0 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -827,6 +827,44 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
>         return rc;
>  }
>
> +/* Like SendReceive2 but iov[0] does not contain an rfc1002 header */
> +int
> +smb2_send_recv(const unsigned int xid, struct cifs_ses *ses,
> +              struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
> +              const int flags, struct kvec *resp_iov)
> +{
> +       struct smb_rqst rqst;
> +       struct kvec *new_iov;
> +       int rc;
> +       int i;
> +       __u32 count;
> +       __be32 rfc1002_marker;
> +
> +       new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
> +       if (!new_iov)
> +               return -ENOMEM;

Probably it is out of the scope of this patchset but can we do a
simple hack here: allocate a fixed size array on stack (suppose iov[8]
which is more that enough for most cases) and use dynamic allocation
only if n_vec + 1 is greater than this fixed value? I can use the same
approach in SendReceive2() as well.


> +
> +       /* 1st iov is an RFC1002 Session Message length */
> +       memcpy(new_iov + 1, iov, (sizeof(struct kvec) * n_vec));
> +
> +       count = 0;
> +       for (i = 1; i < n_vec + 1; i++)
> +               count += new_iov[i].iov_len;
> +
> +       rfc1002_marker = cpu_to_be32(count);
> +
> +       new_iov[0].iov_base = &rfc1002_marker;
> +       new_iov[0].iov_len = 4;
> +
> +       memset(&rqst, 0, sizeof(struct smb_rqst));
> +       rqst.rq_iov = new_iov;
> +       rqst.rq_nvec = n_vec + 1;
> +
> +       rc = cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp_iov);
> +       kfree(new_iov);
> +       return rc;
> +}
> +
>  int
>  SendReceive(const unsigned int xid, struct cifs_ses *ses,
>             struct smb_hdr *in_buf, struct smb_hdr *out_buf,
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
