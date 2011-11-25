From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not used
Date: Thu, 24 Nov 2011 20:30:59 -0600
Message-ID: <CAH2r5muGUZzK6wWRE_Tvy1Gdpi+edXdPXJqoVWyWOb5phzo7sw@mail.gmail.com>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<20111109134140.2105ed9e@corrin.poochiereds.net>
	<CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
	<20111109160408.44947815@corrin.poochiereds.net>
	<E1RTHe2-004p4M-7T@intern.SerNet.DE>
	<20111123150427.57a63195@tlielax.poochiereds.net>
	<CAH2r5muKFRup1BwPqGuiy=+kh-NHP4fs42CC-xpZO1ryN-JK-Q@mail.gmail.com>
	<20111124072036.0fa2ad0d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Bj=F6rn_JACKE?= <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org,
	phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111124072036.0fa2ad0d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 24, 2011 at 6:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 23 Nov 2011 23:26:08 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> We are waiting a dochelp response from ms. In addition more data on =
the
>> perf penalty of cutting =A0the wsize in half would help. In any case=
 thecmore
>> serious problem is ignoring the write error not the wsize default
>
> We know there'll be a perf penalty, and I've done some rough numbers
> that show about a 30% decrease in some tests. The question is -- is i=
t
> a good idea to default to mount options that give better performance
> at the expense of interoperability? My vote is no -- the defaults

It depends ... one of the less common servers has a bug (which
apparently is being fixed) and it apparently hurts write
performance significantly to special case the wsize for this one server=
=2E
Implied in your answer is a worry that other servers incorrectly handle
the large write size but as we have seen there is a precedent for
writes over 64K (although apparently Windows clients do not send them
often - we will know more when Microsoft responds).   I am more
open to dropping the wsize to the value that fixes the problem to
Solaris (100K apparently) and has the least performance penalty
unless we get information back from Microsoft indicating a more
serious issue.  In any case there is no interoperability issue
if we handle the error on write (although the code path is tricky,
it is a fairly obvious example of "server tells us, late, that it
doesn't support this"
and if it were codeable to fall back wsize after the write error, there=
 would be
no issue to solaris).

This is a bad week to get response from Microsoft - but assuming
they respond the following week we should have plenty of time to
determine if we need to drop the wsize - but I feel uncomfortable
ignoring the retry on fairly obvious write error (even though the code
path is hard) because that can cause loss of data.


--=20
Thanks,

Steve
