From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] [PATCH] cifs: retry kernel_sendmsg only in case of -EAGAIN
Date: Tue, 2 Oct 2012 11:08:46 -0500
Message-ID: <CAH2r5ms_wx0B7UZp4t6J5J4no8Kg6=5ya247ak0K6CMWV=TN-g@mail.gmail.com>
References: <506948FD.3090602@suse.com>
	<20121001214017.60f41311@corrin.poochiereds.net>
	<CAH2r5msunor+xKU5tjgyuD+y3Qfist8kAHze7DwcC0SkAOe5tg@mail.gmail.com>
	<20121001215030.5487c930@corrin.poochiereds.net>
	<506AC06A.1030009@suse.com>
	<20121002071229.2b406a40@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121002071229.2b406a40-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 2, 2012 at 6:12 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 02 Oct 2012 15:52:34 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
>> On 10/02/2012 07:20 AM, Jeff Layton wrote:
>> > On Mon, 1 Oct 2012 20:46:01 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> How can we be certain that ENOSPC is no longer returned? When it was
>>
>> I had traced kernel_sendmsg() and the functions it is calling, but I
>> couldn't find any of them returning -ENOSPC. Also, I couldn't find any
>> other callers of kernel_sendmsg() checking for -ENOSPC.
>>
>> >> returned then the obvious thing was to block briefly and retry.
>> >>
>> >> Does it do any harm?
>>
>> When I tried to analyze what might cause the error reported here
>>   http://thread.gmane.org/gmane.linux.kernel/1367198/focus=1367498
>>
>> I bumped into this code. I had a few questions that I couldn't answer like
>>
>> a) When does kernel_sendmsg return -ENOSPC?
>> b) Even if we assume it returns -ENOSPC, does it really make sense to retry?
>> c) Does the error condition that lead to -ENOSPC rectify by the time we
>> retry?
>> d) Why do we need to reset -ENOSPC to -EAGAIN before returning the error?
>>
>> If we can answer these questions reasonably, we may not need this patch.
>>
>> >
>> > Can you explain the situation that caused it to return -ENOSPC in the
>> > first place? Why that and not -EAGAIN? Or -ENOBUFS?
>>
>> I too thought -ENOBUFS might represent the condition better.
>>
>
> To lend further weight to the argument too. The sendmsg(2) manpage
> doesn't list -ENOSPC as an error return.
>
> kernel_sendmsg() is basically the kernelspace wrapper around the same
> set of functions that the sendmsg() system call uses. If it's not a
> valid error return for sendmsg() then it almost certainly isn't one for
> kernel_sendmsg() either.
>
> The harm in these situations is further obfuscation of some code that
> is already far too complicated, and the potential for papering over
> real bugs. If kernel_sendmsg returns ENOSPC, then that's likely a bug
> and is something we should deal with accordingly instead of blindly
> retrying.
>
> If you're concerned about it however, one possibility might be to add a
> WARN_ON_ONCE that fires on an ENOSPC error for a few releases.

Seems reasonable, since if we did get an ENOSPC from a lower level
driver (filtered through either sendmsg interface) we would expect
the same strategy to deal with as EAGAIN - wait and retry.


-- 
Thanks,

Steve
