From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Mon, 5 Sep 2011 11:26:34 +0200
Message-ID: <20110905092634.GA28829@cobija.connexer.com>
References: <240043230.241860.1314945935851.JavaMail.ngmail@webmail12.arcor-online.net>
 <20110902064023.51a3c945@tlielax.poochiereds.net>
 <20110902124740.GB15846@cobija.connexer.com>
 <4E61D9A5.6010303@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simon Brenner <brennersimon-KvP5wT2u2U0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E61D9A5.6010303-KvP5wT2u2U0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On Sat, Sep 03, 2011 at 09:39:17AM +0200, Simon Brenner wrote:
> So how is it when, say, a router manufacturer has its own
> (proprietary + closed) file format for the firmware files. Within
> the firmware he uses several GPL projects (v2 or v3) as well as some
> own closed projects which he doesn't want to be seen by everyone.

Again IANAL, this is my own interpretation (and apologies to the list
regulars if my de-lurking is causing annoyance, if so just msg me
privately and I'll shut up).

> Would the manufacturer then have to provide all source code, even
> its own which he originally wanted to keep private?

I would say yes, because the resulting firmware file is not a mere
aggregation but rather a derived work containing the GPL'd components.  I
believe at least one major retail brand of consumer network products
has been successfully taken to court along these lines.

> How about the toolchain he used to compile all the stuff?

This gets into really murky waters...  see the definition of
"Corresponding Source" and what it entails.  If you have custom
proprietary build tools used to generate the image, there's a pretty
strong argument that they are included in the derived work and thus
subject to its terms.

Generally it *doesn't* apply to any build tools and system libraries
that you'd normally find on the OS used to build the work, or could
find freely available.  But it's a very blurry line, and one that
I'd just as soon avoid...

> If every user has to be able to rebuild his own firmware files then
> the manufacturer would be forced to open all code.

I would say so.  The entire point of the GPL is that an end user who
receives GPL'd software should be able to take it apart, modify it,
put it back together, and run the result.  If the firmware is the
product you are giving them, and it contains GPL software inside it,
then I think it does apply to the whole.


	sean
