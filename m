From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Mon, 4 Oct 2010 13:05:34 -0400
Message-ID: <20101004170534.GA25799@infradead.org>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
 <AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
 <20100924141137.4cb03197@tlielax.poochiereds.net>
 <20100925042330.GA11930@infradead.org>
 <20100925081644.777952fe@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100925081644.777952fe-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Sep 25, 2010 at 08:16:44AM -0400, Jeff Layton wrote:
> Hmm...there is one problem with this scheme. __fput ignores the error
> return from ->release. Only the errors from ->flush will be returned to
> userspace. So if we only filemap_fdatawait in the ->release op, then we
> have the potential to miss returning writeback-related errors on a
> close call.
> 
> On a side note, why does f_op->release return an int? Are there places
> in the kernel besides __fput that call it? If not, maybe we should
> consider changing it to a void function to make this more clear.

If I remember correctly actually returning errors from ->release
actually caused problems with various bits of userspace software.  I'd
need to check the commit logs for details.  No idea why these problems
don't appear for ->flush or why we've never bothered to change the
->release prototype.
