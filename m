From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 9/9] cache we have broken_qpath_info per tcon
Date: Fri, 22 Nov 2013 09:47:53 -0500
Message-ID: <20131122094753.089f1e04@tlielax.poochiereds.net>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
	<1385116018-14068-1-git-send-email-gbeck@sernet.de>
	<1385116018-14068-10-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-10-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Nov 2013 11:26:58 +0100
Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> ---
>  cifsglob.h |    1 +
>  smb1ops.c  |   26 ++++++++++++++++++--------
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/cifsglob.h b/cifsglob.h
> index 52ca861..d3adde7 100644
> --- a/cifsglob.h
> +++ b/cifsglob.h
> @@ -818,6 +818,7 @@ struct cifs_tcon {
>  	bool local_lease:1; /* check leases (only) on local system not remote */
>  	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
>  	bool need_reconnect:1; /* connection reset, tid now invalid */
> +	bool broken_qpath_info:1;
>  #ifdef CONFIG_CIFS_SMB2
>  	bool print:1;		/* set if connection to printer share */
>  	bool bad_network_name:1; /* set if ret status STATUS_BAD_NETWORK_NAME */
> diff --git a/smb1ops.c b/smb1ops.c
> index 11daa28..e3798a4 100644
> --- a/smb1ops.c
> +++ b/smb1ops.c
> @@ -511,7 +511,7 @@ static int
>  cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>  			struct cifs_sb_info *cifs_sb, const char *full_path)
>  {
> -	int rc;
> +	int rc= -EIO;
>  	FILE_ALL_INFO *file_info;
>  	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  
> @@ -519,13 +519,18 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>  	if (file_info == NULL)
>  		return -ENOMEM;
>  
> -	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
> -			      0 /* not legacy */, cifs_sb->local_nls, remap);
> +	if (!tcon->broken_qpath_info) {
> +		rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
> +				      0, cifs_sb->local_nls, remap);
> +	}
>  	if (rc == -EIO) {
> -		cifs_dbg(FYI, "is_path_accessible: FALLBACK");
>  		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
>  					   (FILE_BASIC_INFO*)file_info,
>  					   cifs_sb->local_nls, remap);
> +		cifs_dbg(FYI, "is_path_accessible: FALLBACK returns %d", rc);
> +		if (!rc) {
> +			tcon->broken_qpath_info = true;
> +		}
>  	}
>  
>  	if (rc == -EOPNOTSUPP || rc == -EINVAL)
> @@ -540,15 +545,16 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  		     struct cifs_sb_info *cifs_sb, const char *full_path,
>  		     FILE_ALL_INFO *data, bool *adjustTZ)
>  {
> -	int rc;
> +	int rc = -EIO;
>  	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  
>  	/* could do find first instead but this returns more info */
> -	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
> -			      cifs_sb->local_nls, remap);
> +	if (!tcon->broken_qpath_info) {
> +		rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0,
> +				      cifs_sb->local_nls, remap);
> +	}
>  
>  	if (rc == -EIO) {
> -		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK");
>  		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
>  					   (FILE_BASIC_INFO*)data,
>  					   cifs_sb->local_nls, remap);
> @@ -557,6 +563,10 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  						      (void*)data + sizeof(FILE_BASIC_INFO),
>  						      cifs_sb->local_nls, remap);
>  		}
> +		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK returns %d", rc);
> +		if (!rc) {
> +			tcon->broken_qpath_info = true;
> +		}

I have a bit of a problem with the above...

Trying to change behavior automatically like this is fraught with peril
and cifs.ko is already a horrid mess of this sort of thing. It's bad
enough that we have some existing fallbacks for -EOPNOTSUPP and
-EINVAL, but those errors are a bit more informative so we can
rationalize them a bit. Also we don't mark the server as broken based
on those errors (though maybe there's an argument to be made for doing
that).

Now however, you're adding one for -EIO. That error tends to be what we
get when an NT error code can't easily be translated to a POSIX error.
So now you might end up falling back and marking this server with
broken_qpath_info when the server might actually support those
infolevels just fine, but you hit some strange transient error.

I think it would be best to respin this set and add a new vers= value
(e.g. 1.0basic or something) that users can mount with to enable this
behavior. That way instead of bloating out the already horribly bloated
standard 1.0 codepaths, you could add a new set of smb_version ops and
have that enable the use of the more basic infolevels.

Yes, it means that users might have to read the manpage to figure this
out, but I think trying to do this automatically will prove quite
problematic.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
