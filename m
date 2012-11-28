From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Fix write after setting a read lock for read
 oplock files
Date: Wed, 28 Nov 2012 07:37:39 -0500
Message-ID: <20121128073739.3af20c79@tlielax.poochiereds.net>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
	<1353999029-3975-6-git-send-email-piastry@etersoft.ru>
	<20121127075203.7b0d8de6@tlielax.poochiereds.net>
	<CAKywueSb3q3-6whESnqrvPc2o0ka8GZepz0JmQGTzyRki4Bh1Q@mail.gmail.com>
	<20121128063614.12d7b0a7@tlielax.poochiereds.net>
	<CAKywueTrxSGbzm7V402M9sHiNAs8+TcpcWLqkV+2XswntJABEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTrxSGbzm7V402M9sHiNAs8+TcpcWLqkV+2XswntJABEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Nov 2012 16:12:56 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/11/28 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Tue, 27 Nov 2012 18:57:22 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> 2012/11/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> > On Tue, 27 Nov 2012 10:50:28 +0400
> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >> >
> >> >> If we have a read oplock and set a read lock in it, we can't write to the
> >> >> locked area - so, filemap_fdatawrite may fail with a no information for a
> >> >> userspace application even if we request a write to non-locked area. Fix
> >> >> this by replacing it with filemap_write_and_wait call and sending non-page
> >> >> write in a error case.
> >> >>
> >> >> While this may end up with two write requests to the server, we can be sure
> >> >> that our data will be the same at the server and the page cache - the next read
> >> >> on this file gets the valid data.
> >> >>
> >> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> >> ---
> >> >>  fs/cifs/file.c |   10 ++++------
> >> >>  1 file changed, 4 insertions(+), 6 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> >> index f8fe1bd..89efd85 100644
> >> >> --- a/fs/cifs/file.c
> >> >> +++ b/fs/cifs/file.c
> >> >> @@ -2511,14 +2511,12 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
> >> >>        */
> >> >>       if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
> >> >>               ssize_t written;
> >> >> -             int rc;
> >> >>
> >> >>               written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> >> >> -             rc = filemap_fdatawrite(inode->i_mapping);
> >> >> -             if (rc)
> >> >> -                     return (ssize_t)rc;
> >> >> -
> >> >> -             return written;
> >> >> +             /* try page write at first */
> >> >> +             if (!filemap_write_and_wait(inode->i_mapping))
> >> >> +                     return written;
> >> >> +             /* page write failed - try from pos to pos+len-1 */
> >> >>       }
> >> >>  #endif
> >> >>
> >> >
> >> > Bleh -- nasty. I guess this will work though...
> >> >
> >> > Wonder if there's some way to populate the cache and then just mark the
> >> > pages clean without sending out writes? That would be a better solution
> >> > IMO, but I guess we can live with this for now...
> >> >
> >> > Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >> Thanks for reviewing the patchset.
> >>
> >> As for this patch I have the followon patch:
> >>
> >> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commitdiff;h=11673376e6840c686f0c6e51892b16ad1945887e
> >>
> >> that allows us to populate the page cache without making pages dirty.
> >> I didn't have enough time to test it well (that's why I haven't posted
> >> it yet)  - going to do it tomorrow. But you are welcome to comment the
> >> approach.
> >>
> >
> > The only thing that makes me wary here is that you're setting this flag
> > on the inode. Could there ever be a situation where another task might
> > be writing to this inode at the same time and needs to set them dirty?
> >
> > If not, then I'm not sure I see the need for a new bool in the inode.
> > It might be simpler to just check what sort of oplock you have in
> > write_end instead.
> >
> > There's also a lot of logic around what sort of locking you're doing
> > here too. I think we ought to do the same sort of I/O regardless of
> > whether POSIX locks are being used or not.
> >
> 
> There are some places where VFS code uses write_end call (through
> pagecache_write_end) but I didn't find any place where cifs code can
> hit it. So, I think we can assume now that cifs_write_end is called
> only from generic_file_aio_write codepath. If so, we can be sure that
> only on process may want to set pages dirty through cifs_write_end due
> to i_mutex lock.
> 
> It seems your are right and we can use clientCanCacheAll value
> directly from cifs_write_end - will make changes. Also, I think I can
> merge these two patches into one.
> 
> Thanks.
> 

Note though, that it matters what sort of cache= option is in force
too. If cache=loose then you *do* want to set the page dirty.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
