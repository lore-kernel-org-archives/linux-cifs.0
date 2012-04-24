From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] Use correct conversion specifiers in
 cifs_show_options
Date: Tue, 24 Apr 2012 11:18:32 -0400
Message-ID: <20120424111832.58afcbe7@tlielax.poochiereds.net>
References: <1335277710.3604.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	smfrench <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335277710.3604.9.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Apr 2012 15:28:30 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> cifs_show_options uses the wrong conversion specifier for uid, gid,
> rsize & wsize. Correct this to %u to match it to the variable type
> 'unsigned integer'.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index ea8eb92..811245b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -370,13 +370,13 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>  				   (int)(srcaddr->sa_family));
>  	}
>  
> -	seq_printf(s, ",uid=%d", cifs_sb->mnt_uid);
> +	seq_printf(s, ",uid=%u", cifs_sb->mnt_uid);
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
>  		seq_printf(s, ",forceuid");
>  	else
>  		seq_printf(s, ",noforceuid");
>  
> -	seq_printf(s, ",gid=%d", cifs_sb->mnt_gid);
> +	seq_printf(s, ",gid=%u", cifs_sb->mnt_gid);
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
>  		seq_printf(s, ",forcegid");
>  	else
> @@ -439,8 +439,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
>  		seq_printf(s, ",backupgid=%u", cifs_sb->mnt_backupgid);
>  
> -	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
> -	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
> +	seq_printf(s, ",rsize=%u", cifs_sb->rsize);
> +	seq_printf(s, ",wsize=%u", cifs_sb->wsize);
>  	/* convert actimeo and display it in seconds */
>  		seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
>  

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
