From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: monotonic time for mount.cifs timeouts
Date: Tue, 24 Aug 2010 14:22:48 -0400
Message-ID: <20100824142248.164caebe@tlielax.poochiereds.net>
References: <E1OnwAo-008Rzd-Bd@intern.SerNet.DE>
	<20100824133418.6319ead7@tlielax.poochiereds.net>
	<AANLkTi==5ZbC7Fb8wnCea50OndXZ=QwV5xPwv19K1Fyz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?B?Qmr2cm4=?= JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi==5ZbC7Fb8wnCea50OndXZ=QwV5xPwv19K1Fyz-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 Aug 2010 13:07:55 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Any pointers to background on gettimeofday vs
> clock_gettime(CLOCK_MONOTONIC) and why the latter is better?

IIUC, the reason for this is that gettimeofday is affected by wallclock
changes (think NTP):

       CLOCK_MONOTONIC
              Clock  that  cannot  be  set and represents monotonic time since
              some unspecified starting point.

...so by preferring CLOCK_MONOTONIC, the mtab locking code isn't
affected by clock jumps or skew. Bjorn, is this correct?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
