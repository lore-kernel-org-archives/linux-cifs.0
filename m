From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 11:37:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202161131420.1268-100000@iolanthe.rowland.org>
References: <20120216162529.GD24986@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Chris Ball <cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>,
	David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linux-pm mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, <keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120216162529.GD24986-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Feb 2012, Tejun Heo wrote:

> Hello, (cc'ing Rafael and Jens)
> 
> On Thu, Feb 16, 2012 at 09:41:34AM -0500, Alan Stern wrote:
> > My question to all of you: Should system_nrt_wq be made freezable, or 
> > should I create a new workqueue that is both freezable and 
> > non-reentrant?  And if I do, which of the usages above should be 
> > converted to the new workqueue?
> 
> Let's make it explicit that the wq is freezable.  I'm a bit
> uncomfortable with the way it's headed.  What we should be doing is
> implementing plugging of request queue for all regular requests while
> suspend is in progress and then annotate the ones which should go
> through.  We're trying to do it the other way around.

Um.  I don't think I can audit all the calls in the kernel that submit
block requests and determine which ones need to be allowed while a
system sleep is in progress.

> Also, in general, I don't think using freezing widely for kernel
> threads / wqs is a good idea.  Plugging device access at subsystem
> layer should cover most cases and we have notifiers to implement such
> support and to handle special cases.  There are even code paths which
> try to determine whether system went through PM operation by looking
> at whether %current went through the freezer.  IMHO, we'll be better
> off with removing freezer support for kthreads.  :(

Well, there are some dedicated threads that exist for no other purpose
than to do I/O to devices and to handle hotplug/unplug events.  I don't
see any reason not allow such threads to be freezable.  It's a quick, 
convenient method for getting them out of the way.

More general-purpose threads, like the async_schedule reservoir and 
workqueue threads, are a different story.

Alan Stern
