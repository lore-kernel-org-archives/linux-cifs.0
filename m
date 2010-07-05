From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Severe performance issue (Ubuntu 10.04 mounting an XP share)
Date: Mon, 5 Jul 2010 09:32:04 -0400
Message-ID: <20100705093204.5064b612@corrin.poochiereds.net>
References: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk@mail.gmail.com>
	<20100702141617.46ec65a6@corrin.poochiereds.net>
	<AANLkTim4xY4n2y-jE0FzCAKc6NWK6DZcHx15d2owR-wV@mail.gmail.com>
	<AANLkTimdE4q2q3w0DccJUv_steLH-0kIhgK7_jv6-IMi@mail.gmail.com>
	<20100705090425.05c3f568@corrin.poochiereds.net>
	<AANLkTimguAhx_fL-N_wsckwj4EbiIMqAi93PofSohMSo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimguAhx_fL-N_wsckwj4EbiIMqAi93PofSohMSo-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 5 Jul 2010 14:21:08 +0100
James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 5 July 2010 14:04, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > Yep, sounds like the server just isn't responding here. When that
> > happens, cifs currently forces a reconnect after the call times out.
> > Ugly and I believe unnecessary...when the server ACKs the response we
> > shouldn't force a reconnect just because the server is taking a while
> > to respond. Right now though we don't change the mid state to show that
> > the call was successfully sent, so that probably ought to be fixed so
> > we can deal with that differently.
> >
> > It's possible that by making the client wait indefinitely, the server
> > will eventually respond. It's also possible however that the server is
> > just dropping these calls on the floor for some reason and will never
> > respond. Hard to say which it is.
> >
> > Shirish was working recently on fixing the "hard" mount option for
> > cifs. It might be worth trying out his patches.
> 
> This doesn't quite feel right. I mean, why one day should an XP host
> just stop responding at random to requests? I know it's Microsoft but
> even so...
> 
> I took a look at the Event Viewer and under Security there are
> 0xC0000064 errors as smbfs makes it's accesses. Perhaps this is a
> clue?
> 
> Applying a patch might not be particularly easy as this box is stock
> Ubuntu (excepting the upstream kernel) and I don't particularly want
> to start compiling bits just to make phpunit run as it was a few days
> ago.
> 

You may be right, but unfortunately I can't do much beyond tell you
what I think is happening now. It's certainly possible there was a
change in the cifs code that is tickling a server-side bug.

I think 0xC0000064 == NO_SUCH_USER, so there may be some sort of
problem with authentication.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
