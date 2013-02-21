From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Thu, 21 Feb 2013 12:13:24 -0500
Message-ID: <20130221121324.53fed8a1@tlielax.poochiereds.net>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
	<CAFB9KM0bJo4NpePoe9aWMZGJ_jfk0W41Thefg7MD=_V+VP98Eg@mail.gmail.com>
	<CAH2r5mtHsOjXjXx5NdHWNzoTmVmny8gSh_Gd1XfHdNfCOHJDyA@mail.gmail.com>
	<20130221112719.2ed40ecf@tlielax.poochiereds.net>
	<CAH2r5mszydSWqVsGTT3cqe_J2oK+k=4=Ly+hiiPs9eNWsZaVZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mszydSWqVsGTT3cqe_J2oK+k=4=Ly+hiiPs9eNWsZaVZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Feb 2013 10:31:24 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Feb 21, 2013 at 10:27 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, 21 Feb 2013 10:00:07 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> We should do some quick performance runs to verify this - but with
> >> corking and uncorking the socket explicitly presumably TCP_NODELAY
> >> should not be needed.
> >>
> >
> > I would think time for that sort of investigation was before you merged
> > the patch that said we were going to remove it. I assumed that since
> > you took that patch, you were OK with it.
> 
> Yes - I am ok with it and it didn't seem to hurt performance.
> Corking/uncorking explicitly makes more sense if the complex network
> layers work as expected - but the problem is that they change so best
> to be safe and at least try some quick tests.
> 
> > In any case, I'll turn this question around...
> >
> > TCP_NODELAY says: Send frames as soon as possible after a sendmsg (or
> > kernel_sendmsg in this case)
> >
> > TCP_CORK says: hold sending until I uncork the socket
> >
> > If the socket is CORK'ed then that overrides TCP_NODELAY (at least in
> > my reading of the code). Since we always cork/uncork the socket now,
> > what possible benefit could there be to keeping the sockopt=TCP_NODELAY
> > option around?
> 
> None if corking/uncorking works as one would intuitively think - but
> the tcp network layers under us are very complicated.
> 
> (I am not objecting to the patch to remove sockopt setting - just want
> to do the simple checks to make sure we don't miss something)
> 

Fair enough, let me know what you find.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
