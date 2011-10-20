From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: allow cifs_max_pending to be readable under /sys/module/cifs/parameters
Date: Wed, 19 Oct 2011 20:32:47 -0500
Message-ID: <CAH2r5mubpD3ZbKeZru=ttG+ihaw5vcok_jc_N4zRYsoV7JsBBw@mail.gmail.com>
References: <1319052676-11587-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mtAwXFETw8AR9Bw=ra0MZ04=SYgPvX_2NC9q0V+ZTyjnA@mail.gmail.com>
	<20111019205607.3770a921@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111019205607.3770a921-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 19, 2011 at 7:56 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 19 Oct 2011 16:31:15 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> With the proposed cifs.ko fix to honor maxmpx, cifs_max_pending
>> because a limit when the server (as Windows often is) has more than =
50
>> maxmpxct in its registry. =A0 Does anyone mind if I update the maxim=
um
>> to one or two hundred? (after the mpx fix is in)?
>>
>
> Ummm...what proposed fix? I've not seen that patch cross the list. Di=
d
> I miss it?

well ... you asked me to rename one of the flags so I am pretty sure yo=
u saw
it.  I plan to repost it - although it is a little less important now
that we realize
that the Windows problem can occur even when mpx is 50 (still it is goo=
d
to honor the server limit).

--=20
Thanks,

Steve
