From: Dave Chinner <david@fromorbit.com>
Subject: Re: Recvfile patch used for Samba.
Date: Tue, 23 Jul 2013 17:10:27 +1000
Message-ID: <20130723071027.GJ19986@dastard>
References: <20130722215738.GB20647@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@samba.org>,
	linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jeremy Allison <jra@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130722215738.GB20647@samba2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Jul 22, 2013 at 02:57:38PM -0700, Jeremy Allison wrote:
> Hi Steve and Jeff (and others).
> 
> Here is a patch that Samba vendors have been using
> to implement recvfile (copy directly from socket
> to file). It can improve write performance on boxes
> by a significant amount (10% or more).

Is that all? It's just moving the memcpy() into the kernel?

> I'm not qualified to evaluate this code, can someone
> who is (hi there Steve and Jeff :-) take a look at
> this and see if it's work shepherding into the kernel ?

It's pretty nasty.

> 
> Cheers,
> 
> 	Jeremy.

> diff -urp linux-2.6.37-rc5.orig/fs/splice.c linux-2.6.37-rc5/fs/splice.c
> --- linux-2.6.37-rc5.orig/fs/splice.c	2010-12-06 20:09:04.000000000 -0800
> +++ linux-2.6.37-rc5/fs/splice.c	2010-12-07 16:16:48.000000000 -0800
> @@ -31,6 +31,7 @@
>  #include <linux/uio.h>
>  #include <linux/security.h>
>  #include <linux/gfp.h>
> +#include <net/sock.h>
>  
>  /*
>   * Attempt to steal a page from a pipe buffer. This should perhaps go into
> @@ -1387,6 +1388,141 @@ static long do_splice(struct file *in, l
>  	return -EINVAL;
>  }
>  
> +static ssize_t do_splice_from_socket(struct file *file, struct socket *sock,
> +				     loff_t __user *ppos, size_t count)
> +{		
> +	struct address_space *mapping = file->f_mapping;
> +	struct inode	*inode = mapping->host;
> +	loff_t pos;
> +	int count_tmp;
> +	int err = 0;
> +	int cPagePtr = 0;		
> +	int cPagesAllocated = 0;

camel case.

> +	struct recvfile_ctl_blk rv_cb[MAX_PAGES_PER_RECVFILE];

MAX_PAGES_PER_RECVFILE = 32, and the structure is 32 bytes on 64
bit. So 1k of stack usage right there. Bad.

> +	struct kvec iov[MAX_PAGES_PER_RECVFILE];

And that's another 512 bytes of stack. Way too much.

> +	struct msghdr msg;

Another ~52 bytes of stack.

> +	long rcvtimeo;
> +	int ret;
> +
> +	if(copy_from_user(&pos, ppos, sizeof(loff_t)))
> +		return -EFAULT;
> +
> +	if(count > MAX_PAGES_PER_RECVFILE * PAGE_SIZE) {
> +		printk("%s: count(%u) exceeds maxinum\n", __func__, count);
> +		return -EINVAL;
> +	}    
> +	mutex_lock(&inode->i_mutex);

Locking on write needs to be passed to filesystems, not done by
generic code. i.e. this isn't sufficient for XFS, and may also be
problematic for btrfs.

> +
> +	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);

That doesn't exist anymore - it was removed over a year ago....

> +
> +	/* We can write back this queue in page reclaim */
> +	current->backing_dev_info = mapping->backing_dev_info;
> +
> +	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
> +	if (err != 0 || count == 0)
> +		goto done;
> +
> +	file_remove_suid(file);
> +	file_update_time(file);	

error checking?

> +
> +	count_tmp = count;
> +	do {
> +		unsigned long bytes;	/* Bytes to write to page */
> +		unsigned long offset;	/* Offset into pagecache page */
> +		struct page *pageP;

camel case

> +		void *fsdata;
> +
> +		offset = (pos & (PAGE_CACHE_SIZE - 1));
> +		bytes = PAGE_CACHE_SIZE - offset;
> +		if (bytes > count_tmp)
> +			bytes = count_tmp;
> +		ret = mapping->a_ops->write_begin(file, mapping, pos, bytes,
> +						  AOP_FLAG_UNINTERRUPTIBLE,
> +						  &pageP, &fsdata);
> +
> +		if (unlikely(ret)) {
> +			err = ret;
> +			for(cPagePtr = 0; cPagePtr < cPagesAllocated; cPagePtr++) {
> +				kunmap(rv_cb[cPagePtr].rv_page);
> +				ret = mapping->a_ops->write_end(file, mapping,
> +								rv_cb[cPagePtr].rv_pos,
> +								rv_cb[cPagePtr].rv_count,
> +								rv_cb[cPagePtr].rv_count,
> +								rv_cb[cPagePtr].rv_page,
> +								rv_cb[cPagePtr].rv_fsdata);
> +			}
> +			goto done;
> +		}
> +		rv_cb[cPagesAllocated].rv_page = pageP;
> +		rv_cb[cPagesAllocated].rv_pos = pos;
> +		rv_cb[cPagesAllocated].rv_count = bytes;
> +		rv_cb[cPagesAllocated].rv_fsdata = fsdata;
> +		iov[cPagesAllocated].iov_base = kmap(pageP) + offset;
> +		iov[cPagesAllocated].iov_len = bytes;
> +		cPagesAllocated++;
> +		count_tmp -= bytes;
> +		pos += bytes;
> +	} while (count_tmp);

So, we are nesting up to 32 page locks here. That's bad. And we are
nesting kmap() calls for all the pages individually - is that even
safe to do?

So, what happens when we've got 16 pages in, and the filesystem has
allocated space for those 16 blocks, and we get ENOSPC on the 17th?
Sure, you undo the state here, but what about the 16 blocks that the
filesystem has allocated to this file? There's no notification to
the filesystem that they need to be truncated away because the write
failed....

> +
> +	/* IOV is ready, receive the date from socket now */
> +	msg.msg_name = NULL;
> +	msg.msg_namelen = 0;
> +	msg.msg_iov = (struct iovec *)&iov[0];
> +	msg.msg_iovlen = cPagesAllocated ;
> +	msg.msg_control = NULL;
> +	msg.msg_controllen = 0;
> +	msg.msg_flags = MSG_KERNSPACE;
> +	rcvtimeo = sock->sk->sk_rcvtimeo;    
> +	sock->sk->sk_rcvtimeo = 8 * HZ;

We can hold the inode and the pages locked for 8 seconds?

I'll stop there. This is fundamentally broken. It's an attempt to do
a multi-page write operation without any of the supporting
structures needed to handle the failure cases properly.  The nested
page locking has "deadlock" written all over it, and the lack of
partial failure handling shouts "data corruption" and "stale data
exposure" to me. The fact it can block for up to 8 seconds waiting
for network shenanigans to be completed while holding lots of locks
is going to cause all sorts of problems under memory pressure.

Not to mention it means that all memory allocations in the msgrcv
path need to be done with GFP_NOFS, because GFP_KERNEL allocations
are almost guaranteed to deadlock on the locked pages this path
already holds....

Need I say more?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
