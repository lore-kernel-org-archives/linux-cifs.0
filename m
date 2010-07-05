From: James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Severe performance issue (Ubuntu 10.04 mounting an XP share)
Date: Mon, 5 Jul 2010 10:14:29 +0100
Message-ID: <AANLkTimdE4q2q3w0DccJUv_steLH-0kIhgK7_jv6-IMi@mail.gmail.com>
References: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk@mail.gmail.com>
	<20100702141617.46ec65a6@corrin.poochiereds.net>
	<AANLkTim4xY4n2y-jE0FzCAKc6NWK6DZcHx15d2owR-wV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim4xY4n2y-jE0FzCAKc6NWK6DZcHx15d2owR-wV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry I meant this to go to the list rather than solely to Jeff persona=
lly.

On 2 July 2010 19:16, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2 Jul 2010 16:39:06 +0100
> James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Jul =A02 16:14:58 ubuntu kernel: [ 1378.833956] CIFS VFS: No respons=
e
>> for cmd 50 mid 11112
>
> The client is sending a SMB_COM_TRANSACTION2 and isn't getting a
> response. You might want to sniff traffic and identify calls that
> aren't getting responses. If there is some commonality between them
> then that may point to where the problem is.

Jeff,

I fear I'm looking for a needle in a haystack, and I've no idea what
the needle looks like.

I ran Wireshark on my XP host and repeatedly ran the phpunit tests obse=
rving:

1. There really is an awful lot of FIND_FIRST2, Pattern: <blah>,
followed immediately by FIND_FIRST2, Files: <blank>. I assume this to
be normal.

2. Occassionally and on a random Pattern argumen, a FIND_FIRST2 or
QUERY_PATH_INFO is followed immediately not by an SMB level response
but by a TCP "microsoft-ds" ACK. The Len is 0 and all other arguments
have values. At this point there may be several seconds of delay
before SMB re-establishes with a Session Set AndX Request, User:
\jgreen then a Tree Connect AndX Request for the mount point being
used.

It feels as though the XP host itself is simply not returning a
response some of the time. Other than changing my password and
rebooting the whole lot I can't think of anything I might have done.

If you have any further tests you'd like me to perform I'll try to
oblige as this is killing my workflow.

Thanks,

James
