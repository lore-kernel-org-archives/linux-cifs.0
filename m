From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix error handling in cifs_readv_complete
Date: Fri, 21 Oct 2011 09:25:50 -0500
Message-ID: <CAH2r5ms=mYhw-BT1qiAYqp=Li6cgaJaPYZtn=K2+hEbYrWMojQ@mail.gmail.com>
References: <1319177644-2551-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319177644-2551-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Fri, Oct 21, 2011 at 1:14 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> In cifs_readv_receive we don't update rdata->result to error value
> after kmap'ing a page. We should kunmap the page in the no error
> case only.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 949e121..5c81cd4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1667,9 +1667,9 @@ cifs_readv_complete(struct work_struct *work)
> =A0 =A0 =A0 =A0list_for_each_entry_safe(page, tpage, &rdata->pages, l=
ru) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del(&page->lru);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lru_cache_add_file(page);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(page);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rdata->result =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flush_dcache_page(page=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SetPageUptodate(page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
