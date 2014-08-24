From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/10] locks: close potential race in lease_get_mtime
Date: Sun, 24 Aug 2014 08:48:17 -0700
Message-ID: <20140824154817.GA15908@infradead.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-2-git-send-email-jlayton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408804878-1331-2-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Aug 23, 2014 at 10:41:09AM -0400, Jeff Layton wrote:
> lease_get_mtime is called without the i_lock held, so there's no
> guarantee about the stability of the list. Between the time when we
> assign "flock" and then dereference it to check whether it's a lease
> and for write, the lease could be freed.
> 
> Ensure that that doesn't occur by taking the i_lock before trying
> to check the lease.

Looks good.  Also looks way cleaner than before by being just a tad more
verbose..

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
