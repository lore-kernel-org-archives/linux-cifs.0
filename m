From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: Check server capability before attempting
 silly rename
Date: Wed, 6 Mar 2013 07:36:57 -0500
Message-ID: <20130306073657.777e535d@tlielax.poochiereds.net>
References: <1362511557-22607-1-git-send-email-sprabhu@redhat.com>
	<1362511557-22607-3-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362511557-22607-3-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  5 Mar 2013 19:25:56 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> cifs_rename_pending_delete() attempts to silly rename file using
> CIFSSMBRenameOpenFile(). This uses the SET_FILE_INFORMATION TRANS2
> command with information level set to the passthru info-level
> SMB_SET_FILE_RENAME_INFORMATION.
> 
> We need to check to make sure that the server support passthru
> info-levels before attempting the silly rename or else we will fail to
> rename the file.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/inode.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index a183b9d..fee2d40 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -986,6 +986,15 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>  		return PTR_ERR(tlink);
>  	tcon = tlink_tcon(tlink);
>  
> +	/*
> +	 * We cannot rename the file if the server doesn't support
> +	 * CAP_INFOLEVEL_PASSTHRU
> +	 */
> +	if (!(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU)) {
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +
>  	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
>  			 DELETE|FILE_WRITE_ATTRIBUTES, CREATE_NOT_DIR,
>  			 &netfid, &oplock, NULL, cifs_sb->local_nls,

We almost certainly need to do the same in other places too. The cifs
code does too much "try and fall back" when it should first check for
capabilities. Keep your eyes open for others!

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
