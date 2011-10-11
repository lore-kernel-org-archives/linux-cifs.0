From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] sunrpc: make rpc_wait_bit_killable handle freeze
 events
Date: Tue, 11 Oct 2011 09:14:04 -0400
Message-ID: <20111011091404.208a03b5@tlielax.poochiereds.net>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
	<1317210761-11518-4-git-send-email-jlayton@redhat.com>
	<20111011061923.GC1377@ucw.cz>
	<20111011061221.2a4a212f@tlielax.poochiereds.net>
	<2E1EB2CF9ED1CB4AA966F0EB76EAB4430B91E852@SACMVEXC2-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Pavel Machek" <pavel-+ZI9xUNit7I@public.gmane.org>, <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <rjw-KKrjLPT3xs0@public.gmane.org>,
	<linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<john-D0fwSNaahy58zQARNC3f2A@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B91E852-hX7t0kiaRRrlMGe9HJ1VYQK/GNPrWCqfQQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 05:52:57 -0700
"Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:

> > -----Original Message-----
> > From: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > Sent: Tuesday, October 11, 2011 6:12 AM
> > To: Pavel Machek
> > Cc: Myklebust, Trond; smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; rjw-KKrjLPT3xs0@public.gmane.org; linux-
> > pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> > nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; john-D0fwSNaahy58zQARNC3f2A@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH 3/4] sunrpc: make rpc_wait_bit_killable handle
> freeze
> > events
> > 
> > On Tue, 11 Oct 2011 08:19:23 +0200
> > Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:
> > 
> > > On Wed 2011-09-28 07:52:40, Jeff Layton wrote:
> > > > Allow the wait_on_bit_killable sleeps in SUNRPC layer to respect
> the
> > > > freezer. This should allow suspend and hibernate events to occur,
> > > > even when there are RPC's pending on the wire.
> > >
> > > Will the RPC protocols used handle that correctly? What will happen
> > > during resume?
> > >
> > 
> > That depends on the state of the socket during resume. If the
> > suspend/resume is quick enough, then the socket may still be
> connected, or
> > if we're using UDP then we might just get the reply and carry on
> successfully.
> > Otherwise, the call will eventually time out, or will be cancelled
> when the
> > kernel finds that the socket has been closed.
> > 
> > Either way, this should do the right thing.
> 
> Well... The problem when this sort of thing happens is with the replay
> cache. If the RPC in question was a mkdir, for instance, then replaying
> the RPC call when you wake up can be problematic because chances are
> that the server will have forgotten who created the directory, and so
> will reply with EEXIST instead of OK.
> However this is a generic problem when the client is unable to talk to
> the server for a while, and is not particular to suspend.
> 

Yeah, that's always a problem. You can hit the same thing if you just
unplug the cable from the network interface at an inopportune time.

I think this patch is really the best we can do under those
circumstances. Eventually we'll all be on 4.1 with sessions and this
problem will go away, right? ;)

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
