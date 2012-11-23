From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Make use of common cifs_build_path_to_root for
 CIFS and SMB2
Date: Fri, 23 Nov 2012 06:34:46 -0500
Message-ID: <20121123063446.29322ad5@corrin.poochiereds.net>
References: <1353584366-26341-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353584366-26341-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 22 Nov 2012 15:39:26 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> because the is no difference here. This also adds support of prefixpath
> mount option for SMB2.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c    |    4 ++--
>  fs/cifs/cifsglob.h  |   12 ------------
>  fs/cifs/cifsproto.h |    3 +++
>  fs/cifs/connect.c   |   12 ++++++++----
>  fs/cifs/dir.c       |   31 +++++++++++++++++++++++++++++++
>  fs/cifs/smb1ops.c   |   32 --------------------------------
>  fs/cifs/smb2ops.c   |   18 ------------------
>  7 files changed, 44 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5e62f44..c6e32f2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -539,8 +539,8 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>  	char *s, *p;
>  	char sep;
>  
> -	full_path = build_path_to_root(vol, cifs_sb,
> -				       cifs_sb_master_tcon(cifs_sb));
> +	full_path = cifs_build_path_to_root(vol, cifs_sb,
> +					    cifs_sb_master_tcon(cifs_sb));
>  	if (full_path == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a487e34..28e0bee 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -280,9 +280,6 @@ struct smb_version_operations {
>  	/* set attributes */
>  	int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
>  			     const unsigned int);
> -	/* build a full path to the root of the mount */
> -	char * (*build_path_to_root)(struct smb_vol *, struct cifs_sb_info *,
> -				     struct cifs_tcon *);
>  	/* check if we can send an echo or nor */
>  	bool (*can_echo)(struct TCP_Server_Info *);
>  	/* send echo request */
> @@ -1093,15 +1090,6 @@ convert_delimiter(char *path, char delim)
>  	}
>  }
>  
> -static inline char *
> -build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
> -		   struct cifs_tcon *tcon)
> -{
> -	if (!vol->ops->build_path_to_root)
> -		return NULL;
> -	return vol->ops->build_path_to_root(vol, cifs_sb, tcon);
> -}
> -
>  #ifdef CONFIG_CIFS_STATS
>  #define cifs_stats_inc atomic_inc
>  
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 36342a8..7e1562d 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -58,6 +58,9 @@ do {								\
>  } while (0)
>  extern int init_cifs_idmap(void);
>  extern void exit_cifs_idmap(void);
> +extern char *cifs_build_path_to_root(struct smb_vol *vol,
> +				     struct cifs_sb_info *cifs_sb,
> +				     struct cifs_tcon *tcon);
>  extern char *build_path_from_dentry(struct dentry *);
>  extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
>  extern char *cifs_compose_mount_options(const char *sb_mountdata,
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5c670b9..5563681 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3280,8 +3280,10 @@ cifs_cleanup_volume_info(struct smb_vol *volume_info)
>  
>  
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> -/* build_path_to_root returns full path to root when
> - * we do not have an exiting connection (tcon) */
> +/*
> + * cifs_build_path_to_root returns full path to root when we do not have an
> + * exiting connection (tcon)
> + */
>  static char *
>  build_unc_path_to_root(const struct smb_vol *vol,
>  		const struct cifs_sb_info *cifs_sb)
> @@ -3537,8 +3539,10 @@ remote_path_check:
>  			rc = -ENOSYS;
>  			goto mount_fail_check;
>  		}
> -		/* build_path_to_root works only when we have a valid tcon */
> -		full_path = build_path_to_root(volume_info, cifs_sb, tcon);
> +		/*
> +		 * cifs_build_path_to_root works only when we have a valid tcon
> +		 */
> +		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon);
>  		if (full_path == NULL) {
>  			rc = -ENOMEM;
>  			goto mount_fail_check;
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 06be419..8edd950 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -44,6 +44,37 @@ renew_parental_timestamps(struct dentry *direntry)
>  	} while (!IS_ROOT(direntry));
>  }
>  
> +char *
> +cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
> +			struct cifs_tcon *tcon)
> +{
> +	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
> +	int dfsplen;
> +	char *full_path = NULL;
> +
> +	/* if no prefix path, simply set path to the root of share to "" */
> +	if (pplen == 0) {
> +		full_path = kzalloc(1, GFP_KERNEL);
> +		return full_path;
> +	}
> +
> +	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
> +		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
> +	else
> +		dfsplen = 0;
> +
> +	full_path = kmalloc(dfsplen + pplen + 1, GFP_KERNEL);
> +	if (full_path == NULL)
> +		return full_path;
> +
> +	if (dfsplen)
> +		strncpy(full_path, tcon->treeName, dfsplen);
> +	strncpy(full_path + dfsplen, vol->prepath, pplen);
> +	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
> +	full_path[dfsplen + pplen] = 0; /* add trailing null */
> +	return full_path;
> +}
> +
>  /* Note: caller must free return buffer */
>  char *
>  build_path_from_dentry(struct dentry *direntry)
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 83c2d1e..77295f2 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -575,37 +575,6 @@ cifs_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
>  	return CIFSSMBQFileInfo(xid, tcon, fid->netfid, data);
>  }
>  
> -static char *
> -cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
> -			struct cifs_tcon *tcon)
> -{
> -	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
> -	int dfsplen;
> -	char *full_path = NULL;
> -
> -	/* if no prefix path, simply set path to the root of share to "" */
> -	if (pplen == 0) {
> -		full_path = kzalloc(1, GFP_KERNEL);
> -		return full_path;
> -	}
> -
> -	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
> -		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
> -	else
> -		dfsplen = 0;
> -
> -	full_path = kmalloc(dfsplen + pplen + 1, GFP_KERNEL);
> -	if (full_path == NULL)
> -		return full_path;
> -
> -	if (dfsplen)
> -		strncpy(full_path, tcon->treeName, dfsplen);
> -	strncpy(full_path + dfsplen, vol->prepath, pplen);
> -	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
> -	full_path[dfsplen + pplen] = 0; /* add trailing null */
> -	return full_path;
> -}
> -
>  static void
>  cifs_clear_stats(struct cifs_tcon *tcon)
>  {
> @@ -945,7 +914,6 @@ struct smb_version_operations smb1_operations = {
>  	.set_path_size = CIFSSMBSetEOF,
>  	.set_file_size = CIFSSMBSetFileSize,
>  	.set_file_info = smb_set_file_info,
> -	.build_path_to_root = cifs_build_path_to_root,
>  	.echo = CIFSSMBEcho,
>  	.mkdir = CIFSSMBMkDir,
>  	.mkdir_setinfo = cifs_mkdir_setinfo,
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 94ac152..96e2a1b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -263,23 +263,6 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
>  	return rc;
>  }
>  
> -static char *
> -smb2_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
> -			struct cifs_tcon *tcon)
> -{
> -	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
> -	char *full_path = NULL;
> -
> -	/* if no prefix path, simply set path to the root of share to "" */
> -	if (pplen == 0) {
> -		full_path = kzalloc(2, GFP_KERNEL);
> -		return full_path;
> -	}
> -
> -	cERROR(1, "prefixpath is not supported for SMB2 now");
> -	return NULL;
> -}
> -
>  static bool
>  smb2_can_echo(struct TCP_Server_Info *server)
>  {
> @@ -615,7 +598,6 @@ struct smb_version_operations smb21_operations = {
>  	.set_path_size = smb2_set_path_size,
>  	.set_file_size = smb2_set_file_size,
>  	.set_file_info = smb2_set_file_info,
> -	.build_path_to_root = smb2_build_path_to_root,
>  	.mkdir = smb2_mkdir,
>  	.mkdir_setinfo = smb2_mkdir_setinfo,
>  	.rmdir = smb2_rmdir,

 
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
