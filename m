From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: enable fscache iff fsc mount option is used
 explicitly
Date: Sat, 27 Nov 2010 07:24:06 -0500
Message-ID: <20101127072406.1960bd95@tlielax.poochiereds.net>
References: <1290601147-11392-1-git-send-email-sjayaraman@suse.de>
	<1290601147-11392-3-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290601147-11392-3-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 24 Nov 2010 17:49:06 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Currently, if CONFIG_CIFS_FSCACHE is set, fscache is enabled on files opened
> as read-only irrespective of the 'fsc' mount option. Fix this by enabling
> fscache only if 'fsc' mount option is specified explicitly.
> 
> Remove an extraneous cFYI debug message and fix a typo while at it.
> 
> Reported-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/fscache.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
> index a2ad94e..297a43d 100644
> --- a/fs/cifs/fscache.c
> +++ b/fs/cifs/fscache.c
> @@ -2,7 +2,7 @@
>   *   fs/cifs/fscache.c - CIFS filesystem cache interface
>   *
>   *   Copyright (c) 2010 Novell, Inc.
> - *   Author(s): Suresh Jayaraman (sjayaraman-l3A5Bk7waGM@public.gmane.org>
> + *   Author(s): Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>   *
>   *   This library is free software; you can redistribute it and/or modify
>   *   it under the terms of the GNU Lesser General Public License as published
> @@ -67,10 +67,12 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
>  	if (cifsi->fscache)
>  		return;
>  
> -	cifsi->fscache = fscache_acquire_cookie(tcon->fscache,
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE) {
> +		cifsi->fscache = fscache_acquire_cookie(tcon->fscache,
>  				&cifs_fscache_inode_object_def, cifsi);
> -	cFYI(1, "CIFS: got FH cookie (0x%p/0x%p)", tcon->fscache,
> +		cFYI(1, "CIFS: got FH cookie (0x%p/0x%p)", tcon->fscache,
>  				cifsi->fscache);
> +	}
>  }
>  
>  void cifs_fscache_release_inode_cookie(struct inode *inode)
> @@ -101,10 +103,8 @@ void cifs_fscache_set_inode_cookie(struct inode *inode, struct file *filp)
>  {
>  	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
>  		cifs_fscache_disable_inode_cookie(inode);
> -	else {
> +	else
>  		cifs_fscache_enable_inode_cookie(inode);
> -		cFYI(1, "CIFS: fscache inode cookie set");
> -	}
>  }
>  
>  void cifs_fscache_reset_inode_cookie(struct inode *inode)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ok, so we're disabling fscache by just not setting the cookie on the
inode, but the server->fscache and tcon->fscache pointers get set
unconditionally. I suppose that makes sense since we could have someone
mount a tcon without fsc set and then later mount the same one with it
set.

Looks reasonable, I guess...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
