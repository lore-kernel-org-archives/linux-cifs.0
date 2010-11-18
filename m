From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v2] cifs: add attribute cache timeout (actimeo) tunable
Date: Thu, 18 Nov 2010 08:03:37 -0500
Message-ID: <20101118080337.7e8cb2d7@barsoom.rdu.redhat.com>
References: <1290083423-14912-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290083423-14912-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 18 Nov 2010 18:00:23 +0530
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
> Changes since last post:
> 
> 	- fix an issue with signed overflow when using time_after()
> 	- cache timeout stored internally in terms of jiffies for easier
> 	  handling
> 	- update README about 'actimeo' option  
> 
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/README       |    9 +++++++++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |    2 ++
>  fs/cifs/cifsglob.h   |    5 +++++
>  fs/cifs/connect.c    |   10 ++++++++++
>  fs/cifs/inode.c      |    7 ++++---
>  6 files changed, 31 insertions(+), 3 deletions(-)
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
> index 9c37897..80fc16a 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -461,6 +461,8 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
>  
>  	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
>  	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
> +	/* convert actimeo and display it in seconds */
> +	seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
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
> index 251a17c..dfe1279 100644
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
> @@ -1214,6 +1215,10 @@ cifs_parse_mount_options(char *options, const char *devname,
>  					printk(KERN_WARNING "CIFS: server net"
>  					"biosname longer than 15 truncated.\n");
>  			}
> +		} else if (strnicmp(data, "actimeo", 7) == 0) {
> +			if (value && *value)
> +				vol->actimeo =
> +					simple_strtoul(value, &value, 0) * HZ;
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
> +		cifs_sb->actimeo = CIFS_DEF_ACTIMEO * HZ;
> +

So if I set actimeo=0 (which is rather common with this option on NFS),
then I'll actually get actimeo=1? That doesn't seem correct to
me.

Also, you still have the problem that an actimeo that's too big can
cause the value to flip its sign bit twice. Consider this case on a
32-bit arch:

jiffies = 0x7ffffffe (big positive number when cast to signed value)
actimeo = 0xffffffff (maximum unsigned value)
---------------------
sum     = 0x17ffffffd

but...because it's 32-bit, the leading 1 will get chopped off and the
result will actually be:

    0x7ffffffd

That value is less than jiffies, and it'll appear to be in the past
rather than the future. Thus is the bane of the time_* macros. They
only work across a single sign-bit flip. Again, I think you need to
limit the value of the actimeo option such that that can't happen here.


>  	if (pvolume_info->noperm)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
>  	if (pvolume_info->setuids)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ff7d299..7571fbd 100644
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
> @@ -1658,12 +1659,12 @@ cifs_inode_needs_reval(struct inode *inode)
>  	if (cifs_i->time == 0)
>  		return true;
>  
> -	/* FIXME: the actimeo should be tunable */
> -	if (time_after_eq(jiffies, cifs_i->time + HZ))
> +	if (!time_in_range_open(jiffies, cifs_i->time,
> +			       cifs_i->time + cifs_sb->actimeo))
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
