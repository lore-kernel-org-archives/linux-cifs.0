From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question regarding CIFS cache=loose behavior.
Date: Thu, 20 Mar 2014 16:04:13 -0500
Message-ID: <CAH2r5mssFsz3n7nVMOzNGcvxMNaaBG2TGEusLqGiKLhUtvTKxg@mail.gmail.com>
References: <201403202103.EIE87056.QVtLHSFMFOOFOJ@I-love.SAKURA.ne.jp>
 <20140320161943.60890dd4@tlielax.poochiereds.net> <201403210556.FEI21354.FLJOQMHtSVOFFO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201403210556.FEI21354.FLJOQMHtSVOFFO-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 20, 2014 at 3:56 PM, Tetsuo Handa
<penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org> wrote:
> Jeff Layton wrote:
>> That's expected behavior. The kernel believes that the file is frozen in
>> length so it returns short read() calls until the size is updated.
>
> The "size is updated" means "stat() detects the growth of file size",
> doesn't it? Then, the former is expected behavior.

Note that setting cifs mount option "actimeo=0" will cause size not to
be cached and may help.

>> cache=loose is very much not recommended for use when you have multiple
>> hosts accessing files on the server (or access by processes on the
>> server itself). It only gives you "loose" cache coherency. The whole
>> point of it is to allow the client to cache data even when the protocol
>> says that it shouldn't.
>
> But why is the latter ( "read() returns non-0 when stat() detects the growth
> of file size but the data actually read is '\0'" ) is expected behavior?
> It sounds like a bug that the client caches '\0' (data nobody has ever wrote)
> instead of '.' (data somebody wrote when the file size grew).
>
>>
>> cache=strict is what is recommended and that's the default these days.
>
> Yes, I suggested a customer using CIFS on RHEL6 to use cache=none or
> cache=strict , for that customer's system does not work as expected due to
> the latter behavior when using "tail -f" for checking for appended log.



-- 
Thanks,

Steve
