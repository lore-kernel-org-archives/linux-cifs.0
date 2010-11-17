From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 17 Nov 2010 13:39:19 -0500
Message-ID: <20101117133919.07f9f0db@tlielax.poochiereds.net>
References: <1290018214-9415-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290018214-9415-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 17 Nov 2010 23:53:34 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Currently, the attribute cache timeout for CIFS is hardcoded to 1 second. This
> means that the client might have to issue a QPATHINFO/QFILEINFO call every 1
> second to verify if something has changes, which seems too expensive. On the
> other hand, if the timeout is hardcoded to a higher value, workloads that
> expect strict cache coherency might see unexpected results.
> 
> Making attribute cache timeout as a tunable will allow us to make a tradeoff
> between performance and cache metadata correctness depending on the
> application/workload needs.
> 
> Add 'actimeo' tunable that can be used to tune the attribute cache timeout.
> The default timeout is set to 1 second.
> 
> Also, display actimeo option value in /proc/mounts.
> 
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |    1 +
>  fs/cifs/cifsglob.h   |    5 +++++
>  fs/cifs/connect.c    |   10 ++++++++++
>  fs/cifs/inode.c      |    6 +++---
>  5 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index e9a393c..efd2d73 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -48,6 +48,7 @@ struct cifs_sb_info {
>  	struct nls_table *local_nls;
>  	unsigned int rsize;
>  	unsigned int wsize;
> +	unsigned int actimeo;
>  	atomic_t active;
>  	uid_t	mnt_uid;
>  	gid_t	mnt_gid;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 9c37897..13be23d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -461,6 +461,7 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
>  
>  	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
>  	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
> +	seq_printf(s, ",actimeo=%d", cifs_sb->actimeo);
>  
>  	return 0;
>  }
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b577bf0..037f793 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -45,6 +45,11 @@
>  #define CIFS_MIN_RCV_POOL 4
>  
>  /*
> + * default attribute cache timeout (seconds)
> + */
> +#define CIFS_DEF_ACTIMEO (1)
> +
> +/*
>   * MAX_REQ is the maximum number of requests that WE will send
>   * on one socket concurrently. It also matches the most common
>   * value of max multiplex returned by servers.  We may
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 251a17c..7f92328 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -103,6 +103,7 @@ struct smb_vol {
>  	bool multiuser:1;
>  	unsigned int rsize;
>  	unsigned int wsize;
> +	unsigned int actimeo; /* attribute cache timeout */
>  	bool sockopt_tcp_nodelay:1;
>  	unsigned short int port;
>  	char *prepath;
> @@ -1214,6 +1215,10 @@ cifs_parse_mount_options(char *options, const char *devname,
>  					printk(KERN_WARNING "CIFS: server net"
>  					"biosname longer than 15 truncated.\n");
>  			}
> +		} else if (strnicmp(data, "actimeo", 7) == 0) {
> +			if (value && *value)
> +				vol->actimeo =
> +					simple_strtoul(value, &value, 0);
>  		} else if (strnicmp(data, "credentials", 4) == 0) {
>  			/* ignore */
>  		} else if (strnicmp(data, "version", 3) == 0) {
> @@ -2566,6 +2571,11 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
>  	cFYI(1, "file mode: 0x%x  dir mode: 0x%x",
>  		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
>  
> +	if (pvolume_info->actimeo)
> +		cifs_sb->actimeo = pvolume_info->actimeo;
> +	else /* default */
> +		cifs_sb->actimeo = CIFS_DEF_ACTIMEO;
> +
>  	if (pvolume_info->noperm)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
>  	if (pvolume_info->setuids)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ff7d299..f30700d 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1648,6 +1648,7 @@ static bool
>  cifs_inode_needs_reval(struct inode *inode)
>  {
>  	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  
>  	if (cifs_i->clientCanCacheRead)
>  		return false;
> @@ -1658,12 +1659,11 @@ cifs_inode_needs_reval(struct inode *inode)
>  	if (cifs_i->time == 0)
>  		return true;
>  
> -	/* FIXME: the actimeo should be tunable */
> -	if (time_after_eq(jiffies, cifs_i->time + HZ))
> +	if (time_after_eq(jiffies, cifs_i->time + (cifs_sb->actimeo * HZ)))

	Problem:

	Suppose (cifs_i->time + (cifs_sb->actimeo * HZ)) carries you
	past two sign bit changes. At that point, it may look like
	the resulting time is in the past, not the future.

	You actually do need to impose a limit here. I suggest looking
	very closely at time_before/time_after macros. It'll also be
	easier to deal storing actimeo in terms of jiffies instead of
	seconds.

	Finally, this value needs to be displayed in /proc/mounts.

>  		return true;
>  
>  	/* hardlinked files w/ noserverino get "special" treatment */
> -	if (!(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
> +	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
>  	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
>  		return true;
>  


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
