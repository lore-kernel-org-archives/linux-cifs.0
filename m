From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Mon, 05 Sep 2011 08:39:01 -0400
Message-ID: <1315226341.22877.170.camel@pico.li.ssimo.org>
References: <240043230.241860.1314945935851.JavaMail.ngmail@webmail12.arcor-online.net>
	 <20110902064023.51a3c945@tlielax.poochiereds.net>
	 <20110902124740.GB15846@cobija.connexer.com> <4E61D9A5.6010303@arcor.de>
	 <20110905092634.GA28829@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Simon Brenner <brennersimon-KvP5wT2u2U0@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110905092634.GA28829-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-09-05 at 11:26 +0200, sean finney wrote:
> Hi,
> 
> On Sat, Sep 03, 2011 at 09:39:17AM +0200, Simon Brenner wrote:
> > So how is it when, say, a router manufacturer has its own
> > (proprietary + closed) file format for the firmware files. Within
> > the firmware he uses several GPL projects (v2 or v3) as well as some
> > own closed projects which he doesn't want to be seen by everyone.
> 
> Again IANAL, this is my own interpretation (and apologies to the list
> regulars if my de-lurking is causing annoyance, if so just msg me
> privately and I'll shut up).
> 
> > Would the manufacturer then have to provide all source code, even
> > its own which he originally wanted to keep private?
> 
> I would say yes, because the resulting firmware file is not a mere
> aggregation but rather a derived work containing the GPL'd components.  I
> believe at least one major retail brand of consumer network products
> has been successfully taken to court along these lines.

This is probably just BS.

How is a firmware file different from a tar file or a .iso image ?

Please let's stop making things up.

> > How about the toolchain he used to compile all the stuff?
> 
> This gets into really murky waters...  see the definition of
> "Corresponding Source" and what it entails.  If you have custom
> proprietary build tools used to generate the image, there's a pretty
> strong argument that they are included in the derived work and thus
> subject to its terms.

Not murky at all.
The distributor has to provide the tools necessary to build and change
the program. It does not need to provide source code form unrelated apps
ion the same firmware just their binaries at most. If the firmware can
be simply unpacked and repacked they probably do not need to provide
anything more than GPL components sources and build scripts and
instructions on how to unpack/replace/repack the firmware image.

> Generally it *doesn't* apply to any build tools and system libraries
> that you'd normally find on the OS used to build the work, or could
> find freely available.  But it's a very blurry line, and one that
> I'd just as soon avoid...

You certainly do not need to provide compiler and libraires used by the
compiler, but makefiles or similar scripts needed for build should be
provided.

> > If every user has to be able to rebuild his own firmware files then
> > the manufacturer would be forced to open all code.
> 
> I would say so.

And you'd be TOTALLY wrong, unless the firware is a single program where
everything is linked together. If, as it almost certainly is, it is just
some sort of squashfs or similar that is unpacked at boot by the kernel,
then you have mere aggregation.

> The entire point of the GPL is that an end user who
> receives GPL'd software should be able to take it apart, modify it,
> put it back together, and run the result.

Yes, but only what is part of the GPLed program.

>   If the firmware is the
> product you are giving them, and it contains GPL software inside it,
> then I think it does apply to the whole.

No, it depends on what the firwamre is. A distribution ISO file doesn't
cause all the software to become magically GPLed.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
