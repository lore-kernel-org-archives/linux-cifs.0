From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question regarding CIFS cache=loose behavior.
Date: Fri, 21 Mar 2014 07:40:20 -0400
Message-ID: <20140321074020.509eab05@tlielax.poochiereds.net>
References: <201403202103.EIE87056.QVtLHSFMFOOFOJ@I-love.SAKURA.ne.jp>
	<20140320161943.60890dd4@tlielax.poochiereds.net>
	<201403210556.FEI21354.FLJOQMHtSVOFFO@I-love.SAKURA.ne.jp>
	<20140320191013.110276c0@tlielax.poochiereds.net>
	<CAKywueTNDHSGia58AcKwuDtZA2zc_yOQR-iFTPq3XTrYm6bNLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTNDHSGia58AcKwuDtZA2zc_yOQR-iFTPq3XTrYm6bNLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Mar 2014 12:56:34 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2014-03-21 3:10 GMT+04:00 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Fri, 21 Mar 2014 05:56:04 +0900
> > Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org> wrote:
> >
> >> Jeff Layton wrote:
> >> > That's expected behavior. The kernel believes that the file is frozen in
> >> > length so it returns short read() calls until the size is updated.
> >>
> >> The "size is updated" means "stat() detects the growth of file size",
> >> doesn't it? Then, the former is expected behavior.
> >>
> >> >
> >> > cache=loose is very much not recommended for use when you have multiple
> >> > hosts accessing files on the server (or access by processes on the
> >> > server itself). It only gives you "loose" cache coherency. The whole
> >> > point of it is to allow the client to cache data even when the protocol
> >> > says that it shouldn't.
> >>
> >> But why is the latter ( "read() returns non-0 when stat() detects the growth
> >> of file size but the data actually read is '\0'" ) is expected behavior?
> >> It sounds like a bug that the client caches '\0' (data nobody has ever wrote)
> >> instead of '.' (data somebody wrote when the file size grew).
> >>
> >
> > Yeah, that sounds wrong. What should happen is that the cache is
> > invalidated when the size changes. It's possible there is a race in
> > that code however. The locking around it is pretty sloppy...
> 
> When fstat() get a new file size it sets
> CIFS_I(inode)->invalid_mapping to true but do not revalidate the
> cache. Then generic_file_aio_read() reads the wrong data. I think we
> need to check if CIFS_I(inode)->invalid_mapping is true and revalidate
> the cache before calling generic_file_aio_read() in
> file->f_ops->aio_read(). Now cache revalidation happens in lookup/open
> and mmap codepaths only for cache=loose.
> 
> Of course, cache=loose is not recommended for this sort of work flow
> and cache=strict should be used to provide a data coherency between
> several machines.
> 

Ahh right, you're quite correct that we need to revalidate the cache
before doing an aio_read. We should have cifs do something like
nfs_file_read() does...

I also suspect that we have a problem with the invalid_mapping flag
similar to the one NFS had until recently. That was fixed by commit
d529ef83c355. We probably ought to do something similar for cifs.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
