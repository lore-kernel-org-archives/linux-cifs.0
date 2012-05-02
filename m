From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs: don't cap ra_pages at the same level as default_backing_dev_info
Date: Wed, 02 May 2012 18:12:26 +0530
Message-ID: <4FA12BB2.2040708@suse.com>
References: <1335909117-17314-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335909117-17314-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/02/2012 03:21 AM, Jeff Layton wrote:
> While testing, I've found that even when we are able to negotiate a
> much larger rsize with the server, on-the-wire reads often end up being
> capped at 128k because of ra_pages being capped at that level.
> 
> Lifting this restriction gave almost a twofold increase in sequential
> read performance on my craptactular KVM test rig with a 1M rsize:
> 
> $ dd if=./ddtest.out of=/dev/null bs=1M count=1024
> 
> Prepatch:
> 1048576000 bytes (1.0 GB) copied, 28.1979 s, 37.2 MB/s
> 
> Postpatch:
> 1048576000 bytes (1.0 GB) copied, 11.92 s, 88.0 MB/s
> 
> I think this is safe since the actual ra_pages that the VM requests
> is run through max_sane_readahead() prior to submitting the I/O. Under
> memory pressure we should end up with large readahead requests being
> suppressed anyway.

Yeah, it seems safer to me as well.

Wondering whether we need to just verify with small memory systems (or
restricting physical memory with "mem=" ) to ensure that the latency is
OK... but then if that is the case the user consciously asked for it
with explicit larger rsize so even if the latency is high it shouldn't
be a problem I think.


> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |   18 +-----------------
>  1 files changed, 1 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 0d783e2..d41a4a8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3705,22 +3705,6 @@ cifs_get_volume_info(char *mount_data, const char *devname)
>  	return volume_info;
>  }
>  
> -/* make sure ra_pages is a multiple of rsize */
> -static inline unsigned int
> -cifs_ra_pages(struct cifs_sb_info *cifs_sb)
> -{
> -	unsigned int reads;
> -	unsigned int rsize_pages = cifs_sb->rsize / PAGE_CACHE_SIZE;
> -
> -	if (rsize_pages >= default_backing_dev_info.ra_pages)
> -		return default_backing_dev_info.ra_pages;
> -	else if (rsize_pages == 0)
> -		return rsize_pages;
> -
> -	reads = default_backing_dev_info.ra_pages / rsize_pages;
> -	return reads * rsize_pages;
> -}
> -
>  int
>  cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
>  {
> @@ -3808,7 +3792,7 @@ try_mount_again:
>  	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
>  
>  	/* tune readahead according to rsize */
> -	cifs_sb->bdi.ra_pages = cifs_ra_pages(cifs_sb);
> +	cifs_sb->bdi.ra_pages = cifs_sb->rsize / PAGE_CACHE_SIZE;
>  
>  remote_path_check:
>  #ifdef CONFIG_CIFS_DFS_UPCALL
