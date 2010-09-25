From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Sat, 25 Sep 2010 00:23:30 -0400
Message-ID: <20100925042330.GA11930@infradead.org>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
 <AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
 <20100924141137.4cb03197@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100924141137.4cb03197-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 24, 2010 at 02:11:37PM -0400, Jeff Layton wrote:
> On Fri, 24 Sep 2010 12:58:55 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > We need to see the performance impact.  As you say cifs_writepages is
> > synchronous so we should be ok without it.  Any test results
> > before/after?
> > 
> 
> No, I haven't tested this for performance. It is a correctness issue
> though. We absolutely can't put the last reference to the last open
> filehandle without flushing all of the data first.
> 
> My expectation here though is that this may help performance in some
> cases since this patch also has it skip the flush on files open
> read-only.

->flush is called on every close call, ->release on the last close for a
given file pointer.  Maybe you want a filemap_flush in ->flush and
filemap_write_and_wait in ->release?
