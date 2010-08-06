From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended  file stats available [ver #6]
Date: Fri, 6 Aug 2010 07:18:10 -0400
Message-ID: <20100806071810.5002dc2b@corrin.poochiereds.net>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<1280524978.2452.9.camel@segv.aura.of.mankind>
	<20100801092529.5e6ba0e0@corrin.poochiereds.net>
	<20100805235218.GB31233@jeremy-laptop>
	<20100806133836.49757af9@notabene>
	<AANLkTinVCLVpqLtA2X=1mOkxX7Re61_ZYsUix_XTvZ5D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>,
	utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinVCLVpqLtA2X=1mOkxX7Re61_ZYsUix_XTvZ5D-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 5 Aug 2010 22:55:06 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Aug 5, 2010 at 10:38 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> > On Thu, 5 Aug 2010 16:52:18 -0700
> > Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>=20
> >> Don't add it as an EA. It's *not* an EA, it's a timestamp.
> >
> > I'm curious. =A0Why do you particularly care what interface the ker=
nel uses to
> > provide you with access to this attribute?
> >
> > And given that it is an attribute that is not part of 'POSIX' or "U=
NIX", it
> > would seem to be an extension - an extended attribute.
> > As the Linux kernel does virtually nothing with this attribute exce=
pt provide
> > access, it seems to be a very different class of thing to other tim=
estamps.
> > Surely it is simply some storage associated with a file which is ca=
pable of
> > storing a timestamp, which can be set or retrieved by an applicatio=
n, and
> > which happens to be initialised to the current time when a file is =
created.
> >
> > Yes, to you it is a timestamp. =A0But to Linux it is a few bytes of
> > user-settable metadata. =A0Sounds like an EA to me.
> >
> > Or do you really want something like BSD's 'btime' which as I under=
stand it
> > cannot be set. =A0Would that be really useful to you?
>=20
> Obviously the cifs and SMB2 protocols which  Samba server support can
> ask the server to set the create time of a file (this is handled
> through xattrs today along with the "dos attribute" flags such as
> archive/hidden/system), but certainly it is much more common (and
> important) to read the creation time of an existing file.
>=20
>=20
> > Is there something important that I am missing?
>=20
> It is another syscall that Samba server would have to make - and xatt=
r
> performance is extremely slow on some file systems (although
> presumably this one would be more likely to be stored in inode and
> perhaps not as bad on ext4, cifs and a few others such as ntfs).
>=20
>=20

Right. One has to consider that samba has to satisfy READDIRPLUS-like
calls, and on a large directory all of those extra syscalls are likely
to impact performance.

In my view, the ideal thing would be to add this field as an EA and
continue work on implementing xstat(). Adding it as an EA gives
userland a way to set this value, without needing to add a new utimes()
variant.

If/when xstat becomes available, samba could use that instead of the EA
for reading this value.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
