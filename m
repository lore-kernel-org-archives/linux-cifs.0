From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/9] cifs: cork the socket before a send and uncork it afterward
Date: Fri, 27 Jul 2012 03:57:44 +0400
Message-ID: <CAKywueQDJax9SqN95ZKbBmjtxZZs4Y34H5Xi3N3AJtiG09uVpw@mail.gmail.com>
References: <1343231652-10459-1-git-send-email-jlayton@redhat.com>
	<1343231652-10459-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343231652-10459-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We want to send SMBs as "atomically" as possible. Prior to sending any
> data on the socket, cork it to make sure that no non-full frames go
> out. Afterward, uncork it to make sure all of the data gets pushed out
> to the wire.
>
> Note that this more or less renders the socket=TCP_NODELAY mount option
> obsolete. When TCP_CORK and TCP_NODELAY are used on the same socket,
> TCP_NODELAY is essentially ignored.
>
> Acked-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c   |  4 ++++
>  fs/cifs/transport.c | 12 ++++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6df6fa1..a828a8c 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1676,6 +1676,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         if (string == NULL)
>                                 goto out_nomem;
>
> +                       /*
> +                        * FIXME: since we now cork/uncork the socket while
> +                        *        sending, should we deprecate this option?
> +                        */
>                         if (strnicmp(string, "TCP_NODELAY", 11) == 0)
>                                 vol->sockopt_tcp_nodelay = 1;
>                         break;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d93f15d..a3e58b2 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -27,6 +27,7 @@
>  #include <linux/net.h>
>  #include <linux/delay.h>
>  #include <linux/freezer.h>
> +#include <linux/tcp.h>
>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
>  #include <linux/mempool.h>
> @@ -247,12 +248,23 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
>         int n_vec = rqst->rq_nvec;
>         unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
>         size_t total_len;
> +       struct socket *ssocket = server->ssocket;
> +       int val = 1;
>
>         cFYI(1, "Sending smb: smb_len=%u", smb_buf_length);
>         dump_smb(iov[0].iov_base, iov[0].iov_len);
>
> +       /* cork the socket */
> +       kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
> +                               (char *)&val, sizeof(val));
> +
>         rc = smb_send_kvec(server, iov, n_vec, &total_len);
>
> +       /* uncork it */
> +       val = 0;
> +       kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
> +                               (char *)&val, sizeof(val));
> +
>         if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
>                 cFYI(1, "partial send (wanted=%u sent=%zu): terminating "
>                         "session", smb_buf_length + 4, total_len);
> --
> 1.7.11.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I tested it with SMB2 against Windows 7 server. When iosize is 64K
everything is ok but when we increase iosize to 1M (by using
multicredit requests) and the server loses the network connection and
only reboot helps.

Also if I commented corking/uncorking the socket - everything is ok. I
think this change needs some more investigation (how does it deals
with 1M iosize on Samba, etc?)

-- 
Best regards,
Pavel Shilovsky.
