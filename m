From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: queued patches for 3.10
Date: Fri, 24 May 2013 13:29:52 -0500
Message-ID: <CAH2r5muCXqx5ddS-6_yD5_yp8svj0E0Xyzjup6-wVTTgJ85TwQ@mail.gmail.com>
References: <20130524074937.0f225d12@corrin.poochiereds.net>
	<CAH2r5msJ1zza9KzOHeFYShjVm98S+wWF_e-bufkiUct+QhF77Q@mail.gmail.com>
	<20130524142351.3d4d0319@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130524142351.3d4d0319-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 24, 2013 at 1:23 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 24 May 2013 13:21:06 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I sent a merge request for the setops fix, the other five in your
>> for-3.10 are queued in the for-3.10 branch (and for-3.11 branch there
>> are five more in for-3.11 from your longer series that I have already
>> reviewed and put in - note that this for-3.11 branch is soon to be
>> called "for-next" so linux-next will be building it)
>>
>> In the series of patches for-3.10 I did fix up two formatting errors
>> that checkpatch noticed:
>>
>
> Thanks for fixing those.
>
>> I have reviewed 3 of the 5 of your most recent patches in for-3.10,
>> but would appreciate more review especially on the two larger ones
>> ("fix error handling ..."  and "fix composing ...") in that series.
>>
>
> Ok...


cifs-2.6.git for-next is fixed up to look like a "for-3.11" branch.
There also is still a for-3.10 with the five patches I know about
for-3.10 still - if you know of any others that should go in for-3.10
let me know.  Perhaps the removexattr patch might be one for example.

-- 
Thanks,

Steve
