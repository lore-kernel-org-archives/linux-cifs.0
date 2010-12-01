From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v5] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 1 Dec 2010 06:49:49 -0500
Message-ID: <20101201064949.3f9a42fa@tlielax.poochiereds.net>
References: <1291194748-9455-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291194748-9455-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  1 Dec 2010 14:42:28 +0530
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
> The default timeout is set to 1 second. Also, display actimeo option value in
> /proc/mounts.
> 
> It appears to me that 'actimeo' and the proposed (but not yet merged)
> 'strictcache' option cannot coexist, so care must be taken that we reset the
> other option if one of them is set.
> 
> Changes since last post:
>    - fix option parsing and handle possible values correcly
> 
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/README       |    9 +++++++++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |    2 ++
>  fs/cifs/cifsglob.h   |   10 ++++++++++
>  fs/cifs/connect.c    |   15 +++++++++++++++
>  fs/cifs/inode.c      |    7 ++++---
>  6 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index ee68d10..46af99a 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -337,6 +337,15 @@ A partial list of the supported mount options follows:
>    wsize		default write size (default 57344)
>  		maximum wsize currently allowed by CIFS is 57344 (fourteen
>  		4096 byte pages)
> +  actimeo=n	attribute cache timeout in seconds (default 1 second).
> +		After this timeout, the cifs client requests fresh attribute
> +		information from the server. This option allows to tune the
> +		attribute cache timeout to suit the workload needs. Shorter
> +		timeouts mean better the cache coherency, but increased number
> +		of calls to the server. Longer timeouts mean reduced number
> +		of calls to the server at the expense of less stricter cache
> +		coherency checks (i.e. incorrect attribute cache for a short
> +		period of time).
>    rw		mount the network share read-write (note that the
>  		server may still consider the share read-only)
>    ro		mount network share read-only
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index e9a393c..7852cd6 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -48,6 +48,7 @@ struct cifs_sb_info {
>  	struct nls_table *local_nls;
>  	unsigned int rsize;
>  	unsigned int wsize;
> +	unsigned long actimeo; /* attribute cache timeout (jiffies) */
>  	atomic_t active;
>  	uid_t	mnt_uid;
>  	gid_t	mnt_gid;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 76c8a90..56a4b75 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -463,6 +463,8 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
>  
>  	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
>  	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
> +	/* convert actimeo and display it in seconds */
> +		seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
>  
>  	return 0;
>  }
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b577bf0..94ccfac 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -45,6 +45,16 @@
>  #define CIFS_MIN_RCV_POOL 4
>  
>  /*
> + * default attribute cache timeout (jiffies)
> + */
> +#define CIFS_DEF_ACTIMEO (1 * HZ)
> +
> +/*
> + * max attribute cache timeout (jiffies) - 2^30
> + */
> +#define CIFS_MAX_ACTIMEO (1 << 30)
> +
> +/*
>   * MAX_REQ is the maximum number of requests that WE will send
>   * on one socket concurrently. It also matches the most common
>   * value of max multiplex returned by servers.  We may
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 32fa4d9..bb17ee2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -105,6 +105,7 @@ struct smb_vol {
>  	unsigned int wsize;
>  	bool sockopt_tcp_nodelay:1;
>  	unsigned short int port;
> +	unsigned long actimeo; /* attribute cache timeout (jiffies) */
>  	char *prepath;
>  	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
>  	struct nls_table *local_nls;
> @@ -840,6 +841,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  	/* default to using server inode numbers where available */
>  	vol->server_ino = 1;
>  
> +	vol->actimeo = CIFS_DEF_ACTIMEO;
> +
>  	if (!options)
>  		return 1;
>  
> @@ -1214,6 +1217,16 @@ cifs_parse_mount_options(char *options, const char *devname,
>  					printk(KERN_WARNING "CIFS: server net"
>  					"biosname longer than 15 truncated.\n");
>  			}
> +		} else if (strnicmp(data, "actimeo", 7) == 0) {
> +			if (value && *value) {
> +				vol->actimeo = HZ * simple_strtoul(value,
> +								   &value, 0);
> +				if (vol->actimeo > CIFS_MAX_ACTIMEO) {
> +					cERROR(1, "CIFS: attribute cache"
> +							"timeout too large");
> +					return 1;
> +				}
> +			}
>  		} else if (strnicmp(data, "credentials", 4) == 0) {
>  			/* ignore */
>  		} else if (strnicmp(data, "version", 3) == 0) {
> @@ -2571,6 +2584,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
>  	cFYI(1, "file mode: 0x%x  dir mode: 0x%x",
>  		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
>  
> +	cifs_sb->actimeo = pvolume_info->actimeo;
> +
>  	if (pvolume_info->noperm)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
>  	if (pvolume_info->setuids)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 28cb6e7..bb5ca48 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1653,6 +1653,7 @@ static bool
>  cifs_inode_needs_reval(struct inode *inode)
>  {
>  	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  
>  	if (cifs_i->clientCanCacheRead)
>  		return false;
> @@ -1663,12 +1664,12 @@ cifs_inode_needs_reval(struct inode *inode)
>  	if (cifs_i->time == 0)
>  		return true;
>  
> -	/* FIXME: the actimeo should be tunable */
> -	if (time_after_eq(jiffies, cifs_i->time + HZ))
> +	if (!time_in_range(jiffies, cifs_i->time,
> +				cifs_i->time + cifs_sb->actimeo))
>  		return true;
>  
>  	/* hardlinked files w/ noserverino get "special" treatment */
> -	if (!(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
> +	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
>  	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
>  		return true;
>  

Looks good to me.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
