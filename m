From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Thu, 1 Mar 2012 13:37:47 -0500
Message-ID: <20120301133747.5fc891b5@samba.org>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<20120228114341.1629ed85@tlielax.poochiereds.net>
	<CAH2r5mvFyw8Cn8nXN9ZBZogBGVr5L5T9aX7Zs8DOiZgDUqGp1Q@mail.gmail.com>
	<20120228144736.18124fc3@tlielax.poochiereds.net>
	<CAH2r5mvJE+ACNVuv+HEQMuwvaMTzfOb7Msk4U1ZVnZ046AEi1Q@mail.gmail.com>
	<CAKywueSxe_wZwudx3UK14C94o53zjghsTJJSah=CQSqy0uhZRQ@mail.gmail.com>
	<CAH2r5mvFiwpVwcBgfuXvEGC1_8snLMAsp4fRVEDMqTWXDJdu9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvFiwpVwcBgfuXvEGC1_8snLMAsp4fRVEDMqTWXDJdu9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 28 Feb 2012 15:18:02 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Feb 28, 2012 at 2:53 PM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
> wrote:
> > 2012/2/29 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> >> Attempt to summarize after discussions with jra and Chris:
> >>
> >> - don't make default case to Samba worse performance than it alrea=
dy is
> >> - don't "fix" by adding restrictions on echo retries and blocking
> >> locks when it is not broken (windows allows these, and counts bloc=
king
> >> locks against the pid not against the session). =C2=A0 For servers=
 which
> >> allow few mpx, perhaps those for 10 or fewer - if you think they a=
re
> >> buggy, I don't mind treating echo and blocking locks differently t=
han
> >> we do now - but echo and blocking locks don't need to be restricte=
d
> >> the way Pavel suggested to windows and samba and any normal server
> >> (and there is some risk in restricting them that way). =C2=A0 We c=
ould
> >> probably limit the number of blocking locks (out of resource error=
,
> >> returning ENOLOCK) when there are 50 (e.g.) on a process (or 10 if=
 the
> >> server supports maxmpx of 10, and zero if maxmpx is less than 3 or
> >> less than 10).
> >> - for other smb requests (the ones we enforce today) enforce the l=
imit
> >> the server returns (rather than 50 always)
> >>
> >
> > But for SMB2 we need to count both echos and blocking locks. It eve=
n
> > more compicated because the number of credits is dynamic: we need t=
o
> > increment/decrement the maximum number of parallel blocking locks t=
o
> > make sure we don't exceed available credits.
>=20
> Yes - for smb2 the number of available requests (credits) can change
> on ANY smb2 response.  It is not related to how cifs requests are
> processed.
>=20
> Also note that for cifs for Windows, apparently the smb echo is
> handled at a lower level (before checking mpx) - (and also Samba
> server does not enforce either).
>=20

(cc'ing Chris and Jeremy to make sure I understand)

The description above is a good start but doesn't quite outline the
clear concise "rules" for this that I was looking for.

So if I understand what Steve wrote above, he's basically saying that
we should enforce the maxmpx for everything but blocking locks and
echoes? Is that correct? If so then I think that's wrong and won't fix
any of the problems that people have reported with the existing code.

It's all well and good that *some* servers allow you to exceed the
maxmpx in *some* cases, but we can't code to that assumption. We know
well that many servers do not handle exceeding the maxmpx gracefully at
all. As always we have to code to the lowest common denominator by
default, and then optionally allow people to exceed that if they choose
to do so.

I think this is a case where we need a good description in a human
language (preferably english) of how this should work (aka a
specification), and then write code to match that description (aka code
to the spec).

Anything else is going to send us down the rabbit hole where we are
today with cifs.ko -- a bunch of ad-hoc, broken code that no one really
understands.

While we may not like it, a hard cap on the number of outstanding
requests is required by the protocol docs that Chris helped write.

Allow me to quote from MS-CIFS:

MaxMpxCount (2 bytes): The maximum number of outstanding SMB operations
that the server supports. This value includes existing OpLocks, the
NT_TRANSACT_NOTIFY_CHANGE subcommand, and any other commands that are
pending on the server.

There's nothing in there that says anything about certain commands
being excepted from that value.
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
