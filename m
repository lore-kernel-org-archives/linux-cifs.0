From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Mon, 5 Sep 2011 18:10:12 +0200
Message-ID: <20110905161012.GA30136@cobija.connexer.com>
References: <1315226544.22877.174.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Simon Brenner <brennersimon-KvP5wT2u2U0@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1315226544.22877.174.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
 <1315226341.22877.170.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On Mon, Sep 05, 2011 at 08:39:01AM -0400, simo wrote:
> On Mon, 2011-09-05 at 11:26 +0200, sean finney wrote:
> > Hi,
> > 
> > On Sat, Sep 03, 2011 at 09:39:17AM +0200, Simon Brenner wrote:
> > > So how is it when, say, a router manufacturer has its own
> > > (proprietary + closed) file format for the firmware files. Within
> > > the firmware he uses several GPL projects (v2 or v3) as well as some
> > > own closed projects which he doesn't want to be seen by everyone.
> > 
> > Again IANAL, this is my own interpretation (and apologies to the list
> > regulars if my de-lurking is causing annoyance, if so just msg me
> > privately and I'll shut up).
> > 
> > > Would the manufacturer then have to provide all source code, even
> > > its own which he originally wanted to keep private?
> > 
> > I would say yes, because the resulting firmware file is not a mere
> > aggregation but rather a derived work containing the GPL'd components.  I
> > believe at least one major retail brand of consumer network products
> > has been successfully taken to court along these lines.
> 
> This is probably just BS.
> 
> How is a firmware file different from a tar file or a .iso image ?
> 
> Please let's stop making things up.

With all due respect I am not.  If the firmware image could be construed
as some form of media (filesystem image, file archive, etc), then yes,
there is some room for argument -- I mentioned this point in my first
response, even, but the response from the OP seemed to hint that this
was not the case.  If it is not some readily accessible form of media/fs,
for which tools and/or documentation are not freely available to
pack/unpack the image, I think your argument becomes much less tangible.

> Not murky at all.
> The distributor has to provide the tools necessary to build and change
> the program. It does not need to provide source code form unrelated apps
> ion the same firmware just their binaries at most. If the firmware can
> be simply unpacked and repacked they probably do not need to provide
> anything more than GPL components sources and build scripts and
> instructions on how to unpack/replace/repack the firmware image.

Your argument has merit iff the firmware can be considered a form
of media to contain a "mere aggregation".  Otherwise, I don't see how
to consider the firmware as anything other than a single executable with
a lot of embedded data.  We may agree to disagree here, and it wouldn't
be the first time this argument has been had...

> > Generally it *doesn't* apply to any build tools and system libraries
> > that you'd normally find on the OS used to build the work, or could
> > find freely available.  But it's a very blurry line, and one that
> > I'd just as soon avoid...
> 
> You certainly do not need to provide compiler and libraires used by the
> compiler, but makefiles or similar scripts needed for build should be
> provided.

What I was getting at with the "Murky" comment above was that in some cases
building firmware is more than just running source code through a standard
compiler chain + archiving tools.  Depending on the context/platform it
might be necessary to use proprietary (licensed and expensive) tools to
generate either intermediate and/or final output in the process, or even
the entire compiler chain might be proprietary.  Sometimes even the output
format itself is proprietary and laden with IP/NDA's etc.  And that's
where stuff gets a bit sketchy with regards to the toolchain requirements,
at least IMHO.

> > > If every user has to be able to rebuild his own firmware files then
> > > the manufacturer would be forced to open all code.
> > 
> > I would say so.
> 
> And you'd be TOTALLY wrong, unless the firware is a single program where
> everything is linked together. If, as it almost certainly is, it is just
> some sort of squashfs or similar that is unpacked at boot by the kernel,
> then you have mere aggregation.

That's kind of what I was getting at above.  Please reconsider the
context of that answer, that as a given, the user needs to be able to
disassemble/reassemble the firmware and it was in question whether that
was even possible.  if you can't reliably take the image apart and put
it back together, what's the difference between that and an ELF file
with a really large .rodata section?

> >   If the firmware is the
> > product you are giving them, and it contains GPL software inside it,
> > then I think it does apply to the whole.
> 
> No, it depends on what the firwamre is. A distribution ISO file doesn't
> cause all the software to become magically GPLed.

Agreed there.  But a distribution ISO file comes in a well recognized and
standardized media format for which numerous tools and documentation exist.
The above was said under a different premise -- if the user could creatively
use dd/squashfs-tools and a cross-compiler to reproduce a firmware image,
then obviously there's much more strength to the "mere aggregate" argument.

On Mon, Sep 05, 2011 at 08:42:24AM -0400, simo wrote:
> On Mon, 2011-09-05 at 12:27 +0200, brennersimon-KvP5wT2u2U0@public.gmane.org wrote:
> > > > Would the manufacturer then have to provide all source code, even
> > > > its own which he originally wanted to keep private?
> > > 
> > > I would say yes, because the resulting firmware file is not a mere
> > > aggregation but rather a derived work containing the GPL'd components.
> > 
> > Does that apply to GPLv3 software as well as GPLv2 software within the firmware?
> 
> If it were true yes, it would apply equally, GPLv3 is a copyleft license
> just like GPLv2 and the 2 are *obviously* very close.

And JFTR I agree with just about everything in the subsequent mail (including
that it's probably a good idea to chat with a GPL-savvy lawyer).



	sean
