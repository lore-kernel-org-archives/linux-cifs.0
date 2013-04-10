From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v5 4/7] CIFS: Use NT_CREATE_ANDX command for forcemand
 mounts
Date: Wed, 10 Apr 2013 07:11:44 -0400
Message-ID: <20130410071144.08ef2983@corrin.poochiereds.net>
References: <1365511227-17626-1-git-send-email-piastry@etersoft.ru>
	<1365511227-17626-5-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365511227-17626-5-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Tue,  9 Apr 2013 16:40:24 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> forcemand mount option now lets us use Windows mandatory style of
> byte-range locks even if server supports posix ones - switches on
> Windows locking mechanism. Share flags is another locking mehanism
> provided by Windows semantic that can be used by NT_CREATE_ANDX
> command. This patch combines all Windows locking mechanism in one
> mount option by using NT_CREATE_ANDX to open files if forcemand is on.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/dir.c  | 1 +
>  fs/cifs/file.c | 6 ++++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index d4331de..8587021 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -217,6 +217,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
>  	}
>  
>  	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
> +	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
>  	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>  			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>  		rc = cifs_posix_open(full_path, &newinode, inode->i_sb, mode,
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9394b2b..19038a4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -455,8 +455,9 @@ int cifs_open(struct inode *inode, struct file *file)
>  	else
>  		oplock = 0;
>  
> -	if (!tcon->broken_posix_open && tcon->unix_ext &&
> -	    cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> +	if (!tcon->broken_posix_open && tcon->unix_ext && cap_unix(tcon->ses)
> +	    && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
> +	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>  				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>  		/* can not refresh inode info since size could be stale */
>  		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
> @@ -624,6 +625,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  		oplock = 0;
>  
>  	if (tcon->unix_ext && cap_unix(tcon->ses) &&
> +	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
>  	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>  				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>  		/*

I'm trying to understand why "forcemand" would matter here. Wouldn't
you just want to switch to using NT_CREATE_ANDX if O_DENY* is set
instead? What happens if I didn't mount with forcemand and then try to
use O_DENY*?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
