From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/7] CIFS: Translate SHARING_VIOLATION to -ETXTBSY
 error code for SMB2
Date: Mon, 11 Mar 2013 14:35:07 -0400
Message-ID: <20130311143507.737f2ab0@corrin.poochiereds.net>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<1362065133-9490-6-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362065133-9490-6-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Feb 2013 19:25:31 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> to make it match CIFS and VFS variants.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/smb2maperror.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
> index 494c912..11e589e 100644
> --- a/fs/cifs/smb2maperror.c
> +++ b/fs/cifs/smb2maperror.c
> @@ -356,7 +356,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
>  	{STATUS_PORT_CONNECTION_REFUSED, -ECONNREFUSED,
>  	"STATUS_PORT_CONNECTION_REFUSED"},
>  	{STATUS_INVALID_PORT_HANDLE, -EIO, "STATUS_INVALID_PORT_HANDLE"},
> -	{STATUS_SHARING_VIOLATION, -EBUSY, "STATUS_SHARING_VIOLATION"},
> +	{STATUS_SHARING_VIOLATION, -ETXTBSY, "STATUS_SHARING_VIOLATION"},
>  	{STATUS_QUOTA_EXCEEDED, -EDQUOT, "STATUS_QUOTA_EXCEEDED"},
>  	{STATUS_INVALID_PAGE_PROTECTION, -EIO,
>  	"STATUS_INVALID_PAGE_PROTECTION"},

Actually, I think Sachin is converting the CIFS
STATUS_SHARING_VIOLATION to translate to EBUSY, since that seems to
better reflect the situation. I'd suggest dropping this patch, unless
you have a specific need for this error return here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
