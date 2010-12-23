From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 15/18] cifs: reconnect unresponsive servers
Date: Thu, 23 Dec 2010 08:20:05 -0500
Message-ID: <20101223082005.347b8ca8@barsoom.rdu.redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
	<1292598497-29796-16-git-send-email-jlayton@redhat.com>
	<4D1324EC.8010305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D1324EC.8010305-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Dec 2010 16:01:08 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 12/17/2010 08:38 PM, Jeff Layton wrote:
> > If the server isn't responding to echoes, we don't want to leave tasks
> > hung waiting for it to reply. At that point, we'll want to reconnect
> > so that soft mounts can return an error to userspace quickly.
> > 
> > If the client hasn't received a reply after 3 echo intervals, assume
> > that the transport is down and attempt to reconnect the socket.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/connect.c |   23 +++++++++++++++++++----
> >  1 files changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 20f6eda..2ad3c67 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -55,6 +55,9 @@
> >  /* SMB echo "timeout" -- FIXME: tunable? */
> >  #define SMB_ECHO_INTERVAL (60 * HZ)
> >  
> > +/* reconnect if no response from server in this time period */
> > +#define UNRESPONSIVE_SERVER_TIMEOUT (5 * SMB_ECHO_INTERVAL)
> > +
> 
> It's not clear to me why is this timeout is set to be
> 5 * SMB_ECHO_INTERVAL?
> 

My bad... I should have updated the patch description. When testing
this I experimented with a range of 2 to 5 times.

There is no "correct" value for this. It really comes down to a
judgement call. Reducing that value means that you'll return an error
to the caller more quickly on a soft mount timeout occurs. The downside
is that you'll issue reconnects more frequently when there's a temporary
network partition.

I tend to think that we're better off running with a larger value for
this (around 5*). Reconnects are terribly expensive and lock
reclaimation in Linux cifs is non-existent. Avoiding reconnects as much
as possible is preferable so making this as high as we can get away
with is a good thing.

That said, I'm open to suggestions on this. I think we shouldn't go
below 3*,  and above 5* is probably too much. We could eventually make
it tunable, but we still need a default. I don't think it should be a
mount option since it's a per-socket setting (mounts with different
timeouts wouldn't be able to share sockets), so maybe a module option
would be best.

Thoughts?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
