From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: check MaxPathNameComponentLength != 0 before using it
Date: Mon, 30 Oct 2017 02:17:42 -0500
Message-ID: <CAH2r5msA=tpkuLTei9dWuzKLXd=kfLjgKMo8sqcsJ+iXYMkjcg@mail.gmail.com>
References: <20171030022803.31066-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030022803.31066-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Sun, Oct 29, 2017 at 9:28 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> And fix tcon leak in error path.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/dir.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index e702d48bd023..81ba6e0d88d8 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -204,7 +204,8 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
>         struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
>         int i;
>
> -       if (unlikely(direntry->d_name.len >
> +       if (unlikely(tcon->fsAttrInfo.MaxPathNameComponentLength &&
> +                    direntry->d_name.len >
>                      le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
>                 return -ENAMETOOLONG;
>
> @@ -520,7 +521,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>
>         rc = check_name(direntry, tcon);
>         if (rc)
> -               goto out_free_xid;
> +               goto out;
>
>         server = tcon->ses->server;
>
> --
> 2.13.3
>



-- 
Thanks,

Steve
