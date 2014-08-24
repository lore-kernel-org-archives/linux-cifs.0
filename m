From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 07/10] locks: define a lm_setup handler for leases
Date: Sun, 24 Aug 2014 08:58:58 -0700
Message-ID: <20140824155858.GF15908@infradead.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-8-git-send-email-jlayton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408804878-1331-8-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I like this change a lot!  But one caveat:

> +	/*
> +	 * Despite the fact that it's an int return function, __f_setown never
> +	 * returns an error. Just ignore any error return here, but spew a
> +	 * WARN_ON_ONCE in case this ever changes.
> +	 */
> +	WARN_ON_ONCE(__f_setown(filp, task_pid(current), PIDTYPE_PID, 0));

I don't think this is a good idea.  The errors in __f_setown come from
the security modules, and they could change easily.  If you can convince
the LSM people to change their file_set_fowner routine to return void
we could change __f_setown to return void as well and be done with it,
but without that this looks too dangerous.
