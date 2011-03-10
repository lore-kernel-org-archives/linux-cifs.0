From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 20:30:44 -0500
Message-ID: <20110309203044.4fd0498e@corrin.poochiereds.net>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
	<20110309185427.7858c29b@corrin.poochiereds.net>
	<AANLkTi=pXHjE6tNMm0_nO=Cn3nGH8oZ6Xhm1STh8x1Xe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=pXHjE6tNMm0_nO=Cn3nGH8oZ6Xhm1STh8x1Xe-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 Mar 2011 18:33:20 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Mar 9, 2011 at 5:54 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Wed, 9 Mar 2011 16:01:30 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >>
> >> Except we don't need to wait that long with the page locked
> >> ie for a response from the cifs server (such as Samba or Windows
> >> or NetApp), just need to wait for it to get on the wire.
> >> Waiting for us to get the server response would
> >> take 10 or 100 times longer. =C2=A0 In any case we can't resend
> >> the same request to the server (the signature changes on the
> >> resend since the sequence number is incremented on every
> >> request/response so we have to recalc the checksum anyway) and
> >> cifs requests can't get lost (as with nfs over udp). =C2=A0Keeping
> >> a page locked for 10milliseconds seems like a bad idea - but
> >> it is a little more complicated to implement (for the cifs case)
> >> so that we end page writeback (for the non-WB_SYNC)
> >> as quickly as reasonably possible so we don't kill perf.
> >>
> >
> > The problem here is that the socket layer doesn't have a mechanism
> > to notify us of a TCP ACK. So, we have to wait for the next-best th=
ing
> > -- a response from the server.
>=20
> But ... we can stop writeback as soon as kernel_sendmsg returns - onc=
e
> we return from kernel_sendmsg the buffers can (and often will) be
> freed so we know those pages could not still be used by tcp  (below
> cifs) once kernel_sendmsg returns.  We can minimize the delay further
> by making sure we set TCP_NODELAY on the socket (we probably ought to
> make that the default instead of an option).
>=20

That's not correct. A return from kernel_sendmsg just means that the
data has been buffered up, not that it has been sent and acked. We
shouldn't use that as an indicator to mean that the pages no longer
need to be stable.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
