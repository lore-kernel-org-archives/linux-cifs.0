From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: Fix bug when checking error condition in
 cifs_rename_pending_delete()
Date: Wed, 6 Mar 2013 07:35:15 -0500
Message-ID: <20130306073515.0015029b@tlielax.poochiereds.net>
References: <1362511557-22607-1-git-send-email-sprabhu@redhat.com>
	<1362511557-22607-2-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362511557-22607-2-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  5 Mar 2013 19:25:55 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Fix check for error condition after setting attributes with
> CIFSSMBSetFileInfo().
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ed6208f..a183b9d 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1014,7 +1014,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>  					current->tgid);
>  		/* although we would like to mark the file hidden
>   		   if that fails we will still try to rename it */
> -		if (rc != 0)
> +		if (!rc)
>  			cifsInode->cifsAttrs = dosattr;
>  		else
>  			dosattr = origattr; /* since not able to change them */

Nice catch

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
