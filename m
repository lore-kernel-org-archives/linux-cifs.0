From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2pdu.c merged
Date: Tue, 8 Mar 2011 10:55:49 -0600
Message-ID: <AANLkTimxYRRd-98JFfUBTVsibt9GRYQeKxd94pO+AHmM@mail.gmail.com>
References: <AANLkTi=JhKhrS57TsWo9=wOSejDy4Hi6+i=PsjCShOP7@mail.gmail.com>
	<20110308112915.GA29380@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110308112915.GA29380-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 8, 2011 at 5:29 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> w=
rote:
> Sorry Steve,
>
> first you need to explain why a totall different protocol is better
> suited stuffed into the fucking mess than the cifs module than a clea=
n
> start. =A0Second you absolutely need to post patches for review befor=
e
> commiting them. =A0While others are cleaning up the mess you
> singlehandedly are making it worse constantly. =A0It can't go on that=
 way
> much longer.

Jeff's note may have explain more background, on some of your
questions.

I agree the code needs cleanup - that is why it is currently marked
as config EXPERIMENTAL and BROKEN.    The original prototype
was a distinct module (the smb2.ko from the smb2.git tree on kernel.org=
)
and had been tested at the previous 3 test events.  It would rely on a
cifs_common directory to allow cifs and smb2 to share some (perhaps
1/3) library functions.  In that implementation
I had done more aggressive cleanup (removing all camel case e.g., some
other structural changes are now in cifs.ko)  It passed some basic
file system tests
in its old form but was not complete.   I had favored keeping the smb2
support in a distinct module to allow more aggressive rewrite of some
common areas without risking cifs.ko stability and also because
the SMB2 protocol differs from the cifs protocol in many ways
(it is not really a "dialect" of the same protocol)
but had feedback from Jeff Layton and informally
from Andrew Morton to keep it in cifs.ko to make code reuse easier.
At Connectathon Jeff, Jeremy Allison, and I met again, also talking
with the nfs developers, and reached what seems like a
reasonable compromise which will keep the cifs code stable
while getting the experimental smb2 code

- move from two binaries (cifs.ko and smb2.ko)  to one with
a common fs type (still cifs), but require that the version be passed
in on mount (to use smb2)
- make modest changes to cifs structures to handle smb2 specific
needs (various new fields in the key global structures,
socket/session/tree-connect)
- move smb2 code from the prototype to smb2 specific files
in cifs.ko (configurable by ifdef) and clean it up as we go

Jeff and others have done some reasonable cleanup on cifs.ko
over the last three years so getting the smb2
code in tree is important so it can take advantage of some of
the good cleanup done in session establishment, socket
handling and name resolution in particular.

After working on the port, I am seeing more code reuse than
I expected, but there is significant cleanup needed.  SMB2
code is badly needed.  It is a much better protocol than
cifs (not just because of security and scalability improvements)
and better than nfs in some areas as well.   With code
upstream, at least those we can make progress, rather than
continually having to backport global fixes back.   The prototype
showed some interesting performance characteristics.  Pavel's
summer of code work on the smb2.git tree got performance
of sequential write faster than nfs, and Jeremy Bongio's patches
earlier in the year did the same for  the readpages path.  This
will require rework, but I think is worth getting in experimental
code so we can make progress.

I welcome cleanup ideas (and patches of course) - but it is
going to take a few weeks to get the original port converted
to the new structure.


--=20
Thanks,

Steve
