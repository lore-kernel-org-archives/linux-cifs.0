From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 17 Nov 2010 13:43:52 -0600
Message-ID: <AANLkTinHdTudRWzHz-wf7bhiwn-2S8A-PM0YA3m_XLks@mail.gmail.com>
References: <1290018214-9415-1-git-send-email-sjayaraman@suse.de>
	<20101117133919.07f9f0db@tlielax.poochiereds.net>
	<4CE429F8.6070105@suse.de>
	<AANLkTikN44ayabuHkYWz1Cd6WYVdyO25Tv0E_fKv7=Fi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikN44ayabuHkYWz1Cd6WYVdyO25Tv0E_fKv7=Fi-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 17, 2010 at 1:40 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Wed, Nov 17, 2010 at 1:16 PM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org=
> wrote:
>> On 11/18/2010 12:09 AM, Jeff Layton wrote:
>>> On Wed, 17 Nov 2010 23:53:34 +0530
>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>>
>>>> Currently, the attribute cache timeout for CIFS is hardcoded to 1 =
second. This
>>>> means that the client might have to issue a QPATHINFO/QFILEINFO ca=
ll every 1
>>>> second to verify if something has changes, which seems too expensi=
ve. On the
>>>> other hand, if the timeout is hardcoded to a higher value, workloa=
ds that
>>>> expect strict cache coherency might see unexpected results.
>>>>
>>>> Making attribute cache timeout as a tunable will allow us to make =
a tradeoff
>>>> between performance and cache metadata correctness depending on th=
e
>>>> application/workload needs.
>>>>
>>>> Add 'actimeo' tunable that can be used to tune the attribute cache=
 timeout.
>>>> The default timeout is set to 1 second.
>>>>
>>>> Also, display actimeo option value in /proc/mounts.
>>> =A0 =A0 =A0 You actually do need to impose a limit here. I suggest =
looking
>>> =A0 =A0 =A0 very closely at time_before/time_after macros. It'll al=
so be
>>> =A0 =A0 =A0 easier to deal storing actimeo in terms of jiffies inst=
ead of
>>> =A0 =A0 =A0 seconds.
>>
>>> =A0 =A0 =A0 Finally, this value needs to be displayed in /proc/moun=
ts.
>>>
>>
>> Did you mean displaying values in jiffies in /proc/mounts? Wouldn't =
it
>> be confusing for users to see such a higher numbers (usually) when t=
hey
>> had used a simple 2 digit number for e.g. during mount?
>
> That is a good question - seems like we ought to allow setting more g=
ranular
> timeouts (ie jiffies) but nfs actimeo assumes the value is in seconds
> by default.
> I am fine with allowing actimeo to be specified more than one way (se=
conds vs
> milliseconds or seconds vs. jiffies) with suffix or prefix or keyword=
 variant.

This assumes there are apps that might someday need stricter
guarantees (sub 1 second - e.g. 15 per second) but not disable metadata=
 caching.
If we don't think that would ever happen - then I am fine with seconds
everywhere
(actimeo only in seconds, /proc display only in seconds).

> Probably should display it in seconds (or milliseconds) - jiffies
> would be confusing
> (I had trouble finding a way - short of looking at .config - what
> jiffies equivalent
> in seconds is)



--=20
Thanks,

Steve
