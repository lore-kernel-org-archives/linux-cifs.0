From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: convert to use le32_add_cpu()
Date: Wed, 28 Aug 2013 08:11:40 -0500
Message-ID: <CADT32eLGa=scGt099sL3TthAHBvX5tUJ43TvxQRs=xWO3cN7qw@mail.gmail.com>
References: <CAPgLHd9CMLtxDq=+96ksygONivXRrmDHqE7+=8SbjOpTNGF=DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPgLHd9CMLtxDq=+96ksygONivXRrmDHqE7+=8SbjOpTNGF=DA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Aug 26, 2013 at 1:34 AM, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>
> Convert cpu_to_le32(le32_to_cpu(E1) + E2) to use le32_add_cpu().
>
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index abc9c28..4ce66bc 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -939,9 +939,7 @@ add_lease_context(struct kvec *iov, unsigned int *num_iovec, __u8 *oplock)
>                 req->CreateContextsOffset = cpu_to_le32(
>                                 sizeof(struct smb2_create_req) - 4 +
>                                 iov[num - 1].iov_len);
> -       req->CreateContextsLength = cpu_to_le32(
> -                               le32_to_cpu(req->CreateContextsLength) +
> -                               sizeof(struct create_lease));
> +       le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_lease));
>         inc_rfc1001_len(&req->hdr, sizeof(struct create_lease));
>         *num_iovec = num + 1;
>         return 0;
> @@ -967,9 +965,7 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
>                 req->CreateContextsOffset =
>                         cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
>                                                                 iov[1].iov_len);
> -       req->CreateContextsLength =
> -                       cpu_to_le32(le32_to_cpu(req->CreateContextsLength) +
> -                                               sizeof(struct create_durable));
> +       le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable));
>         inc_rfc1001_len(&req->hdr, sizeof(struct create_durable));
>         *num_iovec = num + 1;
>         return 0;
>
