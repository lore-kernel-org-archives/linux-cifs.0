From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 11:01:09 -0500
Message-ID: <CAH2r5mv9cdP_05dzmGZ_mVOswgNGVViU8Y3Z2Su+JT2Jv2TbSA@mail.gmail.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108180807070.7903-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Writing from cifs kernel client to WIndows or Samba server should be mu=
ch faster
than the reverse (ie large file sequential file copy to server is
faster than copying
a file from the server)  cifs kernel client serializes reads from the s=
ame file
(unless mounting forcedirectio, in which case caching is disabled) and =
uses
a relatively smaller read size (16K) - while for writes they are sent
in parallel
even if to the same file (and the write size is much larger e.g. 126976=
 bytes,
and can be set even larger to Samba).  There may be a few cases (such
as copying to WIndowsXP or Windows7) where timeouts on the
server slow things down (writing from linux client to Windows XP
or Windows 7) but what is the server type?


On Thu, Aug 18, 2011 at 7:14 AM, Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org=
> wrote:
>
>
> On Thu, 18 Aug 2011, Justin Piszcz wrote:
>
>>
>>
>> On Thu, 18 Aug 2011, J. R. Okajima wrote:
>>
>>>
>>> Justin Piszcz:
>>>>
>>>> Does anyone know if any kernel supports CIFS w/out crashing? I'd l=
ike to
>>>> backup some CIFS shares, thanks.
>>>>
>>>>
>>>> mount -t cifs //w2/x /mnt -o user=3Duser,pass=3Dpass
>>>>
>>>> [ =A0881.388836] CIFS VFS: cifs_mount failed w/return code =3D -22
>>>
>>> =A0 =A0 =A0 =A0:::
>>>
>>> Since it failed mounting, this patch will help you. Although the pa=
tch
>>> will fix one bug, there still may exist another problem.
>>>
>>> http://marc.info/?l=3Dlinux-cifs&m=3D131345112022031&w=3D2
>>
>> Hi,
>>
>> Latest patch (this one) applied to linux-3.1-rc2 works, at least it
>> mounted
>> this time and did not instantly crash the kernel!
>>
>> I also tried the hostname again (and it did not crash the kernel, bu=
t it
>> failed to mount).
>>
>> Used the IP and it mounted successfully:
>> //10.0.0.11/x =A0 =A0 =A0 =A0 =A028T =A05.0T =A0 23T =A019% /mnt
>> //10.0.0.11/y =A0 =A0 =A0 =A0 =A019T =A01.2T =A0 18T =A0 7% /mnt2
>>
>> It has not crashed yet (which is good), I'll apply this patch to my
>> production machine and test taking backups of this data and let you =
know
>> if it crashes again, thanks!
>>
>> Justin.
>
>
> Hello,
>
> It is working but very slowly:
>
> Device eth6 [10.0.1.2] (1/1):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Incoming: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 Outgoing:
> Curr: 37.60 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Curr: 0.4=
4 MByte/s
> Avg: 4.98 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Avg: 0.=
09 MByte/s
> Min: 0.00 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Min: 0.=
00 MByte/s
> Max: 40.79 MByte/s =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Max: 0.=
48 MByte/s
> Ttl: 1.45 GByte =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Ttl: =
26.77 MByte
>
> Over 10GbE the other direction (Linux -> Windows (via Samba)) I get
> 500MiB/s, is CIFS slow?
>
> I'll look into options to tweak the speed but this is very poor speed=
 when
> you have to transfer 5-10TB. =A0However, it is not crashing anymore, =
so any
> speed is better than that :)
>
> Justin.
>
>



--=20
Thanks,

Steve
