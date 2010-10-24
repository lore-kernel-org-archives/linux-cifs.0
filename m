From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/13] cifs: convert cifsFileInfo->count to non-atomic
 counter
Date: Sat, 23 Oct 2010 21:09:16 -0400
Message-ID: <20101023210916.4a5b2495@tlielax.poochiereds.net>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
	<1287171248-464-12-git-send-email-jlayton@redhat.com>
	<AANLkTimfSq1vrGjcdLRh5+p=t0oF9ouEOzaVsE5vcZBq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimfSq1vrGjcdLRh5+p=t0oF9ouEOzaVsE5vcZBq-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 23 Oct 2010 11:57:52 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Merged.  Made trivial checkpatch cleanup.
> 
> As mentioned earlier, I don't think that this patch helps (atomic_t
> type is small
> on most arch and the atomic operations are single instructions), but is harmless
> and don't won't to create merge conflicts with the next patch so merging this.
> 

Thanks.

atomic_t's are fine for simple counters that don't require locking
around them. They help ensure that the compiler doesn't erroneously
optimize access to the counter when it shouldn't (which would cause
races). This isn't free however -- it comes at a cost (albeit a small
one) in loss of optimization.

If you need to hold a spinlock when you access that variable _anyway_
(and that is the case here), there is no benefit to using an atomic_t
.
It's akin to using both belt and suspenders to hold up your pants.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
