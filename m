From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part (try #2)
Date: Fri, 22 Apr 2011 10:10:50 -0400
Message-ID: <20110422101050.1472e618@tlielax.poochiereds.net>
References: <1302635430-3575-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=7eNfZXZPWYoPYY1CWsKqwvXkKNA@mail.gmail.com>
	<BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw@mail.gmail.com>
	<20110422075007.2e9c303b@tlielax.poochiereds.net>
	<BANLkTinMswT8Sur+Kv5JGb3jbObKnSC1mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinMswT8Sur+Kv5JGb3jbObKnSC1mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Apr 2011 09:02:18 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Apr 22, 2011 at 6:50 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 22 Apr 2011 12:09:20 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> After conversation with Steve, we decided to drop
> >> filemap_write_and_wait from getattr, because we already do it in
> >> cifs_file_aio_write. I also think that we should drop it from
> >> cifs_llseek in this case too. I will repost this patch later (launder
> >> page operation patch was merged earlier).
> >>
> >
> > I wasn't privy to this discussion, but that makes no sense to me. Just
> > because we initiated writeout in cifs_file_aio_write, does not mean
> > that it's complete. If it's not complete then the size returned by the
> > server may be bogus.
> 
> What would a local file system do in the case when a write is
> racing with a getattr?  In the case of cifs, when we issue
> a write, and don't have oplock, we immediately send the
> write on the network - but AFAIK posix provides no guarantees
> about ordering if they are issued at the same time.
> 

It's not a problem for a local filesystem as there's only one set of
metadata to deal with. Even if the writes aren't synced out to disk,
you still know how big the file is.

With a client/server setup like cifs or nfs, you have to deal with two,
and when there are buffered writes then there will be discrepancies.
The simplest way to deal with discrepancies there is to make sure
that there aren't any by flushing out any buffered writes before
fetching the attributes.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
