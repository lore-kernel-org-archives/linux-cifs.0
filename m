From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Mon, 5 Sep 2011 18:20:20 +0200
Message-ID: <20110905162019.GB30136@cobija.connexer.com>
References: <498443694.299882.1315230630011.JavaMail.ngmail@webmail12.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: brennersimon-KvP5wT2u2U0@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <498443694.299882.1315230630011.JavaMail.ngmail-hrWuGRo80rQUOsVZMWqyoH/75uz/KqYjrE5yTffgRl4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On Mon, Sep 05, 2011 at 03:50:30PM +0200, brennersimon-KvP5wT2u2U0@public.gmane.org wrote:
> > > The entire point of the GPL is that an end user who
> > > receives GPL'd software should be able to take it apart, modify it,
> > > put it back together, and run the result.
> > 
> > Yes, but only what is part of the GPLed program.
> 
> Does that mean a separation of GPL programs and proprietary programs would provide a clean solution? Perhaps one GPL firmware image and one proprietary firmware image?

If you put the kernel, busybox, and other GPL'd stuff on one image, and
had some kind of "add-on" image, I don't think there'd be much question about
it, as long as you could still adhere to the GPL with the former.  But as
simo pointed out, depending on the technicalities of how you are 
generating/packing your firmware files it might not be necessary either.

But once again IANAL, and if you're making an actual thing that you plan on
selling to someone, it's probably prudent to talk to someone who is :)

> > > I read about 'tivoization' and I guess that's the thing I'm actually
> > > referring to, isn't it? And as far as I read that's a point which was
> > > enforced especially with GPLv3.
> > 
> > Are you signing the firmware in a way that is checked at boot and won't
> > allow the boot to proceed if the signatures do not check ?
> > 
> > If so then there is a difference between GPLv2 and GPLv3 but has nothing
> > to do with aggregation, nor with release the source code of other
> > unrelated components.
> 
> Interesting part. Let's say yes, how differ v2 and v3 if I signed my firmware so that none other than my own firmware was bootable?

In that case I think you'd be violating only the spirit of v2 (i.e. techincally
in compliance, but not exactly making end-users who care about the GPL
happy).  But with v3 you would probably have GPL compliance issues since
that was one of the express concerns it attempts to address -- unless
you also provided a way for the end users to create their own signed firmwares,
in which case it'd be a non-issue.


	sean
