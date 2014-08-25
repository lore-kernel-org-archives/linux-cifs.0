From: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH 09/10] locks: move freeing of leases outside of i_lock
Date: Sun, 24 Aug 2014 21:35:02 -0400
Message-ID: <20140824213502.4cab1ba3@synchrony.poochiereds.net>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
	<1408804878-1331-10-git-send-email-jlayton@primarydata.com>
	<20140824160804.GH15908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140824160804.GH15908-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 24 Aug 2014 09:08:04 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Sat, Aug 23, 2014 at 10:41:17AM -0400, Jeff Layton wrote:
> > There was only one place where we still could free a file_lock while
> > holding the i_lock -- lease_modify. Add a new list_head argument to the
> > lm_change operation, pass in a private list when calling it, and fix
> > those callers to dispose of the list once the lock has been dropped.
> 
> Why do we care about locks held when simply freeing a piece of memory?
> 

That's all that's done now, but locks_free_lock can call
fl->fl_release_private. Currently, no filesystem sets that for leases,
but while we're in here we might as well make it possible for that to
block for all lock types since that's simpler than having different
rules for them.

It doesn't really cost us anything other than a bit of list
manipulation and reduces contention on the i_lock slightly.

-- 
Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
