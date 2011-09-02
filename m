From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Fri, 2 Sep 2011 14:47:40 +0200
Message-ID: <20110902124740.GB15846@cobija.connexer.com>
References: <240043230.241860.1314945935851.JavaMail.ngmail@webmail12.arcor-online.net>
 <20110902064023.51a3c945@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: brennersimon-KvP5wT2u2U0@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110902064023.51a3c945-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 02, 2011 at 06:40:23AM -0400, Jeff Layton wrote:
> That's nonsense. It's certainly fine to ship GPLv3 software alongside
> closed source code. You'll need to provide source for the GPL'ed parts
> of course, but providing a set of self-contained GPLv3 programs
> shouldn't force a vendor to open anything else.

I will echo Jeff's "you should talk to a lawyer about this", and IANAL,
but to share some of my own experiences on the matter from having to
deal with this myself:

A lot of how the GPL applies to your own software depends on how you
distribute the binary form, and whether this combined non-GPL+GPL
product would be viewed as a "derivative work" or a "mere aggregation".

That's to say that if you are distributing a single installable
firmware file for your router, and it contains GPL'd software, you would
arguably need to provide source for the entire work generating the
firmware file.  And this isn't specific to v3 of the GPL either, AFAIK,
it's kind of the point of the license to begin with.  

Similarly, an application that links against a GPL'd work is generally
considered to be a derived work (since the resulting application contains
portions of the GPL'd work), and thus the GPL would apply to the whole.
I'm not sure the linking issue has been tried in court but I do think that
the previous issue has been successfully argued.

If on the other hand you have something a bit more modular, where the GPL'd
component (or conversely the proprietary component) was not included in
the firmware binary but was added/removed through some additional medium
(i.e. packages from a cd-rom or download site), then you'd have a pretty
strong argument for the "mere aggregation" status.  Possibly also if you
could show that the resulting firmware image was more like a medium for
distribution (i.e. tarball or disk image) rather than software, but that's
a really slippery slope and I don't know how well received that would be.


	sean
