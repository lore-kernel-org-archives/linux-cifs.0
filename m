From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifs: map NT_STATUS_SHARING_VIOLATION to EBUSY
 instead of ETXTBSY
Date: Tue, 12 Mar 2013 09:00:58 -0400
Message-ID: <20130312090058.73564276@tlielax.poochiereds.net>
References: <1363007329-9981-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363007329-9981-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Mar 2013 13:08:49 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> NT_SHARING_VIOLATION errors are mapped to ETXTBSY which is unexpected
> for operations such as unlink where we can hit these errors.
> 
> The patch maps the error NT_SHARING_VIOLATION to EBUSY instead. The
> patch also replaces all instances of ETXTBSY in
> cifs_rename_pending_delete() with EBUSY.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It might be nice to explain *why* you're making this change. It's fresh
in our minds now, but probably won't be in a year or two.

> ---
>  fs/cifs/inode.c   | 10 ++++------
>  fs/cifs/netmisc.c |  2 +-
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index fee2d40..b97ca5b 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1034,7 +1034,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>  				   cifs_sb->mnt_cifs_flags &
>  					    CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	if (rc != 0) {
> -		rc = -ETXTBSY;
> +		rc = -EBUSY;
>  		goto undo_setattr;
>  	}
>  
> @@ -1053,7 +1053,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>  		if (rc == -ENOENT)
>  			rc = 0;
>  		else if (rc != 0) {
> -			rc = -ETXTBSY;
> +			rc = -EBUSY;
>  			goto undo_rename;
>  		}
>  		cifsInode->delete_pending = true;
> @@ -1160,15 +1160,13 @@ psx_del_no_retry:
>  			cifs_drop_nlink(inode);
>  	} else if (rc == -ENOENT) {
>  		d_drop(dentry);
> -	} else if (rc == -ETXTBSY) {
> +	} else if (rc == -EBUSY) {
>  		if (server->ops->rename_pending_delete) {
>  			rc = server->ops->rename_pending_delete(full_path,
>  								dentry, xid);
>  			if (rc == 0)
>  				cifs_drop_nlink(inode);
>  		}
> -		if (rc == -ETXTBSY)
> -			rc = -EBUSY;
>  	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
>  		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
>  		if (attrs == NULL) {
> @@ -1509,7 +1507,7 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
>  	 * source. Note that cross directory moves do not work with
>  	 * rename by filehandle to various Windows servers.
>  	 */
> -	if (rc == 0 || rc != -ETXTBSY)
> +	if (rc == 0 || rc != -EBUSY)
>  		goto do_rename_exit;
>  
>  	/* open-file renames don't work across directories */
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index a82bc51..c0b25b2 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -62,7 +62,7 @@ static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
>  	{ERRdiffdevice, -EXDEV},
>  	{ERRnofiles, -ENOENT},
>  	{ERRwriteprot, -EROFS},
> -	{ERRbadshare, -ETXTBSY},
> +	{ERRbadshare, -EBUSY},
>  	{ERRlock, -EACCES},
>  	{ERRunsup, -EINVAL},
>  	{ERRnosuchshare, -ENXIO},

Other than fleshing out the patch description, this looks good to me...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
