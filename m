From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Sun, 4 Mar 2012 06:30:51 -0500
Message-ID: <20120304063051.05218c75@tlielax.poochiereds.net>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
	<20120303070921.5ce2bb10@tlielax.poochiereds.net>
	<CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 3 Mar 2012 21:14:19 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Echo is fairly minor - we rarely send them when mpxcount is "full",
> and when we do, usually send only one unless the server is broken.
> For the case where server has an mpxcount fewer than 4, I can see the
> logic of turning off (e.g. turn off oplock, blocking lock and echo if
> mpxcount 1, blocking lock and echo if only 2, disable echo if mpxcount
> is only 3) similar to the way you described, but sending an echo on a
> dead session with a "full" mpx count can't hurt so I don't feel as
> strongly about echo as I do about making sure that we disable oplock
> and blocking locks if mpxcount is 1.
> 
> Making sure that we don't send too many blocking locks should be easy
> because there is a posix rc that we can use if we have too many
> pending (so for example we can limit to something like 25, and not
> hurt Jeff's async read/write perf much).
> 

Another possibility is to use a smaller timeout for blocking locks in a
loop. Do something like this (simplified pseudocode):

do {
	rc = [blocking lock call with timeout of 10s];
} while (rc == -ETIMEDOUT)

Lock "fairness" would possibly suffer, but you could be reasonably
certain that you wouldn't deadlock the client for an undue period of
time. Eventually your other calls would get in between the lock
attempts.

> On the issue of why Samba didn't up maxmpx, I expect it is simply that
> until Jeff fixed async read/write, it was rare for a client to send 50
> requests in parallel.
> 

I'm fairly certain that windows sends reads/writes in parallel. Does
their client have a hard cap of 50 or so as well?

> On the SMB2 credits vs. CIFS maxmpx topic ...  more than once at the
> MS Plugfest I heard pushback on treating SMB2 credits and CIFS maxmpx
> similarly - they are totally unrelated.  SMB2 credits are pretty
> straightforward - we get them back on every request so they are
> constantly changing, but the rules are easier to understand (and are
> well documented, where the CIFS maxmpx behavior is only partially
> documented).
> 

That may be, particularly if we have to treat certain types of calls as
"special". Still, whether the rules for SMB1 are documented or not, we
have to settle on a set of them in order to fix cifs.ko. Building a
framework that can accommodate both sets of rules is better than
cut-and-paste. We just may need to abstract out a bit more than we
thought originally.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
