From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH 02/10] cifs: honor AT_STATX_DONT_SYNC
Date: Thu, 21 Sep 2017 13:14:53 -0500
Message-ID: <CAH2r5mvhMdFy8fVE+5qNFO-Fgz+mCbn_Z1Xtgib_Qe9X8naumw@mail.gmail.com>
References: <1505896805-12055-1-git-send-email-mszeredi@redhat.com>
 <1505896805-12055-3-git-send-email-mszeredi@redhat.com> <CAH2r5mtNGzVsoKw49zxButMNfwTtx1H4CFe9o9=mCxhCHZVFuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtNGzVsoKw49zxButMNfwTtx1H4CFe9o9=mCxhCHZVFuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adding linux-cifs to cc


---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, Sep 21, 2017 at 1:14 PM
Subject: Re: [PATCH 02/10] cifs: honor AT_STATX_DONT_SYNC
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML
<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>


Do you have any sample program/code to query with this flag?

On Wed, Sep 20, 2017 at 3:39 AM, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The description of this flag says "Don't sync attributes with the server".
> In other words: always use the attributes cached in the kernel and don't
> send network or local messages to refresh the attributes.
>
> Signed-off-by: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/inode.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index a8693632235f..982ba2e4f549 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2003,22 +2003,24 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
>         struct inode *inode = d_inode(dentry);
>         int rc;
>
> -       /*
> -        * We need to be sure that all dirty pages are written and the server
> -        * has actual ctime, mtime and file length.
> -        */
> -       if (!CIFS_CACHE_READ(CIFS_I(inode)) && inode->i_mapping &&
> -           inode->i_mapping->nrpages != 0) {
> -               rc = filemap_fdatawait(inode->i_mapping);
> -               if (rc) {
> -                       mapping_set_error(inode->i_mapping, rc);
> -                       return rc;
> +       if (!(flags & AT_STATX_DONT_SYNC)) {
> +               /*
> +                * We need to be sure that all dirty pages are written and the
> +                * server has actual ctime, mtime and file length.
> +                */
> +               if (!CIFS_CACHE_READ(CIFS_I(inode)) && inode->i_mapping &&
> +                   inode->i_mapping->nrpages != 0) {
> +                       rc = filemap_fdatawait(inode->i_mapping);
> +                       if (rc) {
> +                               mapping_set_error(inode->i_mapping, rc);
> +                               return rc;
> +                       }
>                 }
> -       }
>
> -       rc = cifs_revalidate_dentry_attr(dentry);
> -       if (rc)
> -               return rc;
> +               rc = cifs_revalidate_dentry_attr(dentry);
> +               if (rc)
> +                       return rc;
> +       }
>
>         generic_fillattr(inode, stat);
>         stat->blksize = CIFS_MAX_MSGSIZE;
> --
> 2.5.5
>



--
Thanks,

Steve


-- 
Thanks,

Steve
