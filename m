From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2pdu.c merged
Date: Tue, 8 Mar 2011 11:07:29 -0600
Message-ID: <AANLkTintwkC=DSXfPtDcTDS0DTmj7viFMkUEkf3K8wDb@mail.gmail.com>
References: <AANLkTi=JhKhrS57TsWo9=wOSejDy4Hi6+i=PsjCShOP7@mail.gmail.com>
	<20110308112915.GA29380@infradead.org>
	<20110308071516.3890d5bf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110308071516.3890d5bf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 8, 2011 at 6:15 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 8 Mar 2011 06:29:15 -0500
> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
>> Sorry Steve,
>>
>> first you need to explain why a totall different protocol is better
>> suited stuffed into the fucking mess than the cifs module than a cle=
an
>> start. =A0Second you absolutely need to post patches for review befo=
re
>> commiting them. =A0While others are cleaning up the mess you
>> singlehandedly are making it worse constantly. =A0It can't go on tha=
t way
>> much longer.
>>
>
> SMB2 servers are also generally CIFS servers. There is a mechanism to
> autonegotiate when talking to a sever to decide which protocol to use=
=2E
> Making a completely separate fstype and module however will mean that
> we can't effectively use that mechanism. Userspace will have to decid=
e
> "smb2" or "cifs" at mount time and tough luck if you get it wrong.
>
> I'd like to avoid the same mistake made with "nfs" vs. "nfs4" fstypes=
=2E
> That was a real pain to clean up after the fact and still isn't 100%
> the way we'd really like (there's still a nfs4 fstype, for instance).
>
> I think putting it in the same module and sharing the fstype is the
> right thing to do. Much of the code between CIFS and SMB2 can be shar=
ed
> and there's little value in putting that into a separate module. I
> think we'll be far better served by abstracting out the existing code
> where we can.
>
> That said, I'm also not very happy with the how the SMB2 merge is
> going. A lot of this code seems to be getting merged without any revi=
ew
> at all on the list. I really don't care how big they are -- I'd like =
to
> see patchsets mailed out as anyone else would.

That is more practical now.  With the protocol definitions, error codes=
, and
the added fields in the global structures, it is easier to talk about a=
nd
incrementally review.  I will be putting the subsequent patches
on list.   Next steps in the conversion:
- transport handling
- smb2 demultiplexing (following up on some of your ideas from connecta=
thon)
- finish up of the mount code (which presumably will look more like
cifs now than the earlier smb2 prototype)

It will be much easier to review when enough code is converted to
allow mount and testing.

In this first set of code, I tried to balance which ones are
practical to rereview with which ones are not.
I tried to send out the changes to structures which
affect cifs mounts in particular.   But it was harder
for a few of the big early conversions of files from smb2.git to cifs-2=
=2E6.git
=46or example, rereviewing the two largest pieces (the list
of error codes, and the list of header definitions) would be hard -
they are too big for email and come from the spec.


--=20
Thanks,

Steve
