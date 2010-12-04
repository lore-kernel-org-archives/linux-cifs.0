From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 06:44:52 -0500
Message-ID: <20101204064452.46ac24c7@tlielax.poochiereds.net>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org>
	<E1POnFL-00BKg9-JW@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1POnFL-00BKg9-JW-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 4 Dec 2010 09:13:21 +0100
Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:

> On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Hertel wrote:
> > That may seem to be in the "who cares" category, since those old transports
> > are essentially dead (much more dead than NBT, or even NBF).  Unfortunately,
> > the code to handle the old transports is still there in Windows, so there
> > are behaviors -- things like the timeouts you're talking about and the weird
> > VC=0 shutdown behvior -- that exist because of these old disused transports.
> 
> VC=0, how does Windows treat this facing NAT (masquerading)
> networks? I've done tests in the past where Windows killed
> valid connections from behind a NAT box when a new client
> came in.
> 
> Volker

It seems like the best way to deal with this on the server side with
direct hosted TCP would be to treat VC=0 like any other VC number
(MS-CIFS says that this is allowed).

Ideally any new connection event from a host however should make the
server check the validity of any other connection from the same host.
That way you could release resources held by dead connections in case
the new one is a reconnect and needs to reclaim state.

The question is how to check that validity. Unfortunately, the best you
can probably do is rely on TCP keepalives.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
