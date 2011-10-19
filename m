From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: add cifs_async_readv
Date: Wed, 19 Oct 2011 06:59:15 -0400
Message-ID: <20111019065915.0b21f8ba@tlielax.poochiereds.net>
References: <1318336527-13648-1-git-send-email-jlayton@redhat.com>
	<1318336527-13648-3-git-send-email-jlayton@redhat.com>
	<CAKywueR=sXusGdOuAvJHTk1FGURHuDXjj6gz4iJRYeu=Zgkfpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR=sXusGdOuAvJHTk1FGURHuDXjj6gz4iJRYeu=Zgkfpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Oct 2011 14:01:48 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/10/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> ...
> > +
> > +static void
> > +cifs_readv_complete(struct work_struct *work)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata *rdata =3D container_of=
(work,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata, work);
> > + =C2=A0 =C2=A0 =C2=A0 struct page *page, *tpage;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(page, tpage, &rdata=
->pages, lru) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&page->=
lru);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lru_cache_add_fi=
le(page);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rdata->resul=
t =3D=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 kunmap(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 flush_dcache_page(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 SetPageUptodate(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 unlock_page(page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_readpage_to_fscache(rdata->mapping->host, page);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=20
> It seems that we should to kunmap and unlock_page for error case too.
> This change works to me (applied on top of this patch):
>=20
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 99ab419..a0e23d6 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1619,15 +1619,18 @@ cifs_readv_complete(struct work_struct *work)
>         list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
>                 list_del(&page->lru);
>                 lru_cache_add_file(page);
> +               kunmap(page);
>=20
>                 if (rdata->result =3D=3D 0) {
> -                       kunmap(page);
>                         flush_dcache_page(page);
>                         SetPageUptodate(page);
> -                       unlock_page(page);
> -                       cifs_readpage_to_fscache(rdata->mapping->host=
, page);
>                 }
>=20
> +               unlock_page(page);
> +
> +               if (rdata->result =3D=3D 0)
> +                       cifs_readpage_to_fscache(rdata->mapping->host=
, page);
> +
>                 page_cache_release(page);
>         }
>         cifs_readdata_free(rdata);
>=20
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page_cache_relea=
se(page);
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 cifs_readdata_free(rdata);
> > +}
> > +
>=20

Good catch -- patch looks correct to me. Since Steve hasn't merged this
yet, I'll go ahead and roll this into the patch that adds this code.

Thanks,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
