From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: samba changing mode of files on rename
Date: Fri, 17 Sep 2010 13:40:46 -0400
Message-ID: <20100917134046.497b5f6f@corrin.poochiereds.net>
References: <20100917130005.23d0864a@corrin.poochiereds.net>
	<20100917131558.13a00c53@corrin.poochiereds.net>
	<AANLkTikctbnerDjPa8HS0JuB0jGv2ACjtt8AQ97LFVP9@mail.gmail.com>
	<AANLkTi=LRTj8V5f+gJwLhj3tgz9KUPSg8jBqPL3GCjn2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=LRTj8V5f+gJwLhj3tgz9KUPSg8jBqPL3GCjn2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Sep 2010 12:28:52 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Sep 17, 2010 at 12:27 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> >
> >
> > On Fri, Sep 17, 2010 at 12:15 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> >>
> >> On Fri, 17 Sep 2010 13:00:05 -0400
> >> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >>
> >> > I recently noticed a regression in samba in the last few weeks. =
Here's
> >> > a simple way to reproduce it:
> >> >
> >> > 1) use smbclient to put a file on a samba share
> >> > 2) change the mode of the file to something without the owner ex=
ecute bit set
> >> > 3) rename the file using smbclient
> >> >
> >> > When you do this, the newly renamed file will magically end up w=
ith the
> >> > owner execute bit set. It seems like samba ought not be changing=
 the
> >> > mode of files when renaming them so I consider this a regression=
=2E
> >> >
> >> > I've reported the bug in the Fedora BTS, and attached some info =
there.
> >> > Anyone more familiar with this code willing to have a look?
> >> >
> >> > =A0 =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D617771
> >> >
> >> > I've was able to reproduce it today using the most recent samba =
version
> >> > available in the Fedora repos (3.5.5).
> >> >
> >> > Thanks,
> >>
> >> Volker pointed out a workaround on IRC...
> >>
> >> If I set "map archive =3D no" then this doesn't seem to happen. So=
, I
> >> guess something has happened relatively recently to make renames s=
et
> >> the archive bit?
> >
> > Interesting - but I would expect that rename would set the archive =
bit
> > (creates, file modifications also set the bit in Windows). =A0In Wi=
ndows
> > rename sets the archive bit (although we don't need to track the ar=
chive bit
> > for Linux cifs.ko we probably could report it via xattrs for backup
> > applications to use - much like Windows backup apps check/clear it)=
=2E
> > See below:
> > C:\Users\stevef>echo newfile > new
> > C:\Users\stevef>attrib new
> > A =A0 =A0 =A0 =A0 =A0 =A0C:\Users\stevef\new
> > C:\Users\stevef>attrib -a new
> > C:\Users\stevef>rename new newer
> > C:\Users\stevef>attrib newer
> > A =A0 =A0 =A0 =A0 =A0 =A0C:\Users\stevef\newer
> > --
> > Thanks,
> >
> > Steve
>=20
> Interesting - but I would expect that rename would set the archive bi=
t
> (creates, file modifications also set the bit in Windows).  In Window=
s
> rename sets the archive bit (although we don't need to track the arch=
ive bit
> for Linux cifs.ko we probably could report it via xattrs for backup
> applications to use - much like Windows backup apps check/clear it).
>=20
> See below:
>=20
> C:\Users\stevef>echo newfile > new
>=20
> C:\Users\stevef>attrib new
> A            C:\Users\stevef\new
>=20
> C:\Users\stevef>attrib -a new
>=20
> C:\Users\stevef>rename new newer
>=20
> C:\Users\stevef>attrib newer
> A            C:\Users\stevef\newer
>=20
> --
> Thanks,
>=20
> Steve

Yeah, it makes some sense that this would happen in hindsight, but it's
rather problematic in conjunction with unix extensions. The default of
"map *" being on doesn't take into account clients that actually care
about the mode remaining consistent across operations like rename.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
