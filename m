From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Thu, 13 Feb 2014 06:37:38 -0500
Message-ID: <20140213063738.1b345466@tlielax.poochiereds.net>
References: <52F9EDA5.1020004@assyoma.it>
	<20140211103302.6d74b90d@tlielax.poochiereds.net>
	<52FA46D5.8020904@assyoma.it>
	<20140211124536.5fdcb56f@tlielax.poochiereds.net>
	<CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	James McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Feb 2014 12:01:50 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Feb 11, 2014 at 11:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Tue, 11 Feb 2014 16:50:45 +0100
> > Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org> wrote:
> >
> >> Hi Jeff,
> >> I had the same idea.
> >>
> >> When mounting the CIFS directory, the problematic installations return 0
> >> links for both dirs and files. On the other hand, the stock CentOS
> >> installation return 1 or more links.
> >>
> >> It puzzled me. Two questions:
> >> - anyone know the rationale behind this?
> >
> > The rationale is that windows servers always send a NumberOfLinks value
> > of '0' for directories. We have a hack in place that went in around a
> > year ago to work around that for (arguably broken) applications that
> > try to infer something about an inode that has a zero st_nlink value.
> >
> >> - how it is possible to work-around that with an unpatched kernel?
> >>
> >
> > There is no workaround. Either fix the application such that it doesn't
> > care or patch the kernel. I'll cc Jim since he did a fair bit of
> > looking at this several months ago.
> >
> > In truth though, resharing a cifs mount is probably not a great
> > solution. It sounds like the kind of setup that's going to end up being
> > fraught with cache coherency problems...
> 
> Problem is that there are situations where it is required (usually
> due to legacy dialect support or due to legacy authentication
> support).
> 
> I am not as worried about the cache coherence issues if
> we are mounting "cache=none" and we can even set
> actimeo lower if needed
> 

Using cache=none sort of defeats the purpose. After all Gionatan said
that he was doing this specifically to use fscache, and that won't work
with cache=none.

But, lets leave that aside for a moment and consider whether this could
work at all. Assume we have samba set up re-share a cifs mount:

Client sends an open to samba and requests an oplock. Samba then opens
a file on the cifs mount, and does not request an oplock (because of
cache=none). We then attempt to set a lease, which will fail because we
don't have an oplock. Now you're no better off (and probably worse off)
since you have zero caching going on and are having to bounce each
request through an extra hop.

So, suppose you disable "kernel oplocks" in samba in order to get samba
to hand out L2 oplocks in this situation. Another client then comes
along on the main (primary) server and changes a file. Samba is then
not aware of that change and hilarity (aka data corruption) ensues.

I just don't see how re-sharing a cifs mount is a good idea, unless you
are absolutely certain that the data you're resharing won't ever
change. If that's the case, then you're almost certainly better off
keeping a local copy on the samba server and sharing that out.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
