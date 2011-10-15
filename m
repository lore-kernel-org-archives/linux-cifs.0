From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: Pavel's Lock cleanup
Date: Sat, 15 Oct 2011 10:50:55 -0400
Message-ID: <20111015145055.GA26001@fieldses.org>
References: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
 <20111014211214.GA15319@fieldses.org>
 <CAH2r5msGZjEZP=BVWQedO80+W2yPJPvtd0+i5dAS9X0nq6=9kw@mail.gmail.com>
 <20111014232939.GA15881@fieldses.org>
 <CAH2r5mvd+N_F897=jAjc7x=186YAHwe=jwQDD=JnOu8YFmu3qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mvd+N_F897=jAjc7x=186YAHwe=jwQDD=JnOu8YFmu3qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 14, 2011 at 07:02:55PM -0500, Steve French wrote:
> On Fri, Oct 14, 2011 at 6:29 PM, J. Bruce Fields <bfields-uC3wQj2KruMpug/h7KTFAQ@public.gmane.org=
g> wrote:
> > On Fri, Oct 14, 2011 at 05:38:59PM -0500, Steve French wrote:
> >> On Fri, Oct 14, 2011 at 4:12 PM, J. Bruce Fields <bfields@fieldses=
=2Eorg> wrote:
> >> > On Thu, Oct 13, 2011 at 05:23:52PM -0500, Steve French wrote:
> >> >> I like Pavel's lock cleanup (1st patch of series) so far, am
> >> >> continuing to review it, but I also noticed a few things that w=
e need
> >> >> to do in the future. This line of code:
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 if (flock->fl_flags & FL_LEASE)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Lease=
 on file - not implemented yet");
> >> >>
> >> >> reminded me that we should check if we need to implement this (=
in cifs
> >> >> we can return yes if we have a lease already (oplock), but in s=
mb2.1
> >> >> and later we can request a lease or an upgrade to an existing o=
ne, on
> >> >> the fly).
> >> >
> >> > And you'll also need to make sure you call break_lease() when yo=
u find
> >> > out it's broken.
> >> >
> >> > A description of the smb (1/2/2.1) oplock and lease semantics wo=
uld be
> >> > useful--I'm curious whether they're really a good fit for the li=
nux
> >> > vfs's lease semantics.
> >>
> >> I can probably dig up the exact references in MS-CIFS.pdf and MS-S=
MB2.pdf
> >> but basically SMB2 (original dialect) and CIFS have similar semant=
ics (and
> >> Samba's need to implement CIFS oplocks drove the original implemen=
tation
> >> of leases in the kernel, although it is requested at open time via=
 a flag,
> >> not after open as a handle based call). =C2=A0The problem comes in=
 with smb2.1
> >> which adds the ability to reaquire leases (which may be ok) and up=
grade
> >> leases (from read only to readwrite) and to reuse an existing leas=
e
> >> (so the 2nd open from the same client doesn't have to break oplock=
)
> >> which helps Linux which has a common cache manager.
> >>
> >> smb2.2 adds the ability to do directory leases (to cache directory
> >> entries)
> >
> > I know all that, but what I'd like to know would be:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0- What's the difference between a lease =
and an oplock?
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0- What does each give you the right to c=
ache? =C2=A0For example:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- The Samba =
folks tell me, not filename, only data:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0http://marc.info/?l=3Dsamba-technical&m=3D131688944117833=
&w=3D2
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- Based on t=
hese patches, I'm assuming they also give
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the r=
ight to cache locks.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0But it would be nice to have refe=
rences (either
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0specifications, or test results) =
to support those statements.
>=20
> Interesting questions.  The MS-FSA document (in section 3.1.4.12)

Woah, I totally missed that section on my previous reading.  Thanks!

> seems to agree with that
> (that querying attributes, and some metadata, timestamps, does not
> break oplock):
>=20
> (see http://msdn.microsoft.com/en-us/library/860b1516-c452-47b4-bdbc-=
625d344e2041.aspx)
>=20
> "If OpParams.DesiredAccess contains no flags other than FILE_READ_ATT=
RIBUTES,
> FILE_WRITE_ATTRIBUTES, or SYNCHRONIZE, the algorithm returns at this =
point."
> (ie doesn't break oplock if these are the only flags set).
>=20
>=20
> On oplock vs. leases (in MS usage, oplock is the older term).  An opl=
ock was -
> 1) requested on open (presumably what the "op" part of the name meant=
)
> 2) had only a few types:  "batch" (could cache data, and cache open/c=
lose)
> and "read write" (could cache read or writes of data) and later a
> "read only" type was
> added (allowing you to cache writes)
>=20
> Leases (a later term in Microsoft documents) had more function (they
> included for
> example a "key" which identifies the owner of the lease).

OK, thanks again, that's helpful.

--b.
