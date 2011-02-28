From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: cleanup: Rename and remove config flags
Date: Mon, 28 Feb 2011 13:30:48 -0500
Message-ID: <20110228133048.045b6217@corrin.poochiereds.net>
References: <1298652535-14628-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298652535-14628-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Feb 2011 10:48:55 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Remove config flag CIFS_EXPERIMENTAL.
> Do export operations under new config flag CIFS_NFSD_EXPORT
> 
>  
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/Kconfig   |   14 +++-----------
>  fs/cifs/cifsfs.c  |    4 ++--
>  fs/cifs/cifsfs.h  |    4 ++--
>  fs/cifs/cifssmb.c |    4 ----
>  fs/cifs/export.c  |    4 ++--
>  5 files changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 2a492aa..7c584be 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -172,16 +172,8 @@ config CIFS_SMB2
>  
>  	  Unless you are a developer or tester, say N.
>  
> -config CIFS_EXPERIMENTAL
> -	  bool "CIFS Experimental Features (EXPERIMENTAL)"
> +config CIFS_NFSD_EXPORT
> +	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
>  	  depends on CIFS && EXPERIMENTAL
>  	  help
> -	    Enables cifs features under testing. These features are
> -	    experimental and currently include DFS support and directory
> -	    change notification ie fcntl(F_DNOTIFY), as well as the upcall
> -	    mechanism which will be used for Kerberos session negotiation
> -	    and uid remapping.  Some of these features also may depend on
> -	    setting a value of 1 to the pseudo-file /proc/fs/cifs/Experimental
> -	    (which is disabled by default). See the file fs/cifs/README
> -	    for more details.  If unsure, say N.
> -
> +	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 191ef2f..f593036 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -187,12 +187,12 @@ cifs_read_super(struct super_block *sb, void *data,
>  	else
>  		sb->s_d_op = &cifs_dentry_ops;
>  
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> +#ifdef CIFS_NFSD_EXPORT
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>  		cFYI(1, "export ops supported");
>  		sb->s_export_op = &cifs_export_ops;
>  	}
> -#endif /* EXPERIMENTAL */
> +#endif /* CIFS_NFSD_EXPORT */
>  
>  	return 0;
>  
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index f191244..371d021 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -123,9 +123,9 @@ extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
>  extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
>  extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> +#ifdef CIFS_NFSD_EXPORT
>  extern const struct export_operations cifs_export_ops;
> -#endif /* EXPERIMENTAL */
> +#endif /* CIFS_NFSD_EXPORT */
>  
>  #define CIFS_VERSION   "1.71"
>  #endif				/* _CIFSFS_H */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 4b0ac27..7a454fb 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -541,10 +541,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  		server->secType = RawNTLMSSP;
>  	else if (secFlags & CIFSSEC_MAY_LANMAN)
>  		server->secType = LANMAN;
> -/* #ifdef CONFIG_CIFS_EXPERIMENTAL
> -	else if (secFlags & CIFSSEC_MAY_PLNTXT)
> -		server->secType = ??
> -#endif */
>  	else {
>  		rc = -EOPNOTSUPP;
>  		cERROR(1, "Invalid security type");
> diff --git a/fs/cifs/export.c b/fs/cifs/export.c
> index 993f820..55d87ac 100644
> --- a/fs/cifs/export.c
> +++ b/fs/cifs/export.c
> @@ -45,7 +45,7 @@
>  #include "cifs_debug.h"
>  #include "cifsfs.h"
>  
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> +#ifdef CIFS_NFSD_EXPORT
>  static struct dentry *cifs_get_parent(struct dentry *dentry)
>  {
>  	/* BB need to add code here eventually to enable export via NFSD */
> @@ -63,5 +63,5 @@ const struct export_operations cifs_export_ops = {
>  	.encode_fs =  */
>  };
>  
> -#endif /* EXPERIMENTAL */
> +#endif /* CIFS_NFSD_EXPORT */
>  

Looks good.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
