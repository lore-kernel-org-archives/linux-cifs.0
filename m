From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Sun, 5 Dec 2010 21:30:43 -0500
Message-ID: <20101205213043.4902d164@corrin.poochiereds.net>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 5 Dec 2010 20:16:46 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sun, Dec 5, 2010 at 8:06 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > On Sun, 5 Dec 2010 19:42:30 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > > On Sat, Dec 4, 2010 at 2:12 AM, Volker Lendecke
> > > <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>wrote:
> > >
> > > > On Fri, Dec 03, 2010 at 09:28:11PM -0500, Jeff Layton wrote:
> > > > > So, what does this mean for CIFS clients? I believe that the best
> > > > > behavior for the client is to *never* time out an individual request,
> > > > > aside from SMB echoes.
> > > >
> > > > I like this concept.
> > > >
> > > >
> > > That will break apps that can't take ctl-c though ...
> > >
> >
> > How will waiting indefinitely for a response break applications?
> > Returning an error just because the server is slow seems far more
> > likely to break applications.
> >
> > Now, in the (IMO unlikely) event that a server is responding to
> > echoes but not other calls, you'd have an that application will hang
> > until someone kills it. I think that's acceptable however:
> >
> > It's an unlikely situation, and anyone who has a client faced with it
> > has a way to recover from the hang. They can kill the application. The
> > server in this case would be clearly broken however.
> >
> >
> I am more worried about firewall rule changes and similar events
> than about broken servers - but the idea of waiting forever on stat
> to a server that is never going to respond seems odd.
> 

But we won't wait forever...only if the server is still responding to
echoes. A server that responds to echoes but not other requests seems
very, very odd.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
