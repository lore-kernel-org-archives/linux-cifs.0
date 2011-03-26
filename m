From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: set ra_pages in backing_dev_info
Date: Fri, 25 Mar 2011 22:03:31 -0400
Message-ID: <20110325220331.3801a612@corrin.poochiereds.net>
References: <1301084757-2260-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, till2.schaefer-ka8IRLAdjMFlCbFer0i7Sg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301084757-2260-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Mar 2011 16:25:57 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Commit 522440ed made cifs set backing_dev_info on the mapping attached
> to new inodes. This change caused a fairly significant read performance
> regression, as cifs started doing page-sized reads exclusively.
> 
> By virtue of the fact that they're allocated as part of cifs_sb_info by
> kzalloc, the ra_pages on cifs BDIs get set to 0, which prevents any
> readahead. This forces the normal read codepaths to use readpage instead
> of readpages causing a four-fold increase in the number of read calls
> with the default rsize.
> 
> Fix it by setting ra_pages in the BDI to the same value as that in the
> default_backing_dev_info.
> 
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Reported-and-Tested-by: Till <till2.schaefer-ka8IRLAdjMFlCbFer0i7Sg@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 1af2470..fb6a2ad 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -131,6 +131,7 @@ cifs_read_super(struct super_block *sb, void *data,
>  		kfree(cifs_sb);
>  		return rc;
>  	}
> +	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
>  
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	/* copy mount params to sb for use in submounts */

Forgot to mention that this fixes the following kernel.org bug:

    https://bugzilla.kernel.org/show_bug.cgi?id=31662

...look there if you're curious about the gory details...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
