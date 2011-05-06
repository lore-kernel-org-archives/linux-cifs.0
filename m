From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: use the server's MaxMpxCount to determine max
 requests in flight
Date: Fri, 6 May 2011 11:01:52 +0400
Message-ID: <BANLkTikdVm7RU71vYvnkPfpGZxsj2fsj=g@mail.gmail.com>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
	<1304345069-2441-9-git-send-email-jlayton@redhat.com>
	<BANLkTinJHDQup-QwRNrZF19L_VycUCf1Jw@mail.gmail.com>
	<20110504070955.07d9420f@tlielax.poochiereds.net>
	<BANLkTimbNy+v-B2jzYH1hnEjtaKij5n6_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimbNy+v-B2jzYH1hnEjtaKij5n6_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/6 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Two reserved slots: =A0 =A01 for oplock break, 1 for echo.

What's if we need to send oplock break for two files in almost the same=
 time?

> Note that if maxmpx is set to 2 on negotiate, we also have to disable
> oplock (echo + 1 pending open request would max out our maxmpx)

What's if maxmpx is set to 1? According to the link (that I posted
above) it is a possible situation.

Note that now we don't count block locking command, but the spec
doesn't tell anything about it - so, I think we should count them too.

May be we should drop any exceptions, count all types of requests and
move to smth like priority queue? In this case we can use three kind
of lists and put echo requests into the highest priority list - e.g.
"3", oplock break requests - "2", and all other requests into the
priority "1" list. Or we can use only one double-linked list and put
all echo and oplock break requests to the head, and all other requests
- to the tail.

Thoughts?

--=20
Best regards,
Pavel Shilovsky.
