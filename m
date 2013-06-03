From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v1 02/11] locks: make generic_add_lease and
 generic_delete_lease static
Date: Mon, 3 Jun 2013 17:53:54 -0400
Message-ID: <20130603215353.GE2109@fieldses.org>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
 <1370056054-25449-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370056054-25449-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 31, 2013 at 11:07:25PM -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

ACK.--b.

> ---
>  fs/locks.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 7a02064..e3140b8 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1337,7 +1337,7 @@ int fcntl_getlease(struct file *filp)
>  	return type;
>  }
>  
> -int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
> +static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
>  {
>  	struct file_lock *fl, **before, **my_before = NULL, *lease;
>  	struct dentry *dentry = filp->f_path.dentry;
> @@ -1402,7 +1402,7 @@ out:
>  	return error;
>  }
>  
> -int generic_delete_lease(struct file *filp, struct file_lock **flp)
> +static int generic_delete_lease(struct file *filp, struct file_lock **flp)
>  {
>  	struct file_lock *fl, **before;
>  	struct dentry *dentry = filp->f_path.dentry;
> -- 
> 1.7.1
> 
