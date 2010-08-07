From: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended  file stats available [ver #6]
Date: Sat, 7 Aug 2010 13:32:40 +1000
Message-ID: <20100807133240.02883b83@notabene>
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
	<20100807093057.7683bedd@notabene>
	<AANLkTikDBg5Brt=55Tsu8ozk0aVx=srpxP=U-sFqeBYL@mail.gmail.com>
	<20100807102901.6a0b53e7@notabene>
	<AANLkTinEFFAWMu62j2sCPy=ArExZNm2miJOGoXbG65jC@mail.gmail.com>
	<AANLkTik7KhgF=pkpdEcsYM75NVXNmU4ynzdh3KWknTEL@mail.gmail.com>
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
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik7KhgF=pkpdEcsYM75NVXNmU4ynzdh3KWknTEL-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 6 Aug 2010 21:54:49 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Aug 6, 2010 at 9:42 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> > On Fri, Aug 6, 2010 at 7:29 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> >> On Fri, 6 Aug 2010 18:58:42 -0500
> >> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> On Fri, Aug 6, 2010 at 6:30 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> >>> > On Thu, 5 Aug 2010 22:55:06 -0500
> >>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> >
> >>> >> On Thu, Aug 5, 2010 at 10:38 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wr=
ote:
> >>> >> > On Thu, 5 Aug 2010 16:52:18 -0700
> >>> >> > Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >>> >>
> >>> >> >> Don't add it as an EA. It's *not* an EA, it's a timestamp.
> >>> >> >
> >>> >> > I'm curious. =C2=A0Why do you particularly care what interfa=
ce the kernel uses to
> >>> >> > provide you with access to this attribute?
> >>> >> >
> >>> >> > And given that it is an attribute that is not part of 'POSIX=
' or "UNIX", it
> >>> >> > would seem to be an extension - an extended attribute.
> >>> >> > As the Linux kernel does virtually nothing with this attribu=
te except provide
> >>> >> > access, it seems to be a very different class of thing to ot=
her timestamps.
> >>> >> > Surely it is simply some storage associated with a file whic=
h is capable of
> >>> >> > storing a timestamp, which can be set or retrieved by an app=
lication, and
> >>> >> > which happens to be initialised to the current time when a f=
ile is created.
> >>> >> >
> >>> >> > Yes, to you it is a timestamp. =C2=A0But to Linux it is a fe=
w bytes of
> >>> >> > user-settable metadata. =C2=A0Sounds like an EA to me.
> >>> >> >
> >>> >> > Or do you really want something like BSD's 'btime' which as =
I understand it
> >>> >> > cannot be set. =C2=A0Would that be really useful to you?
> >>> >>
> >>> >> Obviously the cifs and SMB2 protocols which =C2=A0Samba server=
 support can
> >>> >> ask the server to set the create time of a file (this is handl=
ed
> >>> >> through xattrs today along with the "dos attribute" flags such=
 as
> >>> >> archive/hidden/system), but certainly it is much more common (=
and
> >>> >> important) to read the creation time of an existing file.
> >>> >>
> >>> >
> >>> > Just a point of clarification - when you say it is common and i=
mportant to be
> >>> > able to read the creation time on an existing file, and you sti=
ll talking in
> >>> > the context of cifs/smb windows compatibility, or are you talki=
ng in the
> >>> > broader context?
> >>> > If you are referring to a broader context could be please give =
more details
> >>> > because I have not heard any mention of any real value of creat=
ion-time out
> >>> > side of window interoperability - have such a use clearly docum=
ented would
> >>> > assist the conversation I think.
> >>> >
> >>> > If on the other hand you are just referring the the windows int=
eroperability
> >>> > context ... given that you have to read an EA if the create-tim=
e has been
> >>> > changed, you will always have to read and EA so having somethin=
g else is
> >>> > pointless ... or I'm missing something.
> >>>
> >>> There are other cases, less common than cifs and smb2. =C2=A0 One
> >>> that comes to mind is NFS version 4, but there are a few other
> >>> cases that I have heard of (backup/archive applications).
> >>> The RFC recommends that servers return attribute 50 (creation
> >>> time). =C2=A0See below text:
> >>>
> >>> =C2=A0 =C2=A0time_create =C2=A0 =C2=A0 =C2=A0 =C2=A0 50 =C2=A0 nf=
stime4 =C2=A0 =C2=A0 =C2=A0 R/W =C2=A0 =C2=A0 =C2=A0The time of creatio=
n
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 of the object. =C2=A0This
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 attribute does not
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 have any relation to
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the traditional UNIX
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 file attribute
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ctime" or "change
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 time".
> >>
> >> I really don't think NFSv4 is a separate justification. =C2=A0I'm =
fairly sure
> >> that attribute was only including in NFSv4 for enhanced Windows
> >> compatibility (windows interoperation was a big issue during the p=
rotocol
> >> development).
> >
> > Perhaps also useful for MacOS (and other BSD), not just Windows,
> > although MacOS may use cifs more often than nfs.
>=20
> >> That leaves hypothetical "backup/archive applications".
> >> Do you have a concrete example?
>=20
> A quick search for backup applications in Wikipedia came up with a
> reference fairly easily (to backup app which uses creation
> time) for Linux:
>=20
> http://www.aqualab.cs.northwestern.edu/publications/Cornell04VFS.html

That publication seems to mention 'creation time' only as an abstract c=
oncept.
The backup architecture keeps a history of the file all that way back t=
o its
"creation time".
It doesn't appear to need or use a 'creation time' attribute stored wit=
h any
file.

>=20
> Presumably Windows compat. is a stronger motivation, than BSD/MacOS
> NFSv4 (returning birth time) compat, and backup applications
> are a lesser motivations.   There may also be some value in using cre=
ation
> time as a generation number where no generation number is
> available.
>=20
> Intuitively seems like creation time would be as "useful" as ctime (a=
nd probably
> more so) to app developers ... but that is hard to prove.
>=20

I agree, it does seem like an intuitively valuable number - after all w=
e each
have a birthday which we are very aware of and often make use of.  It i=
s
often treated as part of our identity - just like you were mentioning t=
hat
the CIFS client uses creation-time to help identify files which lack th=
e
'inode number' identifier that is the common tool in Unix and derivativ=
es.

But I'm not convinced that it is *practically* useful.  The only practi=
cal
use beyond windows-compatibility that has been mentioned is a stronger
'identity' tag.  However inode+generation number, or "file-handle-fragm=
ent"
are better things to use for identifying a file than "creation time",
especially when the latter is settable.

So if we were to add something for native applications to use, I doubt =
that
it would be 'creation time' (but I'm still open to hearing a convincing
use-case).

So we are left with an attribute that is needed for windows compatibili=
ty,
and so just needs to be understood by samba and wine.  Some filesystems=
 might
support it efficiently, others might require the use of generic
extended-attributes, still others might not support it at all (I guess =
you
store it in some 'tdb' and hope it works well enough).

Core-linux doesn't really need to know about this - there just needs to=
 be a
channel to pass it between samba/wine and the filesystem. xattr still s=
eems
the best mechanism to pass this stuff around.  Team-samba can negotiate=
 with
fs developers to optimise/accelerate certain attributes, and linux-VFS
doesn't need to know or care (except maybe to provide generic non-block=
ing or
multiple-access interfaces).

What is 'creation time' used for in the windows world??? Maybe there re=
ally
is something valuable here that we are missing....

NeilBrown
