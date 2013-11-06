From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Errors writing Large files to CIFS shares
Date: Wed, 6 Nov 2013 06:31:54 -0500
Message-ID: <20131106063154.4ed7452b@tlielax.poochiereds.net>
References: <mailman.1277.1383636787.1861.linux-cifs-client@lists.samba.org>
	<CAHPMNWdLy7cfJdRGp=2-pUQqFO=PgUYT8E2_uW9koNdv1x_D_g@mail.gmail.com>
	<20131105142533.2b9bd00e@tlielax.poochiereds.net>
	<CAHPMNWcY05L+ikBDmOb9SaVM5nA24rY00Hfjy3zjowmaE2p1+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Sikka <neilsikka-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHPMNWcY05L+ikBDmOb9SaVM5nA24rY00Hfjy3zjowmaE2p1+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Nov 2013 20:34:52 -0800
Neil Sikka <neilsikka-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Here are the ping statistics where I starting pinging before I started
> a "cp" of a 32KB file and ending after VFS hung in the copy process:
> 170 packets transmitted, 170 received, 0% packet loss, time 169241ms
> rtt min/avg/max/mdev = 120.447/158.142/397.196/36.544 ms
> 
> The network connection seems fine--there were no dropped packets.
> 
> Although 3.2 is old, it is still more recent than the link i shared
> where they first reported this bug. I would have thought they would
> have fixed this bug or something. Does anyone on this list know the
> what happened to the bug reported
> here (https://bugzilla.redhat.com/show_bug.cgi?id=522867)?
> 
> 
> 

The bug got autoclosed because no one bothered to keep it going (see
comment #5 in that bug).

comment #4 in that bug strongly suggests that the problem was with the
lower-level networking and not really with cifs, per-se. Your problem
may or may not be different. You'll have to do some investigation to be
sure.

cifs.ko's usage of the networking layer is very userland-like. It
really doesn't do much special there. You have these lines in the log
you posted:

[ 2294.192963] CIFS VFS: sends on sock ffff88020e477d40 stuck for 15 seconds
[ 2294.192971] CIFS VFS: Error -11 sending data on socket to server

Basically that means that kernel_sendmsg is continually returning
-EAGAIN. That likely means that the socket send buffer is full,
typically because the server can't be reached or isn't ACK'ing TCP
packets.

If pinging works ok, then your problem may be at the TCP layer.
Possibly a problem related to bufferbloat given that you are running
this over a long-haul link:

    http://en.wikipedia.org/wiki/Bufferbloat

...but it could be something else entirely.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
