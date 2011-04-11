From: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Assume passwords are encoded according to
 iocharset
Date: Mon, 11 Apr 2011 21:14:31 +0200
Message-ID: <20110411191431.GA18160@osk.mine.nu>
References: <20110327125648.GA3621@osk.mine.nu>
 <BANLkTimEhsjo2vfSE1w-D888hWn72H7Y3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimEhsjo2vfSE1w-D888hWn72H7Y3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Monday, April 11, 2011 at 12:59, Shirish Pargaonkar wrote:
> > Modify cifs to assume that the supplied password is encoded accordi=
ng to
> > iocharset. =A0Before this patch passwords would be treated as raw 8=
-bit data,
> > which made authentication with Unicode passwords impossible (at lea=
st
> > passwords with characters > 0xFF).
> >
> > The previous code would as a side effect accept passwords encoded w=
ith ISO
> > 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Software =
which
> > relies on that will no longer support password chars > 0x7F unless =
it also
> > uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about the =
encoding so
> > it will work as expected.)
> >
> > Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
[..]
> With this patch, I am unable to mount a share if user's password happ=
ens to
> contain characters like $ e.g. aa$a.
> A Windows client can.

Hmm, strange, I was not able to reproduce this problem with domain acco=
unts
on Windows 2008 R2.  For me $ worked. (That is with locale utf-8 at lea=
st.)

REgards,

OSkar
