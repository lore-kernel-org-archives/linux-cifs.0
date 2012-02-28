From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Wed, 29 Feb 2012 00:53:16 +0400
Message-ID: <CAKywueSxe_wZwudx3UK14C94o53zjghsTJJSah=CQSqy0uhZRQ@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<20120228114341.1629ed85@tlielax.poochiereds.net>
	<CAH2r5mvFyw8Cn8nXN9ZBZogBGVr5L5T9aX7Zs8DOiZgDUqGp1Q@mail.gmail.com>
	<20120228144736.18124fc3@tlielax.poochiereds.net>
	<CAH2r5mvJE+ACNVuv+HEQMuwvaMTzfOb7Msk4U1ZVnZ046AEi1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvJE+ACNVuv+HEQMuwvaMTzfOb7Msk4U1ZVnZ046AEi1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/29 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Attempt to summarize after discussions with jra and Chris:
>
> - don't make default case to Samba worse performance than it already =
is
> - don't "fix" by adding restrictions on echo retries and blocking
> locks when it is not broken (windows allows these, and counts blockin=
g
> locks against the pid not against the session). =A0 For servers which
> allow few mpx, perhaps those for 10 or fewer - if you think they are
> buggy, I don't mind treating echo and blocking locks differently than
> we do now - but echo and blocking locks don't need to be restricted
> the way Pavel suggested to windows and samba and any normal server
> (and there is some risk in restricting them that way). =A0 We could
> probably limit the number of blocking locks (out of resource error,
> returning ENOLOCK) when there are 50 (e.g.) on a process (or 10 if th=
e
> server supports maxmpx of 10, and zero if maxmpx is less than 3 or
> less than 10).
> - for other smb requests (the ones we enforce today) enforce the limi=
t
> the server returns (rather than 50 always)
>

But for SMB2 we need to count both echos and blocking locks. It even
more compicated because the number of credits is dynamic: we need to
increment/decrement the maximum number of parallel blocking locks to
make sure we don't exceed available credits.

--=20
Best regards,
Pavel Shilovsky.
