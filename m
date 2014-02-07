From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use a flexarray in cifs_writedata
Date: Fri, 7 Feb 2014 20:31:19 +0400
Message-ID: <CAKywueQCtUvEQN9NOocnv5T338uyfQB2J90HROkDD=r7LFC4XA@mail.gmail.com>
References: <1391789044-26179-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391789044-26179-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-02-07 20:04 GMT+04:00 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The cifs_writedata code uses a single element trailing array, which
> just adds unneeded complexity. Use a flexarray instead.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h | 2 +-
>  fs/cifs/cifssmb.c  | 8 +-------
>  2 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 57d07e704d97..e7fe49e75cdb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1064,7 +1064,7 @@ struct cifs_writedata {
>         unsigned int                    pagesz;
>         unsigned int                    tailsz;
>         unsigned int                    nr_pages;
> -       struct page                     *pages[1];
> +       struct page                     *pages[];
>  };
>
>  /*
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 0726ab413b8c..a75b56025df7 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1962,15 +1962,9 @@ cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
>  {
>         struct cifs_writedata *wdata;
>
> -       /* this would overflow */
> -       if (nr_pages == 0) {
> -               cifs_dbg(VFS, "%s: called with nr_pages == 0!\n", __func__);
> -               return NULL;
> -       }
> -
>         /* writedata + number of page pointers */
>         wdata = kzalloc(sizeof(*wdata) +
> -                       sizeof(struct page *) * (nr_pages - 1), GFP_NOFS);
> +                       sizeof(struct page *) * nr_pages, GFP_NOFS);
>         if (wdata != NULL) {
>                 kref_init(&wdata->refcount);
>                 INIT_LIST_HEAD(&wdata->list);
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reasonable.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
