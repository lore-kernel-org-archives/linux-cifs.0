From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS mount fails if I ctrl-c a long-running find process (Linux
 mounting Windows share)
Date: Fri, 28 Dec 2012 22:01:50 -0500
Message-ID: <20121228220150.72686551@corrin.poochiereds.net>
References: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	<20121219090322.3999f995@tlielax.poochiereds.net>
	<1355944553.61735.YahooMailNeo@web160303.mail.bf1.yahoo.com>
	<1355945432.81847.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	<20121220093806.537c2496@corrin.poochiereds.net>
	<20121223091034.5e313ee1@tlielax.poochiereds.net>
	<20121224091421.63d0df23@tlielax.poochiereds.net>
	<1356740676.4446.21.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Tim Perry <tim.perry-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	John Darrah <xyllyx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 695492-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356740676.4446.21.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 29 Dec 2012 01:24:36 +0100
Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> wrote:

> On Mon, 2012-12-24 at 09:14 -0500, Jeff Layton wrote:
> > On Sun, 23 Dec 2012 09:10:34 -0500
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> [...]
> > > I had a look at the code today and suspect that I know what the problem
> > > is. When the kernel goes to send a request, it first signs it and then
> > > bumps the sequence numbers that it tracks. If the request doesn't
> > > actually make it out onto the wire, like when the task catches a
> > > signal, those sequence numbers remain high even though the request
> > > didn't go out.
> > > 
> > > Here's an untested patch that might help tell whether this is the
> > > case. You may want to try it and see if it does. Note that this fix is
> > > a bit of a kludge and is not suitable for merging!
> > > 
> > > A better fix would involve changing when the sequence number gets
> > > bumped in the first place. If this patch seems to help things, then
> > > I'll look at coding up that up.
> [...]
> > I was able to reproduce this, and I don't think the above patch will
> > fix it (at least not completely). The problem seems to be that the NT
> > cancel command is screwing up the sequence numbers. We'll have to do
> > some research to figure out why that's occurring.
> 
> Jeff, we got a bug report in Debian which seems to be the same problem:
> <http://bugs.debian.org/695492>.  Please cc John Darrah and the bug
> address as above.
> 
> Ben.
> 

You may want to try this patch. It seems to fix the problem for me, but
I think there is probably some more work to do in this area.

http://www.spinics.net/lists/linux-cifs/msg07576.html

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
