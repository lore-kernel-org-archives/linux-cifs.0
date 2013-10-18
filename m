From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Source for winucase.c
Date: Fri, 18 Oct 2013 10:58:15 -0400
Message-ID: <20131018105815.255d39e3@tlielax.poochiereds.net>
References: <1382058269.2794.11.camel@deadeye.wl.decadent.org.uk>
	<20131018064305.57a78574@tlielax.poochiereds.net>
	<1382105498.2370.55.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	"Bradley M. Kuhn" <bkuhn-vUrtt4mpz3m9WkS168ly19i2O/JbrIOy@public.gmane.org>
To: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382105498.2370.55.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 18 Oct 2013 10:11:38 -0400
Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Fri, 2013-10-18 at 06:43 -0400, Jeff Layton wrote:
> > On Fri, 18 Oct 2013 02:04:29 +0100
> > Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> wrote:
> > 
> > > fs/cifs/winucase.c is commented as:
> > > 
> > >  * The const tables in this file were converted from the following info
> > >  * provided by Microsoft:
> > >  *
> > >  * 3.1.5.3 Mapping UTF-16 Strings to Upper Case:
> > >  *
> > >  * http://msdn.microsoft.com/en-us/library/hh877830.aspx
> > >  * http://www.microsoft.com/en-us/download/details.aspx?displaylang=en&id=10921
> > >  *
> > >  * In particular, the table in "Windows 8 Upper Case Mapping Table.txt" was
> > >  * post-processed using the winucase_convert.pl script.
> > > 
> > > Isn't "Windows 8 Upper Case Mapping Table.txt" then the preferred form
> > > for modification of the tables?  In which case, it should be included in
> > > the kernel sources.
> > > 
> > > Also, shouldn't this file acknowledge Microsoft's copyright, if it's a
> > > derivative work of their file?
> > > 
> > > Ben.
> > > 
> > 
> > (cc'ing samba-technical and Bradley Kuhn in the hopes that he can help
> > clarify)
> > 
> > Good questions. I'm not certain on either point. When I queried the MS
> > folks about the licensing on that file, they said:
> > 
> > "I discovered the content you used is in fact referenced by the
> >  MS-UCODEREF document, in section 3.1.5.2.3.1   Windows Sorting Weight
> >  Table. I discussed with the appropriate folks here, and for use in
> >  Samba it's certainly covered under Samba's existing PFIF license."
> > 
> > Bradley, any thoughts as to Ben's questions?
> > 
> 
> The file from Microsoft in fact does not contain a Copyright Header.
> 

Right, that was the main reason I asked MS about the license on that
file. Since they said the facts within it were covered by the PFIF, I
decided to roll with that.

This is somewhat similar to what we do with protocol level constants
that we have to send on the wire. Granted there that we usually do copy
them by hand.

> IANAL, but a collection of facts is hardly copyrightable material
> anyway.
> 
> These tables cannot be arbitrarily changed some even if they were
> copyrightable they would probably fall under various fair use or
> interoperability exceptions in different laws at least in US and EU.
> 

I think the main question at this point is whether the post-processing
of that file into a set of C tables construes a derived work. I tend to
think not, since it is just a collection of facts, but maybe it is...

I suppose we could copy the info from MS-UCODEREF by hand if it's a
problem, but....ick.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
