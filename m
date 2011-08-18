From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 14:54:02 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108181452080.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan> <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
 <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan> <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan> <20110818091140.385a9455@barsoom.rdu.redhat.com>
 <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan> <20110818130408.71c55b96@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108181314310.7903@p34.internal.lan> <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com> <alpine.DEB.2.02.1108181331180.7903@p34.internal.lan>
 <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com> <alpine.DEB.2.02.1108181413030.7903@p34.internal.lan> <20110818145257.035a38e9@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>,
	Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110818145257.035a38e9-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On Thu, 18 Aug 2011, Jeff Layton wrote:

> On Thu, 18 Aug 2011 14:18:15 -0400 (EDT)
> Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org> wrote:
>
>>
>
> Like I said, read performance with cifs.ko just plain sucks currently.
>
> Don't look for cifs.ko to achieve anywhere near NFS' performance unless
> you jump through some very odd hoops (like multithreading your workload
> in userspace, etc). cifs.ko just doesn't do a good job of keeping the
> pipe "stuffed" as most calls are handled synchronously. A single task
> can only handle one call on the wire in most cases. The exception here
> is writes, but that just recently changed...
>
> Reads are done using relatively small buffers and then copied to
> pagecache. Part of what I'm working on will be to allow for much larger
> reads directly into the pagecache. That should also help performance
> significantly.


Jeff,

Understood, thank you for the help thus far and the patch to stop the crashing
kernel problem, it is much appreciated, I'll look forward to the new patch sets
to improve the performance of CIFS mounts.

Justin.

>
