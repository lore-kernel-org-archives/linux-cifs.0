From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: allow cifs_max_pending to be readable under
 /sys/module/cifs/parameters
Date: Thu, 20 Oct 2011 10:27:43 -0400
Message-ID: <20111020102743.63a36104@barsoom.rdu.redhat.com>
References: <1319052676-11587-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mtAwXFETw8AR9Bw=ra0MZ04=SYgPvX_2NC9q0V+ZTyjnA@mail.gmail.com>
	<20111019205607.3770a921@corrin.poochiereds.net>
	<CAH2r5mubpD3ZbKeZru=ttG+ihaw5vcok_jc_N4zRYsoV7JsBBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mubpD3ZbKeZru=ttG+ihaw5vcok_jc_N4zRYsoV7JsBBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Oct 2011 20:32:47 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 19, 2011 at 7:56 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Wed, 19 Oct 2011 16:31:15 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> With the proposed cifs.ko fix to honor maxmpx, cifs_max_pending
> >> because a limit when the server (as Windows often is) has more tha=
n 50
> >> maxmpxct in its registry. =C2=A0 Does anyone mind if I update the =
maximum
> >> to one or two hundred? (after the mpx fix is in)?
> >>
> >
> > Ummm...what proposed fix? I've not seen that patch cross the list. =
Did
> > I miss it?
>=20
> well ... you asked me to rename one of the flags so I am pretty sure =
you saw
> it.  I plan to repost it - although it is a little less important now
> that we realize
> that the Windows problem can occur even when mpx is 50 (still it is g=
ood
> to honor the server limit).
>=20

Ahh ok. That wasn't sent to the list so I didn't know you were
"officially" proposing that patch. I'd suggest you do so to ensure that
others who weren't on the cc list have a chance to review it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
