From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add support for flock over a cifs mount.
Date: Mon, 14 Nov 2011 13:18:34 +0000
Message-ID: <1321276715.1690.78.camel@sprabhu.fab.redhat.com>
References: <1320696342.1690.19.camel@sprabhu.fab.redhat.com>
	 <CAKywueTSqckM1iVsrEu47RwBA3GnpfZU17QrrNineJBVOcZdvQ@mail.gmail.com>
	 <1320751612.2941.10.camel@localhost>
	 <CAKywueQ65EgLz9iDd2exq85jBMGrBFLiq=mq2dOY9poy3_1h0g@mail.gmail.com>
	 <1320773203.1690.35.camel@sprabhu.fab.redhat.com>
	 <CAKywueSRYxizd+mKw8p93Os0Aqij+R2Dh=2hu6JuJ+bv7S+uWw@mail.gmail.com>
	 <1321020680.1690.57.camel@sprabhu.fab.redhat.com>
	 <CAKywueQwM49dfne1L_d4WVa3zENdshbuuiZ9tVzv=BiF171_8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQwM49dfne1L_d4WVa3zENdshbuuiZ9tVzv=BiF171_8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-11-14 at 16:54 +0400, Pavel Shilovsky wrote:
> 2011/11/11 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Tue, 2011-11-08 at 23:08 +0400, Pavel Shilovsky wrote:
> >
> >> Let's predict the following situation:
> >>
> >> 1) f1 = open(filename)
> >> 2) f2 = open(filename) # the same process
> >> 3) f1.lock(0, 1) # lock file from 0 to 1
> >> 4) f2.lock(1, 2) # lock file from 1 to 2
> >> 5) f1.unlock(0, 2)
> >>
> >> it unlocks both locks (3) and (4) from the VFS cache but unlock only
> >> (3) lock from CIFS-lock cache and server side (see cifs_unlock_range -
> >> it unlocks only locks held by the same fd, not the same process) - the
> >> lock (4) is still there.
> >>
> >> 6) f2.unlock(1, 2)
> >>
> >> it appears into if (unlock) {}, fails on FL_EXISTS with -ENOENT and
> >> goto out. The result we can't unlock the existing lock - the problem!
> >>
> >
> > Hello Pavel,
> >
> > Thanks for your reply.
> >
> > In my opinion this behaviour is wrong. The application running on the
> > Linux box will expect the locking behaviour to follow Posix locking
> > semantics. The current behaviour will break these applications which
> > expect the system to work in this manner.
> >
> > After step 5, the client should unlock the whole range and send 2
> > separate unlock requests to the file server using 2 different netfids if
> > required.
> >
> >
> 
> I agree with you - that's wrong according to POSIX. I only wanted to
> point that your patch can't live with the existing code behavior. May
> be it is the time to change this long life bug.
> 
> I think flock patch should not bring any new behavior (even if it
> fixes something) and should be split into several patches:
> 1) add flock support only (no changes into the existing code behavior);
> 2), 3), ...) - any other changes (bugfixes) you want to make one-by-one.
> 
> It lets us bisect possible problems if they appear to be.
> 

I have a proposed patch but need some additional time to test it before
I send it up. I'll do it as soon as it is ready.

Sachin Prabhu
