From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls [try #3]
Date: Wed, 10 Nov 2010 07:19:36 -0500
Message-ID: <20101110071936.162c988c@tlielax.poochiereds.net>
References: <1289341528-3675-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289341528-3675-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  9 Nov 2010 16:25:28 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Modify get/set_cifs_acl* calls to reutrn error code and percolate the
> error code up to the caller.
> 
> Even though, function cifs_acl_to_fattr() now returns a return code,
> it is not yet handled by the caller of cifs_acl_to_fattr().
> I would suggest to make that change, a part of another patch.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c   |   44 ++++++++++++++++++++++++++------------------
>  fs/cifs/cifsproto.h |    2 +-
>  2 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index c9b4792..cf53f7d 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -560,7 +560,7 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>  
>  	if (IS_ERR(tlink))
> -		return NULL;
> +		ERR_CAST(tlink);
		^^^^^^^^
		ERR_CAST doesn't do anything but recast the pointer. Don't you want to return here?

>  
>  	xid = GetXid();
>  	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &pntsd, pacllen);
> @@ -568,7 +568,9 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>  
>  	cifs_put_tlink(tlink);
>  
> -	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
> +	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
> +	if (rc)
> +		return ERR_PTR(rc);
>  	return pntsd;
>  }
>  
> @@ -583,7 +585,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>  
>  	if (IS_ERR(tlink))
> -		return NULL;
> +		ERR_CAST(tlink);
		^^^^^^^^
		and here?
>  
>  	tcon = tlink_tcon(tlink);
>  	xid = GetXid();
> @@ -591,18 +593,17 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
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
> +
> +	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
> +	if (rc)
> +		return ERR_PTR(rc);
>  	return pntsd;
>  }
>  
> @@ -695,7 +696,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>  }
>  
>  /* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mode bits */
> -void
> +int
>  cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>  		  struct inode *inode, const char *path, const __u16 *pfid)
>  {
> @@ -711,13 +712,17 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>  		pntsd = get_cifs_acl(cifs_sb, inode, path, &acllen);
>  
>  	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
> -	if (pntsd)
> +	if (IS_ERR(pntsd)) {
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
> -	return;
> +	return rc;
>  }
>  
>  /* Convert mode bits to an ACL so we can update the ACL on the server */
> @@ -736,7 +741,10 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
>  	/* Add three ACEs for owner, group, everyone getting rid of
>  	   other ACEs as chmod disables ACEs and set the security descriptor */
>  
> -	if (pntsd) {
> +	if (IS_ERR(pntsd)) {
> +		rc = PTR_ERR(pntsd);
> +		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
> +	} else {
>  		/* allocate memory for the smb header,
>  		   set security descriptor request security descriptor
>  		   parameters, and secuirty descriptor itself */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 7ed69b6..6ed59af 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -130,7 +130,7 @@ extern int cifs_get_file_info_unix(struct file *filp);
>  extern int cifs_get_inode_info_unix(struct inode **pinode,
>  			const unsigned char *search_path,
>  			struct super_block *sb, int xid);
> -extern void cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
> +extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
>  			      struct cifs_fattr *fattr, struct inode *inode,
>  			      const char *path, const __u16 *pfid);
>  extern int mode_to_acl(struct inode *inode, const char *path, __u64);


Ok, so to be clear...the decision is to continue ignoring errors from
cifs_acl_to_fattr in cifs_get_inode_info?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
