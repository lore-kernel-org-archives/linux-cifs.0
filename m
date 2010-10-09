From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] handle extended attribute name cifsacl to generate cifs
 acl blob
Date: Sat, 9 Oct 2010 16:42:17 -0400
Message-ID: <20101009164217.2c098abb@corrin.poochiereds.net>
References: <1286460207-4024-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286460207-4024-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  7 Oct 2010 09:03:27 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add extended attribute name system.cifsacl
> 
> Get/generate cifs/ntfs acl blob and hand over to the invoker however
> it wants to parse/process it.
> 
> Stop generating cifs/ntfs acl blob for xattr name system.posix_acl_access
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/xattr.c |   64 +++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 43 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index a264b74..eaf836f 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -30,6 +30,7 @@
>  
>  #define MAX_EA_VALUE_SIZE 65535
>  #define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
> +#define CIFS_ACL_XATTR "system.cifsacl"
>  #define CIFS_XATTR_USER_PREFIX "user."
>  #define CIFS_XATTR_SYSTEM_PREFIX "system."
>  #define CIFS_XATTR_OS2_PREFIX "os2."
> @@ -100,6 +101,42 @@ remove_ea_exit:
>  	return rc;
>  }
>  
> +static int
> +get_cifs_acl(int xid, struct cifsTconInfo *pTcon, char *full_path,
> +			void *ea_value, size_t size, struct nls_table *nls_cp)
> +{
> +	__u16 fid;
> +	int rc;
> +	int oplock = 0;
> +	unsigned int acllen = 0;
> +	struct cifs_ntsd *pacl = NULL;
> +
> +	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN, GENERIC_READ,
> +			0, &fid, &oplock, NULL, nls_cp, 0);
> +	if (rc) {
> +		cERROR(1, "%s: file open error: %d", __func__, rc);
> +		return rc;
> +	}
> +
	^^^^
Hmm possible oplock break. Wouldn't it be better to see if you already
have a readable filehandle before you do this?

> +	rc = CIFSSMBGetCIFSACL(xid, pTcon, fid, &pacl, &acllen);
> +	CIFSSMBClose(xid, pTcon, fid);
> +	if (rc) {
> +		cERROR(1, "%s: get acl error: %d", __func__, rc);
> +		return rc;
> +	}
> +
> +	if (ea_value) {
> +		if (acllen > size) {
> +			kfree(pacl);
> +			return -ERANGE;
> +		}
> +		memcpy(ea_value, pacl, acllen);
> +		kfree(pacl);
> +	}
> +
> +	return acllen;
> +}
> +
>  int cifs_setxattr(struct dentry *direntry, const char *ea_name,
>  		  const void *ea_value, size_t value_size, int flags)
>  {
> @@ -277,27 +314,6 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>  				cifs_sb->local_nls,
>  				cifs_sb->mnt_cifs_flags &
>  					CIFS_MOUNT_MAP_SPECIAL_CHR);
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> -		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
> -			__u16 fid;
> -			int oplock = 0;
> -			struct cifs_ntsd *pacl = NULL;
> -			__u32 buflen = 0;
> -			if (experimEnabled)
> -				rc = CIFSSMBOpen(xid, pTcon, full_path,
> -					FILE_OPEN, GENERIC_READ, 0, &fid,
> -					&oplock, NULL, cifs_sb->local_nls,
> -					cifs_sb->mnt_cifs_flags &
> -					CIFS_MOUNT_MAP_SPECIAL_CHR);
> -			/* else rc is EOPNOTSUPP from above */
> -
> -			if (rc == 0) {
> -				rc = CIFSSMBGetCIFSACL(xid, pTcon, fid, &pacl,
> -						      &buflen);
> -				CIFSSMBClose(xid, pTcon, fid);
> -			}
> -		}
> -#endif /* EXPERIMENTAL */
>  #else
>  		cFYI(1, "query POSIX ACL not supported yet");
>  #endif /* CONFIG_CIFS_POSIX */
> @@ -313,6 +329,12 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>  #else
>  		cFYI(1, "query POSIX default ACL not supported yet");
>  #endif
> +#ifdef CONFIG_CIFS_EXPERIMENTAL
> +	} else if (strncmp(ea_name, CIFS_ACL_XATTR,
> +				strlen(CIFS_ACL_XATTR)) == 0) {
> +			rc = get_cifs_acl(xid, pTcon, full_path, ea_value,
> +					buf_size, cifs_sb->local_nls);
> +#endif /* CONFIG_CIFS_EXPERIMENTAL */
>  	} else if (strncmp(ea_name,
>  		  CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
>  		cFYI(1, "Trusted xattr namespace not supported yet");

I'd probably prefer not to see this new code wrapped in experimental
tags. I don't think that adds any real value, especially not with
something as simple as this.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
