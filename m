From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 16:35:51 +0000
Message-ID: <2050.1329410151@redhat.com>
References: <20120216162634.GE24986@google.com> <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org> <32626.1329405744@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Chris Ball <cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>,
	David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
	Linux-pm mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120216162634.GE24986-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> > > My question to all of you: Should system_nrt_wq be made freezable, or 
> > > should I create a new workqueue that is both freezable and 
> > > non-reentrant?  And if I do, which of the usages above should be 
> > > converted to the new workqueue?
> > 
> > As far as keys are concerned, it's only for garbage collection purposes, so
> > having it freezable shouldn't be a problem.
> 
> If freezing is not strictly necessary, please avoid marking it as
> freezable.

?

The key_garbage_collector work item is marked neither freezable nor
unfreezable that I can see.

David
