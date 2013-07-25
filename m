From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Move and expand MAX_SERVER_SIZE
Date: Thu, 25 Jul 2013 14:55:46 -0400
Message-ID: <20130725145546.45d78d38@tlielax.poochiereds.net>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374777285-25639-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 25 Jul 2013 14:34:44 -0400
scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> MAX_SERVER_SIZE has been moved to cifs_mount.h and renamed
> CIFS_NI_MAXHOST for clarity.  It has been expanded to 1024 as the
> previous value of 16 was very short.
> 
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h                   | 3 +--
>  include/uapi/linux/cifs/cifs_mount.h | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b07b122..2227699 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -42,8 +42,7 @@
>  #define MAX_SES_INFO 2
>  #define MAX_TCON_INFO 4
>  
> -#define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + CIFS_MAX_SHARE_LEN + 1)
> -#define MAX_SERVER_SIZE 15
> +#define MAX_TREE_SIZE (2 + CIFS_NI_MAXHOST + 1 + CIFS_MAX_SHARE_LEN + 1)
>  
>  #define CIFS_MIN_RCV_POOL 4
>  
> diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
> index f7e4aee..a58fc6e 100644
> --- a/include/uapi/linux/cifs/cifs_mount.h
> +++ b/include/uapi/linux/cifs/cifs_mount.h
> @@ -21,5 +21,6 @@
>  #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
>  #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
>  #define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name length */
> +#define CIFS_NI_MAXHOST        1024 /* max host name length */
>  
>  #endif /* _CIFS_MOUNT_H */

Looks good.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
