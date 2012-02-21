From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 4/8] cifs: fix allocation in cifs_write_allocate_pages
Date: Tue, 21 Feb 2012 11:45:32 +0400
Message-ID: <CAKywueQ1BmNhmOH1MSSRNSh1vkQ7ERbKWPb650GH0M1_-pf3JQ@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The gfp flags are currently set to __GPF_HIGHMEM, which doesn't allow
> for any reclaim. Make this more resilient by or'ing that with
> GFP_KERNEL. Also, get rid of the goto and unify the exit codepath.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 13 ++++++-------
> =A01 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index febf32e..6afa40f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2001,7 +2001,7 @@ cifs_write_allocate_pages(struct page **pages, =
unsigned long num_pages)
> =A0 =A0 =A0 =A0unsigned long i;
>
> =A0 =A0 =A0 =A0for (i =3D 0; i < num_pages; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages[i] =3D alloc_page(__GFP_HIGHMEM);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages[i] =3D alloc_page(GFP_KERNEL|__GF=
P_HIGHMEM);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!pages[i]) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * save number of page=
s we have already allocated and
> @@ -2009,15 +2009,14 @@ cifs_write_allocate_pages(struct page **pages=
, unsigned long num_pages)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_pages =3D i;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 return rc;
> -
> -error:
> - =A0 =A0 =A0 for (i =3D 0; i < num_pages; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < num_pages; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_page(pages[i]);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> --
> 1.7.7.6
>

Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
