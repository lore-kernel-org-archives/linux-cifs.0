From: James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Severe performance issue (Ubuntu 10.04 mounting an XP share)
Date: Tue, 6 Jul 2010 12:24:56 +0100
Message-ID: <AANLkTimKQAM1xbM-Ggkfs7M8atcPkDbBL5cVazf3R0dR@mail.gmail.com>
References: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk@mail.gmail.com>
	<20100702141617.46ec65a6@corrin.poochiereds.net>
	<AANLkTim4xY4n2y-jE0FzCAKc6NWK6DZcHx15d2owR-wV@mail.gmail.com>
	<AANLkTimdE4q2q3w0DccJUv_steLH-0kIhgK7_jv6-IMi@mail.gmail.com>
	<20100705090425.05c3f568@corrin.poochiereds.net>
	<AANLkTimguAhx_fL-N_wsckwj4EbiIMqAi93PofSohMSo@mail.gmail.com>
	<20100705093204.5064b612@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100705093204.5064b612-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 5 July 2010 14:32, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> You may be right, but unfortunately I can't do much beyond tell you
> what I think is happening now. It's certainly possible there was a
> change in the cifs code that is tickling a server-side bug.
>
> I think 0xC0000064 == NO_SUCH_USER, so there may be some sort of
> problem with authentication.

I've rebooted using 2.6.28 and phpunit is far, far faster (although
not as quick as it could be). Instead of 4m30s or more, I just ran it
at 48s.

Somewhere between .28 and .32 I suspect a regression causing massive
performance penalties. It would be interesting to see if this was
limited to mounting XP shares, I might have a go later.

I have absolutely no idea why XP is reporting these 0xC0000064 errors
- the user clearly does exist as I'm him!

James
