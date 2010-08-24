From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: monotonic time for mount.cifs timeouts
Date: Tue, 24 Aug 2010 13:07:55 -0500
Message-ID: <AANLkTi==5ZbC7Fb8wnCea50OndXZ=QwV5xPwv19K1Fyz@mail.gmail.com>
References: <E1OnwAo-008Rzd-Bd@intern.SerNet.DE>
	<20100824133418.6319ead7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Bj=F6rn_JACKE?= <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100824133418.6319ead7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 24, 2010 at 12:34 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Tue, 24 Aug 2010 18:16:19 +0200
> Bj=F6rn JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:
>
>> Hi,
>>
>> attached are patches to spot the clock_gettime function and to use t=
hat and the
>> monotonic clock for timeout handling if possible.
>>
>> If there are no objections, can you please apply them, Jeff?

Any pointers to background on gettimeofday vs
clock_gettime(CLOCK_MONOTONIC) and why the latter is better?

--=20
Thanks,

Steve
