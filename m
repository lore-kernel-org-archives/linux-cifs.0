From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: use the server's MaxMpxCount to determine max
 requests in flight
Date: Fri, 6 May 2011 07:01:48 -0400
Message-ID: <20110506070148.5363ee2a@tlielax.poochiereds.net>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
	<1304345069-2441-9-git-send-email-jlayton@redhat.com>
	<BANLkTinJHDQup-QwRNrZF19L_VycUCf1Jw@mail.gmail.com>
	<20110504070955.07d9420f@tlielax.poochiereds.net>
	<BANLkTimbNy+v-B2jzYH1hnEjtaKij5n6_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimbNy+v-B2jzYH1hnEjtaKij5n6_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 5 May 2011 21:38:47 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, May 4, 2011 at 6:09 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 4 May 2011 14:38:07 +0400
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> 2011/5/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> > Currently, we have a default cap of 50 outstanding requests and a hard
> >> > cap of 256. However, the server sends us how many requests it can handle
> >> > simultaneously via the MaxMapCount value in the NegProt request. Use
> >> > that value instead and eliminate the cifs_max_pending module parm.
> >> >
> >> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >>
> >> If we ignore this limit for Echo request, can a server drop a
> >> connection if we send, e.g. maxReq write requests and 1 Echo request?
> >> http://msdn.microsoft.com/en-us/library/ee441946(v=PROT.13).aspx
> >> doesn't mention about any exceptions for Echo request in this case.
> >>
> >
> > Well, we currently ignore this for oplock breaks too...
> >
> > I suppose we probably ought to have a small number of slots kept in
> > reserve for echoes and oplock breaks. Instead of just ignoring the
> > limit for those we can allow these calls access to those "emergency"
> > slots.
> 
> Two reserved slots:    1 for oplock break, 1 for echo.
> 
> Note that if maxmpx is set to 2 on negotiate, we also have to disable
> oplock (echo + 1 pending open request would max out our maxmpx)
> 

Right.

I think I'm just going to end up dropping this patch from the set. It's
not really required for this and it probably deserves to be a separate
set of patches.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
