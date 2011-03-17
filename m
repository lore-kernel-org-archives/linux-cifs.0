From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier
 structures)
Date: Thu, 17 Mar 2011 10:47:11 -0400
Message-ID: <20110317144711.GA19592@infradead.org>
References: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
 <20110317143514.GB3295@infradead.org>
 <AANLkTin-YWNgvdNpZQx28hXR9ZdhQciCLgEhUwqZf3-C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTin-YWNgvdNpZQx28hXR9ZdhQciCLgEhUwqZf3-C-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 17, 2011 at 09:41:34AM -0500, Steve French wrote:
> On Thu, Mar 17, 2011 at 9:35 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > Btw, what branch are these commits for? ?I dearly hope you're not trying
> > to push half-assed code to mainline. ?Please do your development on a
> > branch first, and once there is a useable implementation it can be
> > reviewed and synced over. ?Take a look at pnfs development for example.
> 
> We have an implementation that was in the test tree for a year, went
> through 3 test events that is being ported.  I don't think it will
> take more than a week or so to get enough of it in.  Unless it gets
> upstream, it is not going to get much wider review than from the
> original group (Pavel, Jeremy etc).  Note that all code is marked as
> "broken" and the majority in distinct c files - this is not that
> different than pNFS, which only recently got usable in mainline but
> was checked in many releases back.

Sorry, but that's bullshit.  Please stop merging that crap in it's
current state, and prepare a full patch series for review.  Please
include some broader list like linux-fsdevel when posting the full
series.
