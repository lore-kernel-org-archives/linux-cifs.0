From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Implement cifs_strict_write
Date: Tue, 14 Dec 2010 09:02:26 -0500
Message-ID: <20101214090226.255c3418@tlielax.poochiereds.net>
References: <1292325060-8828-1-git-send-email-piastryyy@gmail.com>
	<1292325060-8828-4-git-send-email-piastryyy@gmail.com>
	<20101214084053.0da711a2@tlielax.poochiereds.net>
	<AANLkTinHKWHff8TzWapRLtX-sA4FK98Ntt+a_Fv8Z5f_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinHKWHff8TzWapRLtX-sA4FK98Ntt+a_Fv8Z5f_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 16:56:03 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/12/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> > On Tue, 14 Dec 2010 14:10:58 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > > If we don't have Exclusive oplock we write a data to the server through
> > > cifs_write. Also set invalidate_mapping flag on the inode if we wrote
> > > something to the server.
> > >
> > > Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  fs/cifs/cifsfs.c    |   74
> > ++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  fs/cifs/cifsproto.h |    3 ++
> > >  fs/cifs/file.c      |    5 +--
> > >  3 files changed, 75 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index a218afe..5df0503 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -572,15 +572,81 @@ cifs_do_mount(struct file_system_type *fs_type,
> > >       return dget(sb->s_root);
> > >  }
> > >
> > > +static ssize_t cifs_strict_write(struct kiocb *iocb, const struct iovec
> > *iov,
> > > +                              unsigned long nr_segs, loff_t pos)
> > > +{
> > > +     struct inode *inode;
> > > +     struct cifs_sb_info *cifs_sb;
> > > +     ssize_t written = 0;
> > > +     unsigned long i, len = 0;
> > > +     char *buf, *offset;
> > > +
> > > +     inode = iocb->ki_filp->f_path.dentry->d_inode;
> > > +
> > > +     if (CIFS_I(inode)->clientCanCacheAll)
> > > +             return generic_file_aio_write(iocb, iov, nr_segs, pos);
> > > +
> > > +     cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> > > +
> > > +     /*
> > > +      * In strict cache mode we need to write the data to the server
> > exactly
> > > +      * from the pos to pos+len-1 rather than flush all affected pages
> > > +      * because it may cause a error with mandatory locks on these pages
> > but
> > > +      * not on the region from pos to ppos+len-1.
> > > +      */
> > > +
> > > +     for (i = 0; i < nr_segs; i++)
> > > +             len += iov[i].iov_len;
> > > +
> > > +     /*
> > > +      * BB - optimize the way when signing is disabled. We can drop this
> > > +      * extra memory-to-memory copying and use iovec buffers for
> > constructing
> > > +      * write request.
> > > +      */
> > > +
> > > +     buf = kmalloc(len, GFP_KERNEL);
> > > +
> >
> > Actually...I thought about another problem here. Suppose an application
> > does a 100M write. This may fail in that case. It varies by the slab
> > allocator in use, but there are limits to how large you can kmalloc.
> > This is especially going to be a problem on 32-bit arches where
> > GFP_KERNEL memory is more limited.
> >
> > There are a couple of different solutions, but I think the best one
> > would be to stitch together individual pages. Walk the iov array first
> > and figure out how many pages you're going to need, and kmalloc an iov
> > array that size. Then start allocating pages (preferably using
> > GFP_HIGHMEM and kmapping them) and then copy the data to them. Stop
> > when you get to the wsize limit, and issue a CIFSSMBWrite2 call. When
> > it returns, pick up where you left off and do it again.
> >
> 
> May be I should allocate buffer of min(wsize, write_len) size, fill it with
> a data to write on cycle and issue a cifs_write with this buffer.
> 
> 1) get write data len into 'len'
> 2) buf = kmalloc(min(wsize, len), GFP_KERNEL)
> 3) last_ind = 0, last_len = iov[0].iov_len
> 4) while (len > 0){
>       cur_len = min(len, last_len)
>       memcpy(buf, iov[last_ind].iov_base + iov[last_ind].iov_len - last_len,
> cur_len)
>       len -= cur_len
>       last_len -= cur_len
>       if (last_len == 0) {
>         last_ind++
>         last_len = iov[last_ind].iov_len
>       }
>       cifs_write(buf)
>    }
> 
> So - it is like the way I do in read part (cifs_fill_iov). Thoughts?
> 

That will work, assuming that you can kmalloc a buffer that size. It's
less of a problem than it used to be, but when you kmalloc you're
asking for contiguous pages. In order to satisfy that, the VM may have
to flush other pages if there is memory pressure.

Large memory allocations in the write codepath are generally a bad
idea. Individual page allocations (particularly from GFP_HIGHMEM) are
almost always able to be satisfied without needing to do things like
flush other stuff out of pagecache.

Also by doing it the way I'm suggesting, you'll eliminate an unneeded
copy of the data too.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
