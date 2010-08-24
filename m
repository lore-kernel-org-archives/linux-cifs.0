From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: monotonic time for mount.cifs timeouts
Date: Tue, 24 Aug 2010 22:08:09 +0200
Message-ID: <E1OnznA-008e2X-Fm@intern.SerNet.DE>
References: <E1OnwAo-008Rzd-Bd@intern.SerNet.DE>
 <20100824133418.6319ead7@tlielax.poochiereds.net>
 <AANLkTi==5ZbC7Fb8wnCea50OndXZ=QwV5xPwv19K1Fyz@mail.gmail.com>
 <20100824142248.164caebe@tlielax.poochiereds.net>
 <20100824143433.5049ebe1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100824143433.5049ebe1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2010-08-24 at 14:34 -0400 Jeff Layton sent off:
> > > Any pointers to background on gettimeofday vs
> > > clock_gettime(CLOCK_MONOTONIC) and why the latter is better?
> >=20
> > IIUC, the reason for this is that gettimeofday is affected by wallc=
lock
> > changes (think NTP):
> >=20
> >        CLOCK_MONOTONIC
> >               Clock  that  cannot  be  set and represents monotonic=
 time since
> >               some unspecified starting point.
> >=20
> > ...so by preferring CLOCK_MONOTONIC, the mtab locking code isn't
> > affected by clock jumps or skew. Bjorn, is this correct?

yes, correct. In the worst case you start a timeout period while the cl=
ock is
set to 2020, during the timeout period the clock is corrected by ntpdat=
e. In
that case the timeout using the RTC clock is a bit longer than expected=
 :-)


> Correction...CLOCK_MONOTONIC is affected by adjtimex(). Over a 30s
> period though, that shouldn't mean much of a delta. The big danger is
> large clock jumps and this should take care of that.
>=20
> Out of curiousity though...did you or someone you know hit this probl=
em
> in practice, Bjorn? Or did you just notice it via inspection?

you see all kinds of strange timing effects if you have a VM that has
an unstable clock which you need to regulary adjust had via ntpdate for
example.  Programs hang or for a hile or forever in the worst case. I d=
idn't
see a problem in this particular case with mount.cifs but as this is so=
mething
which is called at boot time where ntpdate often runs at the sme time t=
o
initally hard reset the clock this is something I thought should to be
adjusted to use the monotonic clock.

Cheers
Bj=F6rn
