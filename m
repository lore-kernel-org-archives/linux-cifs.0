From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: add cifs_async_readv
Date: Wed, 19 Oct 2011 14:01:48 +0400
Message-ID: <CAKywueR=sXusGdOuAvJHTk1FGURHuDXjj6gz4iJRYeu=Zgkfpg@mail.gmail.com>
References: <1318336527-13648-1-git-send-email-jlayton@redhat.com>
	<1318336527-13648-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318336527-13648-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
=2E..
> +
> +static void
> +cifs_readv_complete(struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct cifs_readdata *rdata =3D container_of(work,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_readdata, work);
> + =A0 =A0 =A0 struct page *page, *tpage;
> +
> + =A0 =A0 =A0 list_for_each_entry_safe(page, tpage, &rdata->pages, lr=
u) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&page->lru);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lru_cache_add_file(page);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rdata->result =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_dcache_page(page)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_page(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_readpage_to_fscach=
e(rdata->mapping->host, page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

It seems that we should to kunmap and unlock_page for error case too.
This change works to me (applied on top of this patch):

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 99ab419..a0e23d6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1619,15 +1619,18 @@ cifs_readv_complete(struct work_struct *work)
        list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
                list_del(&page->lru);
                lru_cache_add_file(page);
+               kunmap(page);

                if (rdata->result =3D=3D 0) {
-                       kunmap(page);
                        flush_dcache_page(page);
                        SetPageUptodate(page);
-                       unlock_page(page);
-                       cifs_readpage_to_fscache(rdata->mapping->host, =
page);
                }

+               unlock_page(page);
+
+               if (rdata->result =3D=3D 0)
+                       cifs_readpage_to_fscache(rdata->mapping->host, =
page);
+
                page_cache_release(page);
        }
        cifs_readdata_free(rdata);

> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 cifs_readdata_free(rdata);
> +}
> +

--=20
Best regards,
Pavel Shilovsky.
