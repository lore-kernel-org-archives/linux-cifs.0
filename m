From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Tue, 21 Feb 2012 10:00:06 -0500
Message-ID: <20120221100006.7e43e8b9@tlielax.poochiereds.net>
References: <1329484410-30540-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329484410-30540-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Feb 2012 16:13:30 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Currently we do inc/drop_nlink for a parent directory for every
> mkdir/rmdir calls. That's wrong when Unix extensions are disabled
> because in this case a server doesn't follow the same semantic and
> returns the old value on the next QueryInfo request. As the result,
> we update our value with the server one and then decrement it on
> every rmdir call - go to negative nlink values.
> 
> Fix this by removing inc/drop_nlink for the parent directory from
> mkdir/rmdir, setting it for a revalidation and ignoring NumberOfLinks
> for directories when Unix extensions are disabled.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/inode.c |   28 +++++++++++++++++++---------
>  1 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index a5f54b7..745da3d 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -534,6 +534,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>  	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>  		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
>  		fattr->cf_dtype = DT_DIR;
> +		/*
> +		 * Server can return wrong NumberOfLinks value for directories
> +		 * when Unix extensions are disabled - fake it.
> +		 */
> +		fattr->cf_nlink = 2;
>  	} else {
>  		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
>  		fattr->cf_dtype = DT_REG;
> @@ -541,9 +546,9 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>  		/* clear write bits if ATTR_READONLY is set */
>  		if (fattr->cf_cifsattrs & ATTR_READONLY)
>  			fattr->cf_mode &= ~(S_IWUGO);
> -	}
>  
> -	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> +		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> +	}
>  
>  	fattr->cf_uid = cifs_sb->mnt_uid;
>  	fattr->cf_gid = cifs_sb->mnt_gid;
> @@ -1322,7 +1327,6 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
>  			}
>  /*BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if need
>  	to set uid/gid */
> -			inc_nlink(inode);
>  
>  			cifs_unix_basic_to_fattr(&fattr, pInfo, cifs_sb);
>  			cifs_fill_uniqueid(inode->i_sb, &fattr);
> @@ -1355,7 +1359,6 @@ mkdir_retry_old:
>  		d_drop(direntry);
>  	} else {
>  mkdir_get_info:
> -		inc_nlink(inode);
>  		if (pTcon->unix_ext)
>  			rc = cifs_get_inode_info_unix(&newinode, full_path,
>  						      inode->i_sb, xid);
> @@ -1436,6 +1439,11 @@ mkdir_get_info:
>  		}
>  	}
>  mkdir_out:
> +	/*
> +	 * Force revalidate to get parent dir info when needed since cached
> +	 * attributes are invalid now.
> +	 */
> +	CIFS_I(inode)->time = 0;
>  	kfree(full_path);
>  	FreeXid(xid);
>  	cifs_put_tlink(tlink);
> @@ -1475,7 +1483,6 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  	cifs_put_tlink(tlink);
>  
>  	if (!rc) {
> -		drop_nlink(inode);
>  		spin_lock(&direntry->d_inode->i_lock);
>  		i_size_write(direntry->d_inode, 0);
>  		clear_nlink(direntry->d_inode);
> @@ -1483,12 +1490,15 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  	}
>  
>  	cifsInode = CIFS_I(direntry->d_inode);
> -	cifsInode->time = 0;	/* force revalidate to go get info when
> -				   needed */
> +	/* force revalidate to go get info when needed */
> +	cifsInode->time = 0;
>  
>  	cifsInode = CIFS_I(inode);
> -	cifsInode->time = 0;	/* force revalidate to get parent dir info
> -				   since cached search results now invalid */
> +	/*
> +	 * Force revalidate to get parent dir info when needed since cached
> +	 * attributes are invalid now.
> +	 */
> +	cifsInode->time = 0;
>  
>  	direntry->d_inode->i_ctime = inode->i_ctime = inode->i_mtime =
>  		current_fs_time(inode->i_sb);

Looks good.

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
