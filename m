From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: New read cache mechanism
Date: Sun, 19 Sep 2010 15:16:07 -0700
Message-ID: <20100919151607.23a79112@corrin.poochiereds.net>
References: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH@mail.gmail.com>
	<AANLkTikdQTo8y-zJZ625MCgY15rpYmERGgJKtq=oJ0Wd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikdQTo8y-zJZ625MCgY15rpYmERGgJKtq=oJ0Wd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 19 Sep 2010 09:52:10 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Sep 18, 2010 at 1:32 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Add cifs_sync_read call to provide reading from the cache if we have at least
> > Level II oplock and otherwise - reading from the server.
> 
> This is a stricter guarantee than NFS and will slow performance
> dramatically.  If you are going to prevent all ability to reread a
> page - this should probably be optional.   This affects cases even
> when there are no 2nd clients opening the same file and cases where a
> 2nd client opened a file but never wrote to it.  Note that the common
> case of multiply open files from the same client will break oplock too
> even though there is no caching issue there (much as we would like to
> change the protocol for that - we have to wait until SMB2 until we can
> reaquire or upgrade oplocks).
> 
> Currently we write through all writes when we don't have oplock.   We
> should also invalidate any cached pages when opening a non-cached file
> that has changed since we last opened it - so we will reread these
> pages although they will stay in the page cache.   We should
> invalidate these cached pages whenever mtime changes (even if some
> Windows server defer mtime updates - it will be correct file close or
> sync - which is the only place we have guarantees that data is written
> anyway).  We check mtime updates in revalidate (and this can be
> configured in /proc/fs/cifs to always be sent - rather than every
> second).
> 
> 

I think, before any of this goes in, someone (Pavel?) needs to step back,
and write up (in English) what the caching semantics should be when we
have oplocks of various levels, including none at all. The
documentation could be fairly informal -- maybe just a few paragraphs
in the README, but it needs to be written before we can do any serious
discussion of patches.

As Christoph pointed out, async I/O isn't covered by that patch. We
also need to settle on semantics for mmap. The patches are fine as a
point of reference for discussion, but please don't merge any of this
until we have a clear, consistent goal in mind.

That'll also help us to ensure that we don't cause regressions, and to
make sure that we understand what the performance impacts of these
changes will be.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
