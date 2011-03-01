From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 15:48:07 -0500
Message-ID: <20110301204807.GF20599@fieldses.org>
References: <20110228235910.GD14237@fieldses.org>
 <AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
 <20110301032808.GA17725@fieldses.org>
 <20110301180700.GC20599@fieldses.org>
 <AANLkTikNH0ujA-qram1=1JEqJ7DH6dLRR723YZgJde1+@mail.gmail.com>
 <20110301192102.GD20599@fieldses.org>
 <20110301150949.6ca5b880@tlielax.poochiereds.net>
 <AANLkTikc2GAe1+jRyuJGEJ8i5EBtoO-dayocL2yATMWQ@mail.gmail.com>
 <20110301203445.GE20599@fieldses.org>
 <AANLkTikaGd6EzNBWkYrJM3upP4fnBUx4p7c_29cLReLX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikaGd6EzNBWkYrJM3upP4fnBUx4p7c_29cLReLX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 01, 2011 at 02:38:27PM -0600, Steve French wrote:
> On Tue, Mar 1, 2011 at 2:34 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org=
> wrote:
> > On Tue, Mar 01, 2011 at 02:11:32PM -0600, Steve French wrote:
> >> I vaguely remember that the same problem can occur with nfsd on a
> >> local file system
> >
> > Not true; as I've said, exportable local filesystems know how to lo=
ok up
> > a file on disk by filehandle.
> >
> >> and that nfs clients have to be able to recover from
> >> ESTALE (e.g. lookup/delete/create/lookup would fail with ESTALE
> >> otherwise).
> >
> > It is true, however, that there are some *other* cases when a serve=
r can
> > return ESTALE. =C2=A0In those cases (such as the one Peter Staubach=
 discusses
> > in more detail at http://lwn.net/Articles/272684/) there may be som=
e
> > recovery that a client might reasonably attempt.
> >
> > Alas, no client can be expected to recover from ESTALE errors on an
> > opened file--those will just be passed on to the application.
>=20
> If this is v4 (only) wouldn't we always have an open->dentry in cache=
?

That's correct, but only as long as the server is running.  We need
reboot recovery to work as well.

Also:

	- NFSv4 uptake is still rather small as far as I know, so the v3
	  behavior is important
	- We don't currently have any way to export cifs as v4 only.

--b.
