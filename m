From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 6/8] cifs: fix up get_numpages
Date: Tue, 21 Feb 2012 11:46:58 +0400
Message-ID: <CAKywueSeQ5PoZWzFNXDv_e5_8eBn=igsittO-CuGD1LwcCiyEw@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Use DIV_ROUND_UP. Also, PAGE_SIZE is more appropriate here since thes=
e
> aren't pagecache pages.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 =A04 +---
> =A01 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6afa40f..264e99c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2027,9 +2027,7 @@ size_t get_numpages(const size_t wsize, const s=
ize_t len, size_t *cur_len)
> =A0 =A0 =A0 =A0size_t clen;
>
> =A0 =A0 =A0 =A0clen =3D min_t(const size_t, len, wsize);
> - =A0 =A0 =A0 num_pages =3D clen / PAGE_CACHE_SIZE;
> - =A0 =A0 =A0 if (clen % PAGE_CACHE_SIZE)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_pages++;
> + =A0 =A0 =A0 num_pages =3D DIV_ROUND_UP(clen, PAGE_SIZE);
>
> =A0 =A0 =A0 =A0if (cur_len)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*cur_len =3D clen;
> --
> 1.7.7.6
>

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
