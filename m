From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 08:45:16 -0800
Message-ID: <20120216164516.GJ24986@google.com>
References: <20120216162529.GD24986@google.com>
 <Pine.LNX.4.44L0.1202161131420.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Chris Ball <cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>,
	David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linux-pm mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202161131420.1268-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On Thu, Feb 16, 2012 at 11:37:33AM -0500, Alan Stern wrote:
> Um.  I don't think I can audit all the calls in the kernel that submit
> block requests and determine which ones need to be allowed while a
> system sleep is in progress.

??? we need to do that anyway and the ones which should go through are
much smaller than the ones which shouldn't go through.

> > Also, in general, I don't think using freezing widely for kernel
> > threads / wqs is a good idea.  Plugging device access at subsystem
> > layer should cover most cases and we have notifiers to implement such
> > support and to handle special cases.  There are even code paths which
> > try to determine whether system went through PM operation by looking
> > at whether %current went through the freezer.  IMHO, we'll be better
> > off with removing freezer support for kthreads.  :(
> 
> Well, there are some dedicated threads that exist for no other purpose
> than to do I/O to devices and to handle hotplug/unplug events.  I don't
> see any reason not allow such threads to be freezable.  It's a quick, 
> convenient method for getting them out of the way.

Well, it's convenient to use incorrectly.  If you look at most of
freezable kthreads, they're sadly broken.  I mean, a lot of kthread
users don't even get kthread_should_stop() right.  With freezable()
thrown into the mix, it seems hopeless.  With wq, it's better as
freezing is handled by wq proper.  Even then, I don't know.  It just
seems to lead people to think "ooh, I marked it freezable so I don't
have to think about synchronization across PM events.  Freezer will
magically solve this for me!".  :(

Thanks.

-- 
tejun
