From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: cleanup fscache cFYI and cERROR messages
Date: Wed, 15 Jun 2011 10:54:50 -0500
Message-ID: <BANLkTi=cgkjeYJTjPhufB4Gy1QrdRjmc0w@mail.gmail.com>
References: <4DF7804B.8000502@suse.de>
	<20110614120048.7c04567d@corrin.poochiereds.net>
	<4DF87E1D.70802@suse.de>
	<20110615085841.633bb3c3@corrin.poochiereds.net>
	<4DF8AEC5.5030703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF8AEC5.5030703-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The idea of the 1st parameter to cerror was to allow turning off log
spam more easily if error turned out to be expected.  Gave some
flexibility debugging too.

On Wed, Jun 15, 2011 at 8:08 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
> On 06/15/2011 06:28 PM, Jeff Layton wrote:
>> On Wed, 15 Jun 2011 15:10:45 +0530
>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>>> On 06/14/2011 09:30 PM, Jeff Layton wrote:
>>>> On Tue, 14 Jun 2011 21:07:47 +0530
>>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>>>
>>>>> ... for uniformity and cleaner debug logs.
>>>>>
>>>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>>>> ---
>>>>> =A0fs/cifs/cache.c =A0 | =A0 =A06 +++---
>>>>> =A0fs/cifs/fscache.c | =A0 53 +++++++++++++++++++++++++----------=
------------------
>>>>> =A02 files changed, 28 insertions(+), 31 deletions(-)
>>>>>
>>>>> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
>>>>> index dd8584d..545509c 100644
>>>>> --- a/fs/cifs/cache.c
>>>>> +++ b/fs/cifs/cache.c
>>>>> @@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void =
*cookie_netfs_data,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0break;
>>>>>
>>>>> =A0 =A0default:
>>>>> - =A0 =A0 =A0 =A0 =A0cERROR(1, "CIFS: Unknown network family '%d'=
", sa->sa_family);
>>>>> + =A0 =A0 =A0 =A0 =A0cERROR(1, "Unknown network family '%d'", sa-=
>sa_family);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^^^^
>>>> =A0 =A0 =A0 =A0 =A0 =A0 Maybe this would be a good time to add in =
a new
>>>> =A0 =A0 =A0 =A0 =A0 =A0 cFYI/cERROR "flag" for fscache and convert=
 all of these
>>>> =A0 =A0 =A0 =A0 =A0 =A0 to use it?
>>>
>>> Sounds like a good idea to flag fsc debug messages separately but
>>> flagging errors separately would be useful?
>>>
>>
>> Good point. Now that you mention it, I'm not sure what purpose the
>> first argument to cERROR serves. Might be a good thing to do a globa=
l
>> search and replace -- "s/cERROR(1, /cERROR(/" and fix up the macro.
>
> Yes, we need to always print errors. I'll fix it up.
>
>>> Also, I don't understand the idea behing the "set" currently.
>>>
>>> we have
>>>
>>> #define cFYI(set, fmt, arg...) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>>> do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0\
>>> =A0 =A0 =A0 =A0 if (set) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0\
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsfyi(fmt, ##arg); =A0 =A0 =A0 =A0=
 =A0 =A0\
>>> } while (0)
>>>
>>> and we call cFYI with always pass like this:
>>> =A0 =A0 =A0cFYI(1, "..");
>>>
>>>
>>
>> I think for cFYI, the idea was to have a bitmask that would allow yo=
u
>> to selectively turn on certain classes of debug messages (similar to
>
> I thought so but the usage confused me.
>
>> how NFS' dfprintk macro works). In practice though, it's rarely set =
to
>> anything but "1". Maybe we should consider eliminating that argument=
 as
>> well?
>
> I'll see what it takes to fix it up to use bitmask and perhaps add a
> bitmask for fsc. But, I might be a little slow on this one.
>
>
> Thanks,
>
> --
> Suresh Jayaraman
>



--=20
Thanks,

Steve
