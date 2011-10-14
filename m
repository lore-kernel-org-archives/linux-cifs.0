From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: Pavel's Lock cleanup
Date: Fri, 14 Oct 2011 19:29:39 -0400
Message-ID: <20111014232939.GA15881@fieldses.org>
References: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
 <20111014211214.GA15319@fieldses.org>
 <CAH2r5msGZjEZP=BVWQedO80+W2yPJPvtd0+i5dAS9X0nq6=9kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msGZjEZP=BVWQedO80+W2yPJPvtd0+i5dAS9X0nq6=9kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 14, 2011 at 05:38:59PM -0500, Steve French wrote:
> On Fri, Oct 14, 2011 at 4:12 PM, J. Bruce Fields <bfields-uC3wQj2KruMpug/h7KTFAQ@public.gmane.org=
g> wrote:
> > On Thu, Oct 13, 2011 at 05:23:52PM -0500, Steve French wrote:
> >> I like Pavel's lock cleanup (1st patch of series) so far, am
> >> continuing to review it, but I also noticed a few things that we n=
eed
> >> to do in the future. This line of code:
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (flock->fl_flags & FL_LEASE)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Lease on=
 file - not implemented yet");
> >>
> >> reminded me that we should check if we need to implement this (in =
cifs
> >> we can return yes if we have a lease already (oplock), but in smb2=
=2E1
> >> and later we can request a lease or an upgrade to an existing one,=
 on
> >> the fly).
> >
> > And you'll also need to make sure you call break_lease() when you f=
ind
> > out it's broken.
> >
> > A description of the smb (1/2/2.1) oplock and lease semantics would=
 be
> > useful--I'm curious whether they're really a good fit for the linux
> > vfs's lease semantics.
>=20
> I can probably dig up the exact references in MS-CIFS.pdf and MS-SMB2=
=2Epdf
> but basically SMB2 (original dialect) and CIFS have similar semantics=
 (and
> Samba's need to implement CIFS oplocks drove the original implementat=
ion
> of leases in the kernel, although it is requested at open time via a =
flag,
> not after open as a handle based call).  The problem comes in with sm=
b2.1
> which adds the ability to reaquire leases (which may be ok) and upgra=
de
> leases (from read only to readwrite) and to reuse an existing lease
> (so the 2nd open from the same client doesn't have to break oplock)
> which helps Linux which has a common cache manager.
>=20
> smb2.2 adds the ability to do directory leases (to cache directory
> entries)

I know all that, but what I'd like to know would be:
	- What's the difference between a lease and an oplock?
	- What does each give you the right to cache?  For example:
		- The Samba folks tell me, not filename, only data:
			http://marc.info/?l=3Dsamba-technical&m=3D131688944117833&w=3D2
		- Based on these patches, I'm assuming they also give
		  the right to cache locks.
	  But it would be nice to have references (either
	  specifications, or test results) to support those statements.

Microsoft's documents don't spell this out, as far as I can tell.

--b.
