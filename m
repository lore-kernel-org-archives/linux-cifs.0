From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Mon, 4 Oct 2010 13:22:47 -0400
Message-ID: <20101004132247.732c5037@tlielax.poochiereds.net>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
	<AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
	<20100924141137.4cb03197@tlielax.poochiereds.net>
	<20100925042330.GA11930@infradead.org>
	<20100925081644.777952fe@corrin.poochiereds.net>
	<20101004170534.GA25799@infradead.org>
	<20101004132057.5f76b550@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101004132057.5f76b550-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 4 Oct 2010 13:20:57 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 4 Oct 2010 13:05:34 -0400
> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > On Sat, Sep 25, 2010 at 08:16:44AM -0400, Jeff Layton wrote:
> > > Hmm...there is one problem with this scheme. __fput ignores the error
> > > return from ->release. Only the errors from ->flush will be returned to
> > > userspace. So if we only filemap_fdatawait in the ->release op, then we
> > > have the potential to miss returning writeback-related errors on a
> > > close call.
> > > 
> > > On a side note, why does f_op->release return an int? Are there places
> > > in the kernel besides __fput that call it? If not, maybe we should
> > > consider changing it to a void function to make this more clear.
> > 
> > If I remember correctly actually returning errors from ->release
> > actually caused problems with various bits of userspace software.  I'd
> > need to check the commit logs for details.  No idea why these problems
> > don't appear for ->flush or why we've never bothered to change the
> > ->release prototype.
> 
> I asked Al about it, and he basically said that it had been an int
> return for a long, long time. By the time we get to ->release it's far
> too late to really be able to do anything about an error, so there's
> really no benefit to keeping it an int return.
> 
> The only obstacle is code churn. I also suspect that a lot of ->release
> ops return an error, thinking it'll do something too. What Al suggested
> for a first step was to add a WARN() or something whenever a ->release
> op returns non-zero. I'm not looking to tackle that myself at the
> moment however. ;)
> 

For CIFS though, this means that we really do need to wait for
writeback to complete in the ->flush operation.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
