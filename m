From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [SMB3] Fix oops when creating symlinks on smb3
Date: Thu, 18 Sep 2014 14:33:37 +0100
Message-ID: <1411047217.3266.2.camel@sachin-laptop>
References: <CAH2r5mv_aH=RCOVW+n6T=zZuXtCNaDNM2QZJUyQJyjf6_KcEYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv_aH=RCOVW+n6T=zZuXtCNaDNM2QZJUyQJyjf6_KcEYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2014-09-15 at 11:43 -0500, Steve French wrote:
> When the protocol ops for create mf symlink was added
> we were not checking for symlink support properly for SMB2/SMB3
> mounts so could oops when mounted with mfsymlinks when try
> to create symlink when on smb2/smb3 mounts rather than cifs
> mount
> 
> I will add a followon patch for mfsymlinks for SMB3 but in the
> meantime need to avoid this possible oops.
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.14+
> CC: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/link.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 68559fd..a5c2812 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -213,8 +213,12 @@ create_mf_symlink(const unsigned int xid, struct
> cifs_tcon *tcon,
>      if (rc)
>          goto out;
> 
> -    rc = tcon->ses->server->ops->create_mf_symlink(xid, tcon, cifs_sb,
> -                    fromName, buf, &bytes_written);
> +    if (tcon->ses->server->ops->create_mf_symlink)
> +        rc = tcon->ses->server->ops->create_mf_symlink(xid, tcon,
> +                    cifs_sb, fromName, buf, &bytes_written);
> +    else
> +        rc = -EOPNOTSUPP;
> +
>      if (rc)
>          goto out;
> 
> 
ACK-ed by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
