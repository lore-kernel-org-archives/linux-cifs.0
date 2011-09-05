From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Mon, 05 Sep 2011 08:42:24 -0400
Message-ID: <1315226544.22877.174.camel@pico.li.ssimo.org>
References: <901868733.695320.1315218442622.JavaMail.ngmail@webmail08.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: brennersimon-KvP5wT2u2U0@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <901868733.695320.1315218442622.JavaMail.ngmail-n1zztEYQUKrHtOu4I4oYOX/75uz/KqYjrE5yTffgRl4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-09-05 at 12:27 +0200, brennersimon-KvP5wT2u2U0@public.gmane.org wrote:
> > > Would the manufacturer then have to provide all source code, even
> > > its own which he originally wanted to keep private?
> > 
> > I would say yes, because the resulting firmware file is not a mere
> > aggregation but rather a derived work containing the GPL'd components.
> 
> Does that apply to GPLv3 software as well as GPLv2 software within the firmware?

If it were true yes, it would apply equally, GPLv3 is a copyleft license
just like GPLv2 and the 2 are *obviously* very close.

> > > If every user has to be able to rebuild his own firmware files then
> > > the manufacturer would be forced to open all code.
> > 
> > I would say so.  The entire point of the GPL is that an end user who
> > receives GPL'd software should be able to take it apart, modify it,
> > put it back together, and run the result.  If the firmware is the
> > product you are giving them, and it contains GPL software inside it,
> > then I think it does apply to the whole.
> 
> Here again the question if this applies for v3 as well as v2 licenced software?

Of course. (But I think the whole premise is false, so consult a lawyer
or an otherwise expert in licensing matters that understand the
technicalities about how your firmware is built).

> I read about 'tivoization' and I guess that's the thing I'm actually
> referring to, isn't it? And as far as I read that's a point which was
> enforced especially with GPLv3.

Are you signing the firmware in a way that is checked at boot and won't
allow the boot to proceed if the signatures do not check ?

If so then there is a difference between GPLv2 and GPLv3 but has nothing
to do with aggregation, nor with release the source code of other
unrelated components.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
