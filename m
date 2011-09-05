From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Mon, 05 Sep 2011 13:50:42 -0400
Message-ID: <1315245042.22877.183.camel@pico.li.ssimo.org>
References: <20110905161012.GA30136@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Simon Brenner <brennersimon-KvP5wT2u2U0@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110905161012.GA30136-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-09-05 at 18:10 +0200, sean finney wrote:
> > > > If every user has to be able to rebuild his own firmware files
> then
> > > > the manufacturer would be forced to open all code.
> > > 
> > > I would say so.
> > 
> > And you'd be TOTALLY wrong, unless the firware is a single program
> where
> > everything is linked together. If, as it almost certainly is, it is
> just
> > some sort of squashfs or similar that is unpacked at boot by the
> kernel,
> > then you have mere aggregation.
> 
> That's kind of what I was getting at above.  Please reconsider the
> context of that answer, that as a given, the user needs to be able to
> disassemble/reassemble the firmware and it was in question whether
> that
> was even possible.  if you can't reliably take the image apart and put
> it back together, what's the difference between that and an ELF file
> with a really large .rodata section?

Ok this would be a case of combining all the code in a single
executable, which makes a big difference. Unfortunately you are still
totally wrong wrt the question made.

Nobody can force you to disclose code, if the firmware is not found
compliant then the first option is to simply stop distributing the code
completely. Of course if you want to keep distributing the code then you
have to come in compliance, either by removing and replacing the GPLed
portions (v2 or v3 makes no difference wrt linking executables) or by
compatibly licensing your own code and distributing its source under the
terms of the GPL.

I find it hard to think that something including the linux kernel (which
is the only reason to use cifs-utils) is transformed into a single
executable all linked together. But I guess everything is possible.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
