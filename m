From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Read speed
Date: Tue, 5 Feb 2013 14:23:07 -0500
Message-ID: <20130205142307.58d87a21@corrin.poochiereds.net>
References: <51105F16.8070603@kickflop.net>
	<CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ@mail.gmail.com>
	<51113D76.80609@kickflop.net>
	<20130205142058.7618dfcf@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130205142058.7618dfcf-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Feb 2013 14:20:58 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 05 Feb 2013 12:12:22 -0500
> Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org> wrote:
> 
> > Thank you for the thorough reply, Steve. It's nice to
> > read of the progress in 2012, but RHEL 6.3 and what is
> > supported there is what we have to work with. It is the
> > latest supported version, as you surely know, so it
> > seems like we'll have to wait quite awhile before
> > getting the module's read performance increases.
> > 
> > We're dealing with 9 US sites, nightly time window (which
> > we're exceeding) for transferring large amounts of data
> > over 1.5Mbps links).
> > 
> > Back to the drawing board.
> > 
> > Thanks again.
> > 
> 
> I think you're basically out of luck for now...
> 
> Long haul links are really a pessimal case for the older code that did
> synchronous reads and writes. You spend most of your time waiting
> around for the calls to go back and forth.
> 
> I believe Sachin is looking at backporting the async read patches for
> 6.5. The async write code is already in 6.3 (I think). You should
> definitely open a support case since documented customer demand helps
> us make the case for including these sorts of changes in an update.
> 

...oh, and if you haven't already, you should try to make some time for
testing a more recent kernel to ensure that this has been addressed
there. Consider doing something like installing Fedora and testing the
read speeds over your long haul link.

It wouldn't do you any good for us to backport those changes if they
don't actually help your use-case.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
