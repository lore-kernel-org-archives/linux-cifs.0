From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 12:43:03 -0500
Message-ID: <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
	<20110818130408.71c55b96@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
	<CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
	<alpine.DEB.2.02.1108181331180.7903@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>,
	Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108181331180.7903-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If reading files - smbclient (ftp like syntax) should be able to reach
wire speeds (assuming the server disk can keep up) and for
writing it should be similar (perhaps a little slower but it won't
use i/o sizes as large as cifs kernel client).  I would expect
smbclient to/copy from Windows to be faster than Windows mount -> Samba=
=2E

I reached near wirespeeds for GigE with cifs client (writing) to
Winodws 2003/2008/r2
and Samba - but didn't have fast enough disks to test 10GigE although I=
 expect
very good performance with that if you have fast enough server disks (a=
nd
am willing to put performance patches in, if you detect additional
changes that we should make for 10GigE - in particular allowing
more than 50 simultaneous requests).

If the registry fix for Windows 7 is in place (or if you copy to
WIndows 2008, Windows 2003, WIndows 2008r2) -
cifs kernel client is probably slightly faster for writes than alternat=
ives,
smbclient much faster for reads.

If going the other direction (Windows client copying to/from Samba serv=
er) -
Samba 3.6 (server) with SMB2 support
turned on - is going to be faster than most alternatives.


On Thu, Aug 18, 2011 at 12:33 PM, Justin Piszcz <jpiszcz-BP4nVm5VUdOlno5B1MRpzg@public.gmane.org=
m> wrote:
>
>
> On Thu, 18 Aug 2011, Steve French wrote:
>
>> On Thu, Aug 18, 2011 at 12:16 PM, Justin Piszcz <jpiszcz@lucidpixels=
=2Ecom>
>> wrote:
>>>
>>>
>>> On Thu, 18 Aug 2011, Jeff Layton wrote:
>>>
>>>> On Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
>>>> Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org> wrote:
>>>>
>>>>>
>>>>>
>>>>> On Thu, 18 Aug 2011, Jeff Layton wrote:
>>>>>
>>>>>> On Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
>>>>>> Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org> wrote:
>>>>>>
>>>>>>> Justin.
>>>>>>>
>>>>>>
>>>>>> To be clear -- incoming in this case is reads or writes?
>>>>>
>>>>> Reading from the CIFS share (Windows 7).
>>>>>
>>>>>>
>>>>>> Up until 3.0 cifs.ko didn't parallelize writes from a single thr=
ead.
>>>>>> In
>>>>>> 3.0 I added a patchset to increase the allowable wsize and to al=
low
>>>>>> the
>>>>>> kernel to issue writes in parallel.
>>>>>
>>>>> Ahh, good to know, have not tried writes yet.
>>>>>
>>>>>>
>>>>>> Reads still suffer from the same problem however. I'm working on=
 a
>>>>>> patchset that should do the same thing for them, but it requires=
 a
>>>>>> fairly substantial overhaul of the receive codepaths.
>>>>>
>>>>> Ok, that explains it then, thanks.
>>>
>>>
>>> Hi,
>>>
>>> Watching the rsync, it ran for a while, then:
>>>
>>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": =
Cannot
>>> allocate memory (12)
>>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_1.JPG": =
Cannot
>>> allocate memory (12)
>>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_2.JPG": =
Cannot
>>> allocate memory (12)
>>> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": =
Cannot
>>> allocate memory (12)
>>
>> When we were testing async write to Windows 7 Pavel mentioned to me
>> another WIndows 7 bug - which may be what you are hitting.
>>
>> Under stress of simultaneous operations, Windows 7 server will somet=
imes
>> start
>> responding with STATUS_INSUFF_SERVER_RESOURCES error code
>> (mapped to posix error ENOMEM by the Linux cifs kernel client)
>> He solved it by setting MaxWorkItems to 4096 in the Windows 7 regist=
ry.
>>
>> If anyone knows whether Microsoft has fixed this or has a bug #, let=
 us
>> know
>> because it is easier to hit with Linux kernel 3.0 and later (to
>> Windows 7 server).
>
> Ok, aside from sharing a few files, is there any recommended protocol=
 to
> transfer millions of files at 10GbE speeds (500MiB/s) in both directi=
ons
> between Windows and Linux?
>
> Specifically from Linux..
>
> From Windows, it achieves 500MiB/s no issues (From Linux/Samba).
>
> The other direction:
> - 30mb/s over 10GbE
> - Cannot allocate memory
>
> This should be good for moving a small subset of files, but for large=
r
> datasets
> it will not work. =A0Any other filesystems/services/etc to try?
>
> Justin.
>
>
>



--=20
Thanks,

Steve
