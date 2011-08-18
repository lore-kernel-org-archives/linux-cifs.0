From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 12:25:50 -0500
Message-ID: <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>,
	Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1108181314310.7903-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 18, 2011 at 12:16 PM, Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org> wrote:
>
>
> On Thu, 18 Aug 2011, Jeff Layton wrote:
>
>> On Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
>> Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org> wrote:
>>
>>>
>>>
>>> On Thu, 18 Aug 2011, Jeff Layton wrote:
>>>
>>>> On Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
>>>> Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org> wrote:
>>>>
>>>>> Justin.
>>>>>
>>>>
>>>> To be clear -- incoming in this case is reads or writes?
>>>
>>> Reading from the CIFS share (Windows 7).
>>>
>>>>
>>>> Up until 3.0 cifs.ko didn't parallelize writes from a single thread. In
>>>> 3.0 I added a patchset to increase the allowable wsize and to allow the
>>>> kernel to issue writes in parallel.
>>>
>>> Ahh, good to know, have not tried writes yet.
>>>
>>>>
>>>> Reads still suffer from the same problem however. I'm working on a
>>>> patchset that should do the same thing for them, but it requires a
>>>> fairly substantial overhaul of the receive codepaths.
>>>
>>> Ok, that explains it then, thanks.
>
>
> Hi,
>
> Watching the rsync, it ran for a while, then:
>
> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": Cannot
> allocate memory (12)
> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_1.JPG": Cannot
> allocate memory (12)
> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_2.JPG": Cannot
> allocate memory (12)
> rsync: send_files failed to open "/cifs/w1/r1/data/hs12/f4_0.JPG": Cannot
> allocate memory (12)

When we were testing async write to Windows 7 Pavel mentioned to me
another WIndows 7 bug - which may be what you are hitting.

Under stress of simultaneous operations, Windows 7 server will sometimes start
responding with STATUS_INSUFF_SERVER_RESOURCES error code
(mapped to posix error ENOMEM by the Linux cifs kernel client)
He solved it by setting MaxWorkItems to 4096 in the Windows 7 registry.

If anyone knows whether Microsoft has fixed this or has a bug #, let us know
because it is easier to hit with Linux kernel 3.0 and later (to
Windows 7 server).



-- 
Thanks,

Steve
