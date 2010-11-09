From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls
Date: Tue, 9 Nov 2010 12:40:33 -0500
Message-ID: <20101109124033.28393639@tlielax.poochiereds.net>
References: <1289313302-31064-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289313302-31064-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  9 Nov 2010 08:35:02 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Modify get/set_cifs_acl* calls to reutrn error code and percolate the
> error code up to the caller.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |   46 ++++++++++++++++++++++++++++++----------------
>  1 files changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index c9b4792..003588a 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -568,8 +568,11 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>  
>  	cifs_put_tlink(tlink);
>  
> -	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
> -	return pntsd;
> +	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
> +	if (rc)
> +		return ERR_PTR(rc);
> +	else
	^^^^
	This else isn't needed

> +		return pntsd;
>  }
>  
>  static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
> @@ -591,19 +594,19 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONTROL, 0,
>  			 &fid, &oplock, NULL, cifs_sb->local_nls,
>  			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> -	if (rc) {
> -		cERROR(1, "Unable to open file to get ACL");
> -		goto out;
> +	if (!rc) {
> +		rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
> +		CIFSSMBClose(xid, tcon, fid);
>  	}
>  
> -	rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
> -	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
> -
> -	CIFSSMBClose(xid, tcon, fid);
> - out:
>  	cifs_put_tlink(tlink);
>  	FreeXid(xid);
> -	return pntsd;
> +
> +	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
> +	if (rc)
> +		return ERR_PTR(rc);
> +	else
	^^^^
	Also not needed...

> +		return pntsd;
>  }
>  
>  /* Retrieve an ACL from the server */
> @@ -711,12 +714,18 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>  		pntsd = get_cifs_acl(cifs_sb, inode, path, &acllen);
>  
>  	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
> -	if (pntsd)
> +	if (!pntsd)
> +		cERROR(1, "%s: NULL sec desc", __func__);
	^^^^^^^^
	Will this ever be a null pointer? I don't think it will.
	It's either going to be an ERR_PTR or a real cifs_ntsd.
	I think that check isn't needed.

> +	else if (IS_ERR(pntsd)) {
> +		rc = PTR_ERR(pntsd);
> +		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
> +	} else {
>  		rc = parse_sec_desc(pntsd, acllen, fattr);
> -	if (rc)
> -		cFYI(1, "parse sec desc failed rc = %d", rc);
> +		kfree(pntsd);
> +		if (rc)
> +			cERROR(1, "parse sec desc failed rc = %d", rc);
> +	}
>  
> -	kfree(pntsd);
>  	return;
>  }
>  
	^^^^^
Hmm, now that you're fixing this error, why not have it bubble up to
cifs_get_inode_info too? It seems like cifs_acl_to_fattr could now
return an int, and the caller should handle those errors.

> @@ -736,7 +745,12 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
>  	/* Add three ACEs for owner, group, everyone getting rid of
>  	   other ACEs as chmod disables ACEs and set the security descriptor */
>  
> -	if (pntsd) {
> +	if (!pntsd)
> +		cERROR(1, "%s: NULL sec desc", __func__);
	^^^^^^^^
	Again, this pointer will never be NULL. This can be removed.

> +	else if (IS_ERR(pntsd)) {
> +		rc = PTR_ERR(pntsd);
> +		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
> +	} else {
>  		/* allocate memory for the smb header,
>  		   set security descriptor request security descriptor
>  		   parameters, and secuirty descriptor itself */


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
