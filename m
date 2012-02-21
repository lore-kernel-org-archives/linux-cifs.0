From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 2/8] cifs: allow caller to specify completion op when
 allocating writedata
Date: Tue, 21 Feb 2012 11:43:37 +0400
Message-ID: <CAKywueQvvPsC_Qw_06JeKYEd7ptZnLXqY8UoXarMfj+MXYY+5g@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We'll need a different set of write completion ops when not writing o=
ut
> of the pagecache.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A04 +++-
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A06 +++---
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A03 ++-
> =A03 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 2778605..ff528f3 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -485,7 +485,9 @@ struct cifs_writedata {
> =A0};
>
> =A0int cifs_async_writev(struct cifs_writedata *wdata);
> -struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages);
> +void cifs_writev_complete(struct work_struct *work);
> +struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 work_func_t complete);
> =A0void cifs_writedata_release(struct kref *refcount);
>
> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSPROTO_H */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 9525ae3..e03a650 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1990,7 +1990,7 @@ cifs_writev_requeue(struct cifs_writedata *wdat=
a)
> =A0 =A0 =A0 =A0kref_put(&wdata->refcount, cifs_writedata_release);
> =A0}
>
> -static void
> +void
> =A0cifs_writev_complete(struct work_struct *work)
> =A0{
> =A0 =A0 =A0 =A0struct cifs_writedata *wdata =3D container_of(work,
> @@ -2020,7 +2020,7 @@ cifs_writev_complete(struct work_struct *work)
> =A0}
>
> =A0struct cifs_writedata *
> -cifs_writedata_alloc(unsigned int nr_pages)
> +cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
> =A0{
> =A0 =A0 =A0 =A0struct cifs_writedata *wdata;
>
> @@ -2034,7 +2034,7 @@ cifs_writedata_alloc(unsigned int nr_pages)
> =A0 =A0 =A0 =A0wdata =3D kzalloc(sizeof(*wdata) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct page *) =
* (nr_pages - 1), GFP_NOFS);
> =A0 =A0 =A0 =A0if (wdata !=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, cifs_writev_com=
plete);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&wdata->work, complete);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kref_init(&wdata->refcount);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return wdata;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ffbb2b4..5e758d8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1640,7 +1640,8 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tofind =3D min((cifs_sb->wsize / PAGE_=
CACHE_SIZE) - 1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end - =
index) + 1;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata =3D cifs_writedata_alloc((unsigne=
d int)tofind);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata =3D cifs_writedata_alloc((unsigne=
d int)tofind,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0cifs_writev_complete);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!wdata) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> --
> 1.7.7.6
>

Looks good.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
