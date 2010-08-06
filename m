From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Fri, 6 Aug 2010 18:58:42 -0500
Message-ID: <AANLkTikDBg5Brt=55Tsu8ozk0aVx=srpxP=U-sFqeBYL@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100807093057.7683bedd@notabene>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 6, 2010 at 6:30 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> On Thu, 5 Aug 2010 22:55:06 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Aug 5, 2010 at 10:38 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
>> > On Thu, 5 Aug 2010 16:52:18 -0700
>> > Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>> >> Don't add it as an EA. It's *not* an EA, it's a timestamp.
>> >
>> > I'm curious. =A0Why do you particularly care what interface the ke=
rnel uses to
>> > provide you with access to this attribute?
>> >
>> > And given that it is an attribute that is not part of 'POSIX' or "=
UNIX", it
>> > would seem to be an extension - an extended attribute.
>> > As the Linux kernel does virtually nothing with this attribute exc=
ept provide
>> > access, it seems to be a very different class of thing to other ti=
mestamps.
>> > Surely it is simply some storage associated with a file which is c=
apable of
>> > storing a timestamp, which can be set or retrieved by an applicati=
on, and
>> > which happens to be initialised to the current time when a file is=
 created.
>> >
>> > Yes, to you it is a timestamp. =A0But to Linux it is a few bytes o=
f
>> > user-settable metadata. =A0Sounds like an EA to me.
>> >
>> > Or do you really want something like BSD's 'btime' which as I unde=
rstand it
>> > cannot be set. =A0Would that be really useful to you?
>>
>> Obviously the cifs and SMB2 protocols which =A0Samba server support =
can
>> ask the server to set the create time of a file (this is handled
>> through xattrs today along with the "dos attribute" flags such as
>> archive/hidden/system), but certainly it is much more common (and
>> important) to read the creation time of an existing file.
>>
>
> Just a point of clarification - when you say it is common and importa=
nt to be
> able to read the creation time on an existing file, and you still tal=
king in
> the context of cifs/smb windows compatibility, or are you talking in =
the
> broader context?
> If you are referring to a broader context could be please give more d=
etails
> because I have not heard any mention of any real value of creation-ti=
me out
> side of window interoperability - have such a use clearly documented =
would
> assist the conversation I think.
>
> If on the other hand you are just referring the the windows interoper=
ability
> context ... given that you have to read an EA if the create-time has =
been
> changed, you will always have to read and EA so having something else=
 is
> pointless ... or I'm missing something.

There are other cases, less common than cifs and smb2.   One
that comes to mind is NFS version 4, but there are a few other
cases that I have heard of (backup/archive applications).
The RFC recommends that servers return attribute 50 (creation
time).  See below text:

   time_create         50   nfstime4       R/W      The time of creatio=
n
                                                    of the object.  Thi=
s
                                                    attribute does not
                                                    have any relation t=
o
                                                    the traditional UNI=
X
                                                    file attribute
                                                    "ctime" or "change
                                                    time".



--=20
Thanks,

Steve
