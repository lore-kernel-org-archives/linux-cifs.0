From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2] cifs: dereferencing first then checking
Date: Wed, 27 Oct 2010 19:51:23 -0400
Message-ID: <20101027195123.0a712a53@tlielax.poochiereds.net>
References: <20101027212253.GL6062@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101027212253.GL6062@bicker>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 27 Oct 2010 23:22:53 +0200
Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Smatch complained about a couple checking for NULL after dereferencing
> bugs.  I'm not super familiar with the code so I did the conservative
> thing and move the dereferences after the checks.
> 
> The dereferences in cifs_lock() and cifs_fsync() were added in
> ba00ba64cf0 "cifs: make various routines use the cifsFileInfo->tcon
> pointer".  The dereference in find_writable_file() was added in 
> 6508d904e6f "cifs: have find_readable/writable_file filter by fsuid".
> The comments there say it's possible to trigger the NULL dereference
> under stress.
> 
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 06a006b..33a19b4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -775,13 +775,13 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
>  		cFYI(1, "Unknown type of lock");
>  
>  	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> -	tcon = tlink_tcon(((struct cifsFileInfo *)file->private_data)->tlink);
>  
>  	if (file->private_data == NULL) {
>  		rc = -EBADF;
>  		FreeXid(xid);
>  		return rc;
>  	}
	^^^^^^^
I think the above check can just go away now. If this pointer is NULL
then something is badly wrong.

> +	tcon = tlink_tcon(((struct cifsFileInfo *)file->private_data)->tlink);
>  	netfid = ((struct cifsFileInfo *)file->private_data)->netfid;
>  
>  	if ((tcon->ses->capabilities & CAP_UNIX) &&
> @@ -1179,7 +1179,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
>  					bool fsuid_only)
>  {
>  	struct cifsFileInfo *open_file;
> -	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
> +	struct cifs_sb_info *cifs_sb;
>  	bool any_available = false;
>  	int rc;
>  
> @@ -1192,6 +1192,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
>  		dump_stack();
>  		return NULL;
>  	}
	^^^^^^
	I think we ought to rid ourselves of the above check too. It's
	not clear how we'd get a NULL pointer there anyway -- mostly we
	get cifsInodeInfo pointers from the CIFS_I(inode) macro which does a
	container_of() on the inode. That should never return a NULL
	pointer anyway, unless the inode pointer happens to be corrupt
	in a very specific way.

> +	cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
>  
>  	/* only filter by fsuid on multiuser mounts */
>  	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
> @@ -1628,15 +1629,26 @@ int cifs_fsync(struct file *file, int datasync)
>  		file->f_path.dentry->d_name.name, datasync);
>  
>  	rc = filemap_write_and_wait(inode->i_mapping);
> -	if (rc == 0) {
> -		rc = CIFS_I(inode)->write_behind_rc;
> -		CIFS_I(inode)->write_behind_rc = 0;
> -		tcon = tlink_tcon(smbfile->tlink);
> -		if (!rc && tcon && smbfile &&
> -		   !(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> -			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
> -	}
> +	if (rc)
> +		goto err_out;
> +
> +	rc = CIFS_I(inode)->write_behind_rc;
> +	CIFS_I(inode)->write_behind_rc = 0;
> +	if (rc)
> +		goto err_out;
> +
> +	if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
> +		goto done;
> +	if (!smbfile)
> +		goto done;
> +	tcon = tlink_tcon(smbfile->tlink);
> +	if (!tcon)
> +		goto done;
> +
> +	rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
>  
> +err_out:
> +done:
>  	FreeXid(xid);
>  	return rc;
>  }

The above delta shouldn't be needed once the patches in Steve's tree
are pushed to Linus. I think what we should probably do is wait for
Steve to push to Linus and then do a patch to remove the first two
checks.

Sound like a plan?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
