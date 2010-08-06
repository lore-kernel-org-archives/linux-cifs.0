From: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended  file stats available [ver #6]
Date: Sat, 7 Aug 2010 09:30:57 +1000
Message-ID: <20100807093057.7683bedd@notabene>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinVCLVpqLtA2X=1mOkxX7Re61_ZYsUix_XTvZ5D-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 5 Aug 2010 22:55:06 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Aug 5, 2010 at 10:38 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> > On Thu, 5 Aug 2010 16:52:18 -0700
> > Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>=20
> >> Don't add it as an EA. It's *not* an EA, it's a timestamp.
> >
> > I'm curious. =C2=A0Why do you particularly care what interface the =
kernel uses to
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
> > Yes, to you it is a timestamp. =C2=A0But to Linux it is a few bytes=
 of
> > user-settable metadata. =C2=A0Sounds like an EA to me.
> >
> > Or do you really want something like BSD's 'btime' which as I under=
stand it
> > cannot be set. =C2=A0Would that be really useful to you?
>=20
> Obviously the cifs and SMB2 protocols which  Samba server support can
> ask the server to set the create time of a file (this is handled
> through xattrs today along with the "dos attribute" flags such as
> archive/hidden/system), but certainly it is much more common (and
> important) to read the creation time of an existing file.
>=20

Just a point of clarification - when you say it is common and important=
 to be
able to read the creation time on an existing file, and you still talki=
ng in
the context of cifs/smb windows compatibility, or are you talking in th=
e
broader context?
If you are referring to a broader context could be please give more det=
ails
because I have not heard any mention of any real value of creation-time=
 out
side of window interoperability - have such a use clearly documented wo=
uld
assist the conversation I think.

If on the other hand you are just referring the the windows interoperab=
ility
context ... given that you have to read an EA if the create-time has be=
en
changed, you will always have to read and EA so having something else i=
s
pointless ... or I'm missing something.

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

Obviously if we were to make xattrs the preferred way to get create tim=
e out
of the filesystem we would want to make sure it is efficient.
It would seem to make perfect sense to add a 'getxattrat' syscall and a=
llow an
AT_NONBLOCK flag (which would probably be useful for statat too).  The
AT_NONBLOCK flag would only get attributes if they were available immed=
iately
without going to storage/network/whatever.

And if it is simply a case of too many syscalls per file, then
getxattrat_multi would seem to be the most general way to go.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
