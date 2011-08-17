From: Arnaud Lacombe <lacombar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Wed, 17 Aug 2011 17:11:32 -0400
Message-ID: <CACqU3MXWRRGydeb1g80X8+rdSv0i0UFYQVTm0Eq4bsYnbRwf=w@mail.gmail.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<alpine.DEB.2.02.1108171545190.5877@p34.internal.lan>
	<alpine.DEB.2.02.1108171547110.5877@p34.internal.lan>
	<20110817161349.072e1452@tlielax.poochiereds.net>
	<alpine.DEB.2.02.1108171644050.11234@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108171644050.11234-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On Wed, Aug 17, 2011 at 4:45 PM, Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org=
> wrote:
>
>
> On Wed, 17 Aug 2011, Jeff Layton wrote:
>
>> The crash is happening in the bowels of the slab allocator.
>> Specifically, it looks like it's hitting this:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The slab was either on partial or f=
ree list so
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* there must be at least one object a=
vailable for
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allocation.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(slabp->inuse >=3D cachep->num);
>>
>> ...which looks like maybe the accounting of in-use objects is off. T=
his
>> really sounds like some sort of memory corruption. I've not been abl=
e
>> to reproduce this so far, but I also had someone report panic here t=
hat
>> might be related:
>>
>> =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D731278
>>
>> One thing that might be helpful is turning on page poisoning and
>> redoing this test, that might make it crash sooner and point out the
>> source of the corruption.
>>
>> Even better would be a bisect to track down the cause...
>
>
> Hi Jeff,
>
> root@acerlw:/usr/src/linux# grep CONFIG_PAGE_POISONING .config
> root@acerlw:/usr/src/linux# ls -l ../linux
> lrwxrwxrwx 1 root root 13 Aug 17 14:41 ../linux -> linux-3.1-rc2/
> root@acerlw:/usr/src/linux#
>
> In what kernel is that feature available, or, how do I enable it?
>
It is selected by "Kernel hacking" -> "Debug page memory allocations",
provided your arch support pagealloc debug.

 - Arnaud

> Justin.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
