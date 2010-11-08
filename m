From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate errors up to the caller during get/set
 acls
Date: Mon, 8 Nov 2010 12:13:10 -0500
Message-ID: <20101108121310.78951ec1@tlielax.poochiereds.net>
References: <1289231238-15203-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289231238-15203-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  8 Nov 2010 09:47:18 -0600
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
>  fs/cifs/cifsacl.c |   84 ++++++++++++++++++++++++++++++----------------------
>  1 files changed, 48 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index c9b4792..8c260b9 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -552,38 +552,40 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
>  	return rc;
>  }
>  
> -static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
> -		__u16 fid, u32 *pacllen)
> +static int
> +get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
> +		__u16 fid, u32 *pacllen, struct cifs_ntsd **pntsd)
		^^^^^^^^^^^
Dealing with pointers to pointers like this is cumbersome and
inefficient. Why not just have it return a struct pointer like before
or a ERR_PTR converted error?

>  {
> -	struct cifs_ntsd *pntsd = NULL;
> -	int xid, rc;
> +	int xid;
> +	int rc = 0;
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>  
>  	if (IS_ERR(tlink))
> -		return NULL;
> +		PTR_ERR(tlink);
		^^^^^^^^^^^^^^^
		bug?

>  
>  	xid = GetXid();
> -	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &pntsd, pacllen);
> +	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, pntsd, pacllen);
>  	FreeXid(xid);
>  
>  	cifs_put_tlink(tlink);
>  
>  	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
> -	return pntsd;
> +	return rc;
>  }
>  
> -static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
> -		const char *path, u32 *pacllen)
> +static int
> +get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
> +			u32 *pacllen, struct cifs_ntsd **pntsd)
>  {
> -	struct cifs_ntsd *pntsd = NULL;
>  	int oplock = 0;
> -	int xid, rc;
> +	int xid;
> +	int rc = 0;
>  	__u16 fid;
>  	struct cifsTconInfo *tcon;
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>  
>  	if (IS_ERR(tlink))
> -		return NULL;
> +		return PTR_ERR(tlink);
>  
>  	tcon = tlink_tcon(tlink);
>  	xid = GetXid();
> @@ -596,32 +598,34 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  		goto out;
>  	}
>  
> -	rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
> +	rc = CIFSSMBGetCIFSACL(xid, tcon, fid, pntsd, pacllen);
>  	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
>  
>  	CIFSSMBClose(xid, tcon, fid);
>   out:
>  	cifs_put_tlink(tlink);
>  	FreeXid(xid);
> -	return pntsd;
> +	return rc;
>  }
>  
>  /* Retrieve an ACL from the server */
> -static struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
> -				      struct inode *inode, const char *path,
> -				      u32 *pacllen)
> +static int
> +get_cifs_acl(struct cifs_sb_info *cifs_sb, struct inode *inode,
> +		const char *path, u32 *pacllen, struct cifs_ntsd **pntsd)
>  {
> -	struct cifs_ntsd *pntsd = NULL;
> +	int rc = 0;
>  	struct cifsFileInfo *open_file = NULL;
>  
>  	if (inode)
>  		open_file = find_readable_file(CIFS_I(inode), true);
	^^^^^^^^^^
	This predates your patch, but under what conditions would we
	call this function without an inode? If you're cleaning up the
	prototype for this function, then I think there are some
	unneeded arguments here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
