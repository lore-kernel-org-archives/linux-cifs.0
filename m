From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier
 structures)
Date: Thu, 17 Mar 2011 11:04:06 -0400
Message-ID: <20110317110406.06388256@barsoom.rdu.redhat.com>
References: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
	<20110317143514.GB3295@infradead.org>
	<AANLkTin-YWNgvdNpZQx28hXR9ZdhQciCLgEhUwqZf3-C@mail.gmail.com>
	<20110317104734.534a2ee4@barsoom.rdu.redhat.com>
	<AANLkTikfxS=5E2QvSS6V-52cdjPKOKN2kd_PBQJnTSbo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikfxS=5E2QvSS6V-52cdjPKOKN2kd_PBQJnTSbo-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 17 Mar 2011 09:54:48 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Mar 17, 2011 at 9:47 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Thu, 17 Mar 2011 09:41:34 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Thu, Mar 17, 2011 at 9:35 AM, Christoph Hellwig <hch@infradead.=
org> wrote:
> >> > Btw, what branch are these commits for? =A0I dearly hope you're =
not trying
> >> > to push half-assed code to mainline. =A0Please do your developme=
nt on a
> >> > branch first, and once there is a useable implementation it can =
be
> >> > reviewed and synced over. =A0Take a look at pnfs development for=
 example.
> >>
> >> We have an implementation that was in the test tree for a year, we=
nt
> >> through 3 test events that is being ported. =A0I don't think it wi=
ll
> >> take more than a week or so to get enough of it in. =A0Unless it g=
ets
> >> upstream, it is not going to get much wider review than from the
> >> original group (Pavel, Jeremy etc). =A0Note that all code is marke=
d as
> >> "broken" and the majority in distinct c files - this is not that
> >> different than pNFS, which only recently got usable in mainline bu=
t
> >> was checked in many releases back.
> >>
> >
> > I agree with Christoph here. If the code is marked "broken" then
> > merging it seems premature. I'd like to see the majority of this co=
de
> > in a branch that we can test before it goes in anywhere.
> >
> > The exception would be targeted patches that prepare the existing
> > code to work with the new SMB2 code. Those can be reviewed and we c=
an
> > should be able to take those prior to merging the smb2 code wholesa=
le.
>=20
> The code to prepare for SMB2 should be mostly in place in
> tree now:
> - error mapping
> - transport
> - mount
> - stats
>=20
> .  The sendrcv2 routine was the last part of that and
> was waiting on the bigendian change.   I can defer
> all inode/file/address routines if you prefer until they are reviewed
> together, but the existing version in smb2.git could be used
> as a base depending on how much commonality people prefer.
>=20
>=20
> We have had over a year, including work by 4 developers in a distinct
> tree and got little meaningful feeback on features though until
> recently when it started showing up in cifs-2.6.git  In over a year,
> the mainline code diverged in multiple trivial ways that made the por=
t harder
> because the code was not visible to those outside the small number
> of developers who understand smb2.
>=20

One of the stated goals here is to minimize disruption to the existing
cifs codebase. The best way to do that is to break out the changes
needed to the existing codebase into a separate set of patches and post
those for review. The endianness change for the smb_buf_length is a
good example of this sort of change. Once those changes have reviewed
and merged, then we can start discussing how to merge the rest of the
SMB2 support.

I really don't think this approach is at all unreasonable. It may mean
a little more work on your end to break out these changes logically,
but I think it really needs to be done that way.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
