From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix memory leak in cifs_hardlink()
Date: Mon, 13 Jan 2014 09:48:15 -0600
Message-ID: <CAH2r5mur2zD3+OhKyJciO+C+XN3wMh-2R03nq1J8NdB=jPTkKA@mail.gmail.com>
References: <20140111015722.2c8eb2f6@spike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140111015722.2c8eb2f6@spike>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

On Fri, Jan 10, 2014 at 6:57 PM, Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org> wrote:
> Fix a potential memory leak in the cifs_hardlink() error handling path.
> Detected by Coverity: CID 728510, CID 728511.
>
> Signed-off-by: Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
> ---
>  fs/cifs/link.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 92aee08..28bc8ee 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -438,8 +438,10 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
>                                                 CIFS_MOUNT_MAP_SPECIAL_CHR);
>         else {
>                 server = tcon->ses->server;
> -               if (!server->ops->create_hardlink)
> -                       return -ENOSYS;
> +               if (!server->ops->create_hardlink) {
> +                       rc = -ENOSYS;
> +                       goto cifs_hl_exit;
> +               }
>                 rc = server->ops->create_hardlink(xid, tcon, from_name, to_name,
>                                                   cifs_sb);
>                 if ((rc == -EIO) || (rc == -EINVAL))
> --
> 1.8.3.2



-- 
Thanks,

Steve
