From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: Question regarding CIFS cache=loose behavior.
Date: Fri, 21 Mar 2014 05:56:04 +0900
Message-ID: <201403210556.FEI21354.FLJOQMHtSVOFFO@I-love.SAKURA.ne.jp>
References: <201403202103.EIE87056.QVtLHSFMFOOFOJ@I-love.SAKURA.ne.jp>
	<20140320161943.60890dd4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140320161943.60890dd4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton wrote:
> That's expected behavior. The kernel believes that the file is frozen in
> length so it returns short read() calls until the size is updated.

The "size is updated" means "stat() detects the growth of file size",
doesn't it? Then, the former is expected behavior.

> 
> cache=loose is very much not recommended for use when you have multiple
> hosts accessing files on the server (or access by processes on the
> server itself). It only gives you "loose" cache coherency. The whole
> point of it is to allow the client to cache data even when the protocol
> says that it shouldn't.

But why is the latter ( "read() returns non-0 when stat() detects the growth
of file size but the data actually read is '\0'" ) is expected behavior?
It sounds like a bug that the client caches '\0' (data nobody has ever wrote)
instead of '.' (data somebody wrote when the file size grew).

> 
> cache=strict is what is recommended and that's the default these days.

Yes, I suggested a customer using CIFS on RHEL6 to use cache=none or
cache=strict , for that customer's system does not work as expected due to
the latter behavior when using "tail -f" for checking for appended log.
