From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/9] fallback to CIFSSMBQPathInfoBasic() in
 cifs_is_path_accessible()
Date: Fri, 22 Nov 2013 09:26:19 -0500
Message-ID: <20131122092619.6ba972ca@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-6-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-6-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 11:26:54 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> ---
>  smb1ops.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/smb1ops.c b/smb1ops.c
> index 6094397..635b1e5 100644
> --- a/smb1ops.c
> +++ b/smb1ops.c
> @@ -513,20 +513,23 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>  {
>  	int rc;
>  	FILE_ALL_INFO *file_info;
> +	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  

So many of the arguments to these functions always come from the
cifs_sb. Would it be reasonable to simply pass a cifs_sb pointer down
to these functions and cut out some of the argument bloat?

>  	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>  	if (file_info == NULL)
>  		return -ENOMEM;
>  
>  	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
> -			      0 /* not legacy */, cifs_sb->local_nls,
> -			      cifs_sb->mnt_cifs_flags &
> -				CIFS_MOUNT_MAP_SPECIAL_CHR);
> +			      0 /* not legacy */, cifs_sb->local_nls, remap);
> +	if (rc == -EIO) {
> +		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
> +					   (FILE_BASIC_INFO*)file_info,
> +					   cifs_sb->local_nls, remap);
> +	}
>  
>  	if (rc == -EOPNOTSUPP || rc == -EINVAL)
>  		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
> -				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
> -				  CIFS_MOUNT_MAP_SPECIAL_CHR);
> +					 cifs_sb->local_nls, remap);
>  	kfree(file_info);
>  	return rc;
>  }

-EIO can happen for a lot of different reasons, but there's little harm
in retrying with a more basic call in this function. In fact, it might
make more sense to just always use CIFSSMBQPathInfoBasic here since we
don't actually do anything with the returned info.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
