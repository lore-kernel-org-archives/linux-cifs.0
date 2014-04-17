From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] Add dditional error text for missing mount.cifs
Date: Thu, 17 Apr 2014 12:56:51 -0500
Message-ID: <CAH2r5mt1fvzXtQRUL5yi1WLQC=o4rFJhNubNNGCQGvGu-3rF4Q@mail.gmail.com>
References: <20140417174223.GD16576@woodpecker.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140417174223.GD16576-WkJ4KB730YtOk+SH+krGketnjj8NnB7F@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Might be better to check for /sbin/mount.cifs unless there are distros
put mount helpers in a different location

On Thu, Apr 17, 2014 at 12:42 PM, Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
> If a cifs mount is attempted without mount.cifs present on the
> system the following appears via dmesg:
>
> [   25.949378] CIFS VFS: No username specified
>
> The purpose of this patch is to better inform the user of the
> possible cause of the error and show a potential solution.
>
> Signed-off-by: Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8813ff7..aa3249d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3371,7 +3371,7 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
>         /* BB fixme parse for domain name here */
>         cifs_dbg(FYI, "Username: %s\n", volume_info->username);
>     } else {
> -       cifs_dbg(VFS, "No username specified\n");
> +       cifs_dbg(VFS, "No username specified. Check for missing external program mount.cifs\n");
>     /* In userspace mount helper we can get user name from alternate
>        locations such as env variables and files on disk */
>         return -EINVAL;
> --
> 1.8.3.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
