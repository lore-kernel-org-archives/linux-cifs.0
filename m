From: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Assume passwords are encoded according to
 iocharset
Date: Mon, 11 Apr 2011 21:17:37 +0200
Message-ID: <20110411191737.GA18433@osk.mine.nu>
References: <20110327125648.GA3621@osk.mine.nu>
 <BANLkTimEhsjo2vfSE1w-D888hWn72H7Y3A@mail.gmail.com>
 <20110411191431.GA18160@osk.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110411191431.GA18160-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Monday, April 11, 2011 at 21:31, Oskar Liljeblad wrote:
> On Monday, April 11, 2011 at 12:59, Shirish Pargaonkar wrote:
> > > Modify cifs to assume that the supplied password is encoded accor=
ding to
> > > iocharset. =A0Before this patch passwords would be treated as raw=
 8-bit data,
> > > which made authentication with Unicode passwords impossible (at l=
east
> > > passwords with characters > 0xFF).
> > >
> > > The previous code would as a side effect accept passwords encoded=
 with ISO
> > > 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Softwar=
e which
> > > relies on that will no longer support password chars > 0x7F unles=
s it also
> > > uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about th=
e encoding so
> > > it will work as expected.)
> > >
> > > Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
> [..]
> > With this patch, I am unable to mount a share if user's password ha=
ppens to
> > contain characters like $ e.g. aa$a.
> > A Windows client can.
>=20
> Hmm, strange, I was not able to reproduce this problem with domain ac=
counts
> on Windows 2008 R2.  For me $ worked. (That is with locale utf-8 at l=
east.)

I'm sorry, please disregard my comment. I tested with the wrong kernel.
I will try again.

Regards,

Oskar
