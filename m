From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 08:29:51 -0800
Message-ID: <20120216162951.GF24986@google.com>
References: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
 <20120216102728.230b99ba@poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Chris Ball <cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>,
	David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linux-pm mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120216102728.230b99ba-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On Thu, Feb 16, 2012 at 10:27:28AM -0500, Jeff Layton wrote:
> These should  all be freezable and we might even be able to get away
> with WQ_UNBOUND for some of these.

In general, I would recommend specifying as few special attribute as
possible.  If WQ_UNBOUND is necessary (large amount of CPU cycles
consumed, extremely high concurrency), sure, but I think we're
generally better off using as default attributes as possible.  It just
makes things much easier later when we need to implement new features
or update the implementation.

> I think we put most of these in system_nrt_wq because Tejun put an
> earlier job into that queue when he converted it from slow_work and we
> just cargo-cult copied that...
> 
> I'll spend some time looking at this in the next day or two, but I
> suspect that the right answer is to just move these off of the "public"
> workqueues altogether.

If freezing & nrt is everything necessary, just create
system_nrt_freezable_wq and use that.

Thanks.

-- 
tejun
