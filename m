From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: monotonic time for mount.cifs timeouts
Date: Tue, 24 Aug 2010 19:30:25 -0400
Message-ID: <20100824193025.24b0f8c4@corrin.poochiereds.net>
References: <E1OnwAo-008Rzd-Bd@intern.SerNet.DE>
	<20100824133418.6319ead7@tlielax.poochiereds.net>
	<AANLkTi==5ZbC7Fb8wnCea50OndXZ=QwV5xPwv19K1Fyz@mail.gmail.com>
	<20100824142248.164caebe@tlielax.poochiereds.net>
	<20100824143433.5049ebe1@tlielax.poochiereds.net>
	<E1OnznA-008e2X-Fm@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?Qmr2cm4=?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1OnznA-008e2X-Fm-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Aug 2010 22:08:09 +0200
Bj=F6rn JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:

> On 2010-08-24 at 14:34 -0400 Jeff Layton sent off:
> > > > Any pointers to background on gettimeofday vs
> > > > clock_gettime(CLOCK_MONOTONIC) and why the latter is better?
> > >=20
> > > IIUC, the reason for this is that gettimeofday is affected by wal=
lclock
> > > changes (think NTP):
> > >=20
> > >        CLOCK_MONOTONIC
> > >               Clock  that  cannot  be  set and represents monoton=
ic time since
> > >               some unspecified starting point.
> > >=20
> > > ...so by preferring CLOCK_MONOTONIC, the mtab locking code isn't
> > > affected by clock jumps or skew. Bjorn, is this correct?
>=20
> yes, correct. In the worst case you start a timeout period while the =
clock is
> set to 2020, during the timeout period the clock is corrected by ntpd=
ate. In
> that case the timeout using the RTC clock is a bit longer than expect=
ed :-)
>=20
>=20
> > Correction...CLOCK_MONOTONIC is affected by adjtimex(). Over a 30s
> > period though, that shouldn't mean much of a delta. The big danger =
is
> > large clock jumps and this should take care of that.
> >=20
> > Out of curiousity though...did you or someone you know hit this pro=
blem
> > in practice, Bjorn? Or did you just notice it via inspection?
>=20
> you see all kinds of strange timing effects if you have a VM that has
> an unstable clock which you need to regulary adjust had via ntpdate f=
or
> example.  Programs hang or for a hile or forever in the worst case. I=
 didn't
> see a problem in this particular case with mount.cifs but as this is =
something
> which is called at boot time where ntpdate often runs at the sme time=
 to
> initally hard reset the clock this is something I thought should to b=
e
> adjusted to use the monotonic clock.
>=20

Ok, thanks for the clarification. Committed...

This should make the 4.7 release.

Thanks!
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
