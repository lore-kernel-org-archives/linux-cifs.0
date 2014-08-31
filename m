From: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH 08/10] locks: move i_lock acquisition into
 generic_*_lease handlers
Date: Sun, 31 Aug 2014 10:51:21 -0400
Message-ID: <20140831105121.65086ded@tlielax.poochiereds.net>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
	<1408804878-1331-9-git-send-email-jlayton@primarydata.com>
	<20140824160634.GG15908@infradead.org>
	<20140824161134.GJ15908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140824161134.GJ15908-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 24 Aug 2014 09:11:34 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Sun, Aug 24, 2014 at 09:06:34AM -0700, Christoph Hellwig wrote:
> > We really should split a lm_release from lm_change, the way it is
> > used is highly confusing.  In addition I think a lot of code
> > currently in lease_modify should move here instead, e.g. something like:
> 
> At this point the old lm_change actually becomes superflous if we
> simply disallow changes for delegation.
> 

This sounds like a reasonable change, but I think it'll be easier to
implement a little later once we've done some cleanup and change how
file locks are handled. I'm going to leave this out of this current
patchset, but I'll keep it in mind for a later cleanup.

-- 
Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
