From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: monotonic time for mount.cifs timeouts
Date: Tue, 24 Aug 2010 13:34:18 -0400
Message-ID: <20100824133418.6319ead7@tlielax.poochiereds.net>
References: <E1OnwAo-008Rzd-Bd@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?Qmr2cm4=?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1OnwAo-008Rzd-Bd-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Aug 2010 18:16:19 +0200
Bj=F6rn JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:

> Hi,
>=20
> attached are patches to spot the clock_gettime function and to use th=
at and the
> monotonic clock for timeout handling if possible.
>=20
> If there are no objections, can you please apply them, Jeff?
>=20
> Thanks
> Bj=F6rn

Sure, they look reasonable to me. If no one chimes in the next couple o=
f
days, I'll plan to apply them.

Thanks for the patches,
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
