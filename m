From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 06/10] locks: plumb an "aux" pointer into the setlease
 routines
Date: Sun, 24 Aug 2014 08:54:54 -0700
Message-ID: <20140824155454.GE15908@infradead.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-7-git-send-email-jlayton@primarydata.com>
 <20140824013305.GB21609@infradead.org>
 <20140824060801.5402880c@synchrony.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140824060801.5402880c-08S845evdOaAjSkqwZiSMmfYqLom42DlXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 24, 2014 at 06:08:01AM -0400, Jeff Layton wrote:
> > Can you just return -EEXIST if reusing an existing one and make it a
> > normal private pointer a we use elsewhere?
> > 
> 
> That sounds a little confusing...
> 
> We have two pointers we pass down to generic_setlease: the file_lock
> itself and with this patch, the "aux" pointer. We can end up using
> either, neither or both during a call to generic_setlease.
> 
> A simple error code can't properly indicate which of the two pointers
> got used. It might be clearer to turn the file_lock into a normal
> pointer and return -EEXIST if we reused it, but leave aux as a double
> pointer.

There is no way we could use a new file_lock but an existing
fasync_struct, as there won't be one on the newly allocated file_lock
structure, but otherwise you're right.

Just rename it to priv then and make me a little less grumpy ;-)
