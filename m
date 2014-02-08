From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use a flexarray in cifs_writedata
Date: Fri, 7 Feb 2014 20:49:57 -0600
Message-ID: <CAH2r5mu3MDKthq84+NbBg68GxZen9eUME2kQ6HAyPBnPr-cenA@mail.gmail.com>
References: <1391789044-26179-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391789044-26179-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Fri, Feb 7, 2014 at 10:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
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



-- 
Thanks,

Steve
