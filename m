From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls [try #2]
Date: Tue, 9 Nov 2010 14:35:42 -0500
Message-ID: <20101109143542.72fa1f63@corrin.poochiereds.net>
References: <1289330107-2273-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289330107-2273-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  9 Nov 2010 13:15:07 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -688,10 +688,9 @@ int cifs_get_inode_info(struct inode **pinode,
>  
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
>  	/* fill in 0777 bits from ACL */
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
> -		cFYI(1, "Getting mode bits from ACL");
> -		cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path, pfid);
> -	}
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
> +		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path,
> +						pfid);

Do you want to return an error from cifs_get_inode_info when fetching
the ACL fails? I think you either need to goto cgii_exit if rc != 0, or
keep ignoring the error code like you do today. If the function is
going to return an error, then there's no real point in doing the later
stuff (the iget, etc).


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
