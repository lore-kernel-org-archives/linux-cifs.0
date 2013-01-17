From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 4/4] fs: remove obsolete simple_strto<foo>
Date: Thu, 17 Jan 2013 15:39:54 -0800
Message-ID: <20130117153954.e36a474b.akpm@linux-foundation.org>
References: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
	Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
	Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Christine Caulfield <ccaulfie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	David Teigland <teigland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>,
	Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Abhijit Pawar <abhi.c.pawar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354881319-23585-1-git-send-email-abhi.c.pawar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  7 Dec 2012 17:25:19 +0530
Abhijit Pawar <abhi.c.pawar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
> 

The XFS part (or something like it) has been applied.

>
> ...
>
> --- a/fs/9p/v9fs.c
> +++ b/fs/9p/v9fs.c
> @@ -112,7 +112,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
>  	substring_t args[MAX_OPT_ARGS];
>  	char *p;
>  	int option = 0;
> -	char *s, *e;
> +	char *s;
>  	int ret = 0;
>  
>  	/* setup defaults */
> @@ -249,8 +249,8 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
>  				v9ses->flags |= V9FS_ACCESS_CLIENT;
>  			} else {
>  				v9ses->flags |= V9FS_ACCESS_SINGLE;
> -				v9ses->uid = simple_strtoul(s, &e, 10);
> -				if (*e != '\0') {
> +				ret = kstrtouint(s, 10, &v9ses->uid);
> +				if (ret) {
>  					ret = -EINVAL;
>  					pr_info("Unknown access argument %s\n",
>  						s);

Here we should propagate the kstrtouint() errno back to the caller
rather than overwriting it with EINVAL.

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5b3429a..95d9e09 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1335,7 +1335,11 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>  		sizestr = devstr + 1;
>  		*devstr = '\0';
>  		devstr = vol_args->name;
> -		devid = simple_strtoull(devstr, &end, 10);
> +		ret = kstrtoull(devstr, 10, &devid);
> +		if (ret) {
> +			ret = -EINVAL;
> +			goto out_free;
> +		}

Propagate the kstrtoull errno back to the caller.

>  		printk(KERN_INFO "btrfs: resizing devid %llu\n",
>  		       (unsigned long long)devid);
>  	}
>
> ...
>
> @@ -609,8 +610,9 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
>  	}
>  	/* else we have a number */
>  
> -	flags = simple_strtoul(flags_string, NULL, 0);
> -
> +	rc = kstrtouint(flags_string, 0, &flags);
> +	if (rc)
> +		return -EINVAL;

Here we should propagate the return value.

But if this error path is taken, we might already have altered
global_secflags.  Perhaps that change should be undone.  Or, better,
check the string before starting to change state.

>  	cFYI(1, "sec flags 0x%x", flags);
>  
>  	if (flags <= 0)  {
> --- a/fs/dlm/config.c
> +++ b/fs/dlm/config.c
> @@ -156,11 +156,14 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
>  			   const char *buf, size_t len)
>  {
>  	unsigned int x;
> +	int rc;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	x = simple_strtoul(buf, NULL, 0);
> +	rc = kstrtouint(buf, 0, &x);
> +	if (rc)
> +		return -EINVAL;

Propagate it back.

>  	if (check_zero && !x)
>  		return -EINVAL;
> @@ -729,7 +732,10 @@ static ssize_t comm_nodeid_read(struct dlm_comm *cm, char *buf)
>  static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
>  				 size_t len)
>  {
> -	cm->nodeid = simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &cm->nodeid);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	return len;
>  }
>  
> @@ -741,7 +747,10 @@ static ssize_t comm_local_read(struct dlm_comm *cm, char *buf)
>  static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
>  				size_t len)
>  {
> -	cm->local= simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &cm->local);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	if (cm->local && !local_comm)
>  		local_comm = cm;
>  	return len;
> @@ -845,7 +854,10 @@ static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
>  				 size_t len)
>  {
>  	uint32_t seq = 0;
> -	nd->nodeid = simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &nd->nodeid);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	dlm_comm_seq(nd->nodeid, &seq);
>  	nd->comm_seq = seq;
>  	return len;
> @@ -859,7 +871,10 @@ static ssize_t node_weight_read(struct dlm_node *nd, char *buf)
>  static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
>  				 size_t len)
>  {
> -	nd->weight = simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &nd->weight);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	return len;
>  }
>  
> diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
> index 2e99fb0..e83abfb 100644
> --- a/fs/dlm/lockspace.c
> +++ b/fs/dlm/lockspace.c
> @@ -35,7 +35,10 @@ static struct task_struct *	scand_task;
>  static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
>  {
>  	ssize_t ret = len;
> -	int n = simple_strtol(buf, NULL, 0);
> +	int n, rc;
> +	rc = kstrtoint(buf, 0, &n);
> +	if (rc)
> +		return -EINVAL;

etcetera

>  	ls = dlm_find_lockspace_local(ls->ls_local_handle);
>  	if (!ls)
>
> ...
>
