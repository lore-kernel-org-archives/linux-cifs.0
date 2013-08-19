From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: Expand max share name length to 256
Date: Mon, 19 Aug 2013 08:35:10 -0500
Message-ID: <CAH2r5mteZsyOLK_sz+CMBGa2_WYdEdz1Q93jZg3U0ZPCwk+HgQ@mail.gmail.com>
References: <1376052439-32441-1-git-send-email-scott.lovenberg@gmail.com>
	<1376052439-32441-3-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376052439-32441-3-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This and following patch merged into cifs-2.6.git for-next (and for-3.12)

On Fri, Aug 9, 2013 at 7:47 AM,  <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> The old max share name length limit was 80 due to Windows NET SHARE
> command not allowing more than that.  However, share names can be much
> longer.  This is a more reasonable maximum share name length.
>
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/cifs/cifs_mount.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
> index 19063fe..5ac43f0 100644
> --- a/include/uapi/linux/cifs/cifs_mount.h
> +++ b/include/uapi/linux/cifs/cifs_mount.h
> @@ -20,6 +20,7 @@
>  #define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domain name */
>  #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
>  #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
> -#define CIFS_MAX_SHARE_LEN       80
> +#define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name length */
> +
>
>  #endif /* _CIFS_MOUNT_H */
> --
> 1.8.1.4
>



-- 
Thanks,

Steve
