From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Recvfile patch used for Samba.
Date: Tue, 23 Jul 2013 14:58:58 -0700
Message-ID: <20130723215858.GB16356@samba2>
References: <20130722215738.GB20647@samba2>
 <20130723071027.GJ19986@dastard>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130723071027.GJ19986@dastard>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jul 23, 2013 at 05:10:27PM +1000, Dave Chinner wrote:
> So, we are nesting up to 32 page locks here. That's bad. And we are
> nesting kmap() calls for all the pages individually - is that even
> safe to do?
> 
> So, what happens when we've got 16 pages in, and the filesystem has
> allocated space for those 16 blocks, and we get ENOSPC on the 17th?
> Sure, you undo the state here, but what about the 16 blocks that the
> filesystem has allocated to this file? There's no notification to
> the filesystem that they need to be truncated away because the write
> failed....
> 
> > +
> > +	/* IOV is ready, receive the date from socket now */
> > +	msg.msg_name = NULL;
> > +	msg.msg_namelen = 0;
> > +	msg.msg_iov = (struct iovec *)&iov[0];
> > +	msg.msg_iovlen = cPagesAllocated ;
> > +	msg.msg_control = NULL;
> > +	msg.msg_controllen = 0;
> > +	msg.msg_flags = MSG_KERNSPACE;
> > +	rcvtimeo = sock->sk->sk_rcvtimeo;    
> > +	sock->sk->sk_rcvtimeo = 8 * HZ;
> 
> We can hold the inode and the pages locked for 8 seconds?
> 
> I'll stop there. This is fundamentally broken. It's an attempt to do
> a multi-page write operation without any of the supporting
> structures needed to handle the failure cases properly.  The nested
> page locking has "deadlock" written all over it, and the lack of
> partial failure handling shouts "data corruption" and "stale data
> exposure" to me. The fact it can block for up to 8 seconds waiting
> for network shenanigans to be completed while holding lots of locks
> is going to cause all sorts of problems under memory pressure.
> 
> Not to mention it means that all memory allocations in the msgrcv
> path need to be done with GFP_NOFS, because GFP_KERNEL allocations
> are almost guaranteed to deadlock on the locked pages this path
> already holds....
> 
> Need I say more?

No, that's great ! :-).

Thanks for the analysis. I'd heard it wasn't
near production quality, but not being a kernel
engineer myself I wasn't able to make that assessment.

Having said that the OEMs that are using it does
find it improves write speeds by a large amount (10%
or more), so it's showing there is room for improvement
here if the correct code can be created for recvfile.

Cheers,

Jeremy.
