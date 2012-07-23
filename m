From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 01/45] CIFS: Make CAP_* checks protocol independent
Date: Mon, 23 Jul 2012 09:55:36 -0400
Message-ID: <20120723095536.46fbda6c@tlielax.poochiereds.net>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Jul 2012 19:48:17 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -385,9 +385,8 @@ int cifs_open(struct inode *inode, struct file *file)
>  		oplock = 0;
>  
>  	if (!tcon->broken_posix_open && tcon->unix_ext &&
> -	    (tcon->ses->capabilities & CAP_UNIX) &&
> -	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> -			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
> +	    cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> +				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
>  		/* can not refresh inode info since size could be stale */
>  		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
>  				cifs_sb->mnt_file_mode /* ignored */,

While I'm in general OK with abstracting out things like this with a
set of operations, I'm not sure it makes much sense to make things so
granular in the name of code-sharing

Would it be better for instance, to simply have a different f_ops->open
routine for SMB2, and simply check the right bit for CAP_UNIX in each
one?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
