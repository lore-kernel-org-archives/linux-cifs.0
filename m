From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/9] fallback to CIFSSMBQPathInfoBasic()/Standard() in
 cifs_is_path_accessible()
Date: Fri, 22 Nov 2013 09:31:50 -0500
Message-ID: <20131122093150.1d4a0413@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-7-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-7-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 11:26:55 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:


Some explanation of the rationale for this might be nice.

> ---
>  smb1ops.c |   20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/smb1ops.c b/smb1ops.c
> index 635b1e5..a12e370 100644
> --- a/smb1ops.c
> +++ b/smb1ops.c
> @@ -540,11 +540,23 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  		     FILE_ALL_INFO *data, bool *adjustTZ)
>  {
>  	int rc;
> +	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  
>  	/* could do find first instead but this returns more info */
>  	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
> -			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
> -						CIFS_MOUNT_MAP_SPECIAL_CHR);
> +			      cifs_sb->local_nls, remap);
> +
> +	if (rc == -EIO) {
> +		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
> +					   (FILE_BASIC_INFO*)data,
> +					   cifs_sb->local_nls, remap);
> +		if (!rc) {
> +			rc = CIFSSMBQPathInfoStandard(xid, tcon, full_path,
> +						      (void*)data + sizeof(FILE_BASIC_INFO),
> +						      cifs_sb->local_nls, remap);
> +		}
> +	}
> +

I don't get the above. Why do the Basic call at all if you're just
going to overwrite the returned info with the standard one when it
succeeds?

>  	/*
>  	 * BB optimize code so we do not make the above call when server claims
>  	 * no NT SMB support and the above call failed at least once - set flag
> @@ -552,9 +564,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  	 */
>  	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
>  		rc = SMBQueryInformation(xid, tcon, full_path, data,
> -					 cifs_sb->local_nls,
> -					 cifs_sb->mnt_cifs_flags &
> -						CIFS_MOUNT_MAP_SPECIAL_CHR);
> +					 cifs_sb->local_nls, remap);
>  		*adjustTZ = true;
>  	}
>  	return rc;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
