From: "Matthew M. DeLoera" <mdeloera-CERpylIU+L8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Terminate 5 minute timeout for CIFS mount to missing server in stab?
Date: Tue, 27 Nov 2012 08:58:41 -0500
Message-ID: <811AE6D4-30BA-44CF-9D8E-D5DA4FD24115@exacq.com>
References: <1296DFE4-00F0-43E0-A554-1414D53F077D@exacq.com> <20121127062051.382b5462@tlielax.poochiereds.net>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121127062051.382b5462-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm testing in an older kernel - 2.6.15-55-386. While mount sits and waits, I see cifsoplockd and cifsnotifyd, but no cifsd. And no /proc/PID/stack for either. When I kill mount -a, both of those cifs daemons remain running (both sleeping).

I then tried later 2.6.24-24-generic kernel and got same behavior.

Either way, for the record, cifsnotifyd was already running. Once I started mount, then cifsoplockd started.

Now in an even newer kernel, 2.6.32-15.generic, I get much quicker timeout - just over 30 seconds.

I still have to work with the older kernels I mentioned, though I'm glad to see the behavior in 32-15. And FYI, I never saw cifsd running in 32-15.

Agreed about kill -9. It seems like cifs timeout behavior must have changed along the way, but my kernels span about 6 years, so that doesn't surprise me. But since I am still stuck with the older kernels I mentioned, is there something better that I could do, or just settle for kill -9 and allow enough time for newer kernels to timeout? Is there a way that I might be able to detect what timeout value I might expect?

Cheers,
- Matthew


On Nov 27, 2012, at 6:20 AM, Jeff Layton wrote:

>> 
> 
> What kernel is this? kill -9'ing the process likely won't hurt
> anything, but it's not really a great solution.
> 
> That doesn't sound related to the fact that we wait indefinitely for
> responses since the connection is presumably not even established yet.
> 
> cifs.ko is a fairly naive user of the socket APIs in the kernel and
> does a blocking connect call to connect to the socket. That said, it
> should be timing out a lot more quickly than that:
> 
>        socket->sk->sk_rcvtimeo = 7 * HZ;
>        socket->sk->sk_sndtimeo = 5 * HZ;
> 
> A connect attempt shouldn't be hanging for 5 minutes. I'd suggest doing
> a bit more investigation -- track down the [cifsd] kthread and see what
> it's doing at the time. Something like:
> 
>    # cat /proc/$(pidof cifsd)/stack
> 
> 
> -- 
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
