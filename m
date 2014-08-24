From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 08/10] locks: move i_lock acquisition into
 generic_*_lease handlers
Date: Sun, 24 Aug 2014 09:06:34 -0700
Message-ID: <20140824160634.GG15908@infradead.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-9-git-send-email-jlayton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408804878-1331-9-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Some comments on further work I'd like to see in this area, though:

> +	spin_lock(&inode->i_lock);
> +	time_out_leases(inode);
>  	for (before = &inode->i_flock;
>  			((fl = *before) != NULL) && IS_LEASE(fl);
>  			before = &fl->fl_next) {
>  		if (fl->fl_file != filp)
>  			continue;
> -		return fl->fl_lmops->lm_change(before, F_UNLCK);
> +		error = fl->fl_lmops->lm_change(before, F_UNLCK);
>  	}

We really should split a lm_release from lm_change, the way it is
used is highly confusing.  In addition I think a lot of code
currently in lease_modify should move here instead, e.g. something like:


	if (fl->fl_file != filp)
		continue;

	fl = *before;
	fl->fl_type = F_UNLCK;
	lease_clear_pending(fl, F_UNLCK);
	locks_wake_up_blocks(fl);
	if (fl->fl_lmops->lm_delete)
		fl->fl_lmops->lm_delete(fl);
	locks_delete_lock(before, NULL);

with lm_delete for user space leases as:

static void lease_delete(struct file_lock *fl)
{
	struct file *filp = fl->fl_file;

	f_delown(filp);
	filp->f_owner.signum = 0;
	fasync_helper(0, fl->fl_file, 0, &fl->fl_fasync);
	if (fl->fl_fasync != NULL) {
		printk(KERN_ERR "locks_delete_lock: fasync == %p\n",
				fl->fl_fasync);
		fl->fl_fasync = NULL;
	}
}

and a NULL implementation for delegations.
