From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 11:55:08 -0500
Message-ID: <20101204115508.1c0038fd@corrin.poochiereds.net>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org>
	<E1POnFL-00BKg9-JW@intern.SerNet.DE>
	<20101204064452.46ac24c7@tlielax.poochiereds.net>
	<AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6@mail.gmail.com>
	<20101204080942.42be63da@tlielax.poochiereds.net>
	<AANLkTim45G=pLwznde8S_b=FGCnYyO29Tnokghs0qZ-y@mail.gmail.com>
	<20101204092240.4724e1ff@corrin.poochiereds.net>
	<AANLkTimN0F5KyM7r1+k3Y3Ki+kwQukAr4uXzRJuMVZtX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimN0F5KyM7r1+k3Y3Ki+kwQukAr4uXzRJuMVZtX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 4 Dec 2010 08:46:53 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> Jeff, I am not sure.  Basically I am coming from here:
> 
> I have a bug open, where an SMB server when slow to respond
> (for a cifs client), if cifs client reconnects, causes data corruption
> on the server. If left to its own, responses from server eventually
> make through (without any intervention) and tests pass.
> 

I have a very similar bug open and that's what prompted me to go down
this road. You may want to test the patchset I proposed for cifs
against your reproducer.

> If an SMB server is unresponsive, how do we know it will respond to
> a reconnect or a reconnect will help? 
>
> I do not know enough about
> SMB servers to describe an unresponsive server i.e. how and when
> it came to be unresponsive, how it handles transport layer then,
> whether it corrects itself or how to correct it, how it handles
> underlying physical file sytem etc..

A reconnect may not help. The problem we have today however is that
Linux CIFS client is too cavalier with reconnects. It reconnects
the socket any time that a call has taken longer than an arbitrary
timeout. It tries to deal with that by varying timeouts with the
type of call, but I think that's a broken model that fails in many
situations.

It's impossible to predict how long it'll take the server to service a
particular call, as we can never be sure what the load on the
server and underlying storage is. A QPathInfo call may take just as
long as a write past EOF if the storage is being hammered.

The scheme I'm proposing makes the assumption that even when the server
is loaded, it'll still be able to respond to an echo. That may also
fail in certain situations, but empirical evidence has shown that
that it's generally true. This scheme won't fix every failure scenario,
but it should help the vast majority of situations where the server is
simply being slow to respond to a particular call.

I'm not opposed to what you're proposing, but it seems like a more
radical step than what I have proposed. We'd need to understand what
recourse the user would have in practice and what the behavior will be
in various failure scenarios. Leaving the processes hung and logging a
message when the server isn't responding isn't going to be very helpful
if there's nothing that can be done about it.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
