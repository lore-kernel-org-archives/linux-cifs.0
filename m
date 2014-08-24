From: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH 06/10] locks: plumb an "aux" pointer into the setlease
 routines
Date: Sun, 24 Aug 2014 06:08:01 -0400
Message-ID: <20140824060801.5402880c@synchrony.poochiereds.net>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-7-git-send-email-jlayton@primarydata.com>
 <20140824013305.GB21609@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140824013305.GB21609-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 23 Aug 2014 18:33:05 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Sat, Aug 23, 2014 at 10:41:14AM -0400, Jeff Layton wrote:
> > In later patches, we're going to add a new lock_manager_operation to
> > finish setting up the lease while still holding the i_lock.  To do
> > this, we'll need to pass a little bit of info in the fcntl setlease
> > case (primarily an fasync structure). Plumb the extra pointer into
> > there in advance of that.
> > 
> > We declare this pointer as a void ** to make it clear that this is
> > auxillary info, and that the caller isn't required to set this unless
> > the lm_setup specifically requires it.
> 
> Can you just return -EEXIST if reusing an existing one and make it a
> normal private pointer a we use elsewhere?
> 

That sounds a little confusing...

We have two pointers we pass down to generic_setlease: the file_lock
itself and with this patch, the "aux" pointer. We can end up using
either, neither or both during a call to generic_setlease.

A simple error code can't properly indicate which of the two pointers
got used. It might be clearer to turn the file_lock into a normal
pointer and return -EEXIST if we reused it, but leave aux as a double
pointer.


> Btw, two things I came up with to make the lease filesystem API nicer:
> 
>  - bypass vfs_setlease/->setlease for deletes and just call directly
>    into the lease code.  no one does anything special for it (except
>    cifs, which forgets about it), and then rename the method to
>    ->add_lease.
>  - provide a no_add_lease for nfs/gfs to centralize the no-op version
>    in a single place (similar no no_lseek).
> 
> Otherwise this looks really nice.


Both of those sound good. I'll plan to roll those changes in with the
next iteration.

Thanks!
-- 
Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
