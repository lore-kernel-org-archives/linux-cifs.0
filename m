From: Dave Chinner <david@fromorbit.com>
Subject: Re: Recvfile patch used for Samba.
Date: Wed, 24 Jul 2013 12:47:23 +1000
Message-ID: <20130724024723.GL19986@dastard>
References: <20130722215738.GB20647@samba2>
 <20130723071027.GJ19986@dastard>
 <20130723215858.GB16356@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@samba.org>,
	linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jeremy Allison <jra@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130723215858.GB16356@samba2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Jul 23, 2013 at 02:58:58PM -0700, Jeremy Allison wrote:
> On Tue, Jul 23, 2013 at 05:10:27PM +1000, Dave Chinner wrote:
> > So, we are nesting up to 32 page locks here. That's bad. And we are
> > nesting kmap() calls for all the pages individually - is that even
> > safe to do?
> > 
> > So, what happens when we've got 16 pages in, and the filesystem has
> > allocated space for those 16 blocks, and we get ENOSPC on the 17th?
> > Sure, you undo the state here, but what about the 16 blocks that the
> > filesystem has allocated to this file? There's no notification to
> > the filesystem that they need to be truncated away because the write
> > failed....
> > 
> > > +
> > > +	/* IOV is ready, receive the date from socket now */
> > > +	msg.msg_name = NULL;
> > > +	msg.msg_namelen = 0;
> > > +	msg.msg_iov = (struct iovec *)&iov[0];
> > > +	msg.msg_iovlen = cPagesAllocated ;
> > > +	msg.msg_control = NULL;
> > > +	msg.msg_controllen = 0;
> > > +	msg.msg_flags = MSG_KERNSPACE;
> > > +	rcvtimeo = sock->sk->sk_rcvtimeo;    
> > > +	sock->sk->sk_rcvtimeo = 8 * HZ;
> > 
> > We can hold the inode and the pages locked for 8 seconds?
> > 
> > I'll stop there. This is fundamentally broken. It's an attempt to do
> > a multi-page write operation without any of the supporting
> > structures needed to handle the failure cases properly.  The nested
> > page locking has "deadlock" written all over it, and the lack of
> > partial failure handling shouts "data corruption" and "stale data
> > exposure" to me. The fact it can block for up to 8 seconds waiting
> > for network shenanigans to be completed while holding lots of locks
> > is going to cause all sorts of problems under memory pressure.
> > 
> > Not to mention it means that all memory allocations in the msgrcv
> > path need to be done with GFP_NOFS, because GFP_KERNEL allocations
> > are almost guaranteed to deadlock on the locked pages this path
> > already holds....
> > 
> > Need I say more?
> 
> No, that's great ! :-).
> 
> Thanks for the analysis. I'd heard it wasn't
> near production quality, but not being a kernel
> engineer myself I wasn't able to make that assessment.
> 
> Having said that the OEMs that are using it does
> find it improves write speeds by a large amount (10%
> or more), so it's showing there is room for improvement
> here if the correct code can be created for recvfile.

10% is not very large gain given the complexity it adds, and I
question that the gain actually comes from moving the memcpy() into
the kernel.  If this recvfile code enabled zero-copy behaviour into
the page cache, then it would be worth pursuing. But it doesn't, and
so IMO the complexity is not worth the gain right now.

Indeed, I suspect the 10% gain will be from the multi-page write
behaviour that was hacked into the code. I wrote a multi-page
write prototype ~3 years ago that showed write(2) performance gains
of roughly 10% on low CPU power machines running XFS.

$ git branch |grep multi
  multipage-write
$ git checkout multipage-write 
Checking out files: 100% (45114/45114), done.
Switched to branch 'multipage-write'
$ head -4 Makefile 
VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 37
EXTRAVERSION = -rc6
$

I should probably pick this up again and push it forwards. FWIW,
I've attached the first multipage-write infrastructure patch from
the above branch to show how this sort of operation needs to be done
from a filesystem and page-cache perspective to avoid locking
problems have sane error handling.

I beleive the version that Christoph implemented for a couple of
OEMs around that time de-multiplexed the ->iomap method....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

multipage-write: introduce iomap infrastructure

From: Dave Chinner <dchinner@redhat.com>

Add infrastructure for multipage writes by defining the mapping interface
that the multipage writes will use and the main multipage write loop.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76041b6..1196877 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -513,6 +513,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct iomap;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -604,6 +605,9 @@ struct address_space_operations {
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
+
+	int (*iomap)(struct address_space *mapping, loff_t pos,
+			ssize_t length, struct iomap *iomap, int cmd);
 };
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
new file mode 100644
index 0000000..7708614
--- /dev/null
+++ b/include/linux/iomap.h
@@ -0,0 +1,45 @@
+#ifndef _IOMAP_H
+#define _IOMAP_H
+
+/* ->iomap a_op command types */
+#define IOMAP_READ	0x01	/* read the current mapping starting at the
+				   given position, trimmed to a maximum length.
+				   FS's should use this to obtain and lock
+				   resources within this range */
+#define	IOMAP_RESERVE	0x02	/* reserve space for an allocation that spans
+				   the given iomap */
+#define IOMAP_ALLOCATE	0x03	/* allocate space in a given iomap - must have
+				   first been reserved */
+#define	IOMAP_UNRESERVE	0x04	/* return unused reserved space for the given
+				   iomap and used space. This will always be
+				   called after a IOMAP_READ so as to allow the
+				   FS to release held resources. */
+
+/* types of block ranges for multipage write mappings. */
+#define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
+#define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
+#define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
+#define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
+
+struct iomap {
+	sector_t	blkno;	/* first sector of mapping */
+	loff_t		offset;	/* file offset of mapping, bytes */
+	ssize_t		length;	/* length of mapping, bytes */
+	int		type;	/* type of mapping */
+	void		*priv;	/* fs private data associated with map */
+};
+
+static inline bool
+iomap_needs_allocation(struct iomap *iomap)
+{
+	return iomap->type == IOMAP_HOLE;
+}
+
+/* multipage write interfaces use iomaps */
+typedef int (*mpw_actor_t)(struct address_space *mapping, void *src,
+			loff_t pos, ssize_t len, struct iomap *iomap);
+
+ssize_t multipage_write_segment(struct address_space *mapping, void *src,
+			loff_t pos, ssize_t length, mpw_actor_t actor);
+
+#endif /* _IOMAP_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4df44..27e2f7d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/uaccess.h>
 #include <linux/aio.h>
 #include <linux/capability.h>
@@ -2221,10 +2222,14 @@ repeat:
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
-static ssize_t generic_perform_write(struct file *file,
-				struct iov_iter *i, loff_t pos)
+static ssize_t
+__generic_perform_write(
+	struct file		*file,
+	struct address_space	*mapping,
+	struct iov_iter		*i,
+	loff_t			pos,
+	void			*priv)
 {
-	struct address_space *mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	long status = 0;
 	ssize_t written = 0;
@@ -2241,7 +2246,6 @@ static ssize_t generic_perform_write(struct file *file,
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
-		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
@@ -2265,7 +2269,7 @@ again:
 		}
 
 		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
-						&page, &fsdata);
+						&page, priv);
 		if (unlikely(status))
 			break;
 
@@ -2279,7 +2283,7 @@ again:
 
 		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
-						page, fsdata);
+						page, priv);
 		if (unlikely(status < 0))
 			break;
 		copied = status;
@@ -2310,6 +2314,159 @@ again:
 	return written ? written : status;
 }
 
+static int
+multipage_write_actor(
+	struct address_space	*mapping,
+	void			*src,
+	loff_t			pos,
+	ssize_t			length,
+	struct iomap		*iomap)
+{
+	struct iov_iter		*i = src;
+
+	return __generic_perform_write(NULL, mapping, i, pos, iomap);
+}
+
+/*
+ * Execute a multipage write on a segment of the mapping that spans a
+ * contiguous range of pages that have identical block mapping state.
+ * This avoids the need to map pages individually, do individual allocations
+ * for each page and most importantly avoid the need for filesystem specific
+ * locking per page. Instead, all the operations are amortised over the entire
+ * range of pages. It is assumed that the filesystems will lock whatever
+ * resources they require in the IOMAP_READ call, and release them in the
+ * IOMAP_COMPLETE call.
+ */
+ssize_t
+multipage_write_segment(
+	struct address_space	*mapping,
+	void			*src,
+	loff_t			pos,
+	ssize_t			length,
+	mpw_actor_t		actor)
+{
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	long			status;
+	bool			need_alloc;
+	struct iomap		iomap = { 0 };
+
+	/*
+	 * need to map a range from start position for count bytes. This can
+	 * span multiple pages - it is only guaranteed to return a range of a
+	 * single type of pages (e.g. all into a hole, all mapped or all
+	 * unwritten). Failure at this point has nothing to undo.
+	 *
+	 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES pages
+	 * to keep the chunks of work done where somewhat symmetric with the
+	 * work writeback does. This is a completely arbitrary number pulled
+	 * out of thin air as a best guess for initial testing.
+	 */
+	length = min_t(ssize_t, length, 1024 * PAGE_SIZE);
+	status = a_ops->iomap(mapping, pos, length, &iomap, IOMAP_READ);
+	if (status)
+		goto out;
+
+	/*
+	 * If allocation is required for this range, reserve the space now so
+	 * that the allocation is guaranteed to succeed later on. Once we copy
+	 * the data into the page cache pages, then we cannot fail otherwise we
+	 * expose transient stale data. If the reserve fails, we can safely
+	 * back out at this point as there is nothing to undo.
+	 */
+	need_alloc = iomap_needs_allocation(&iomap);
+	if (need_alloc) {
+		status = a_ops->iomap(mapping, pos, length, &iomap, IOMAP_RESERVE);
+		if (status)
+			goto out;
+	}
+
+	/*
+	 * because we have now guaranteed that the space allocation will
+	 * succeed, we can do the copy-in page by page without having to worry
+	 * about failures exposing transient data. Hence we can mostly reuse
+	 * the existing method of:
+	 *	- grab and lock page
+	 *	- set up page mapping structures (e.g. bufferheads)
+	 *	- copy data in
+	 *	- update page state and unlock page
+	 *
+	 * This avoids the need to hold MAX_WRITEBACK_PAGES locked at once
+	 * while we execute the copy-in. It does mean, however, that the
+	 * filesystem needs to avoid any attempts at writeback of pages in this
+	 * iomap until the allocation is completed after the copyin.
+	 *
+	 * XXX: needs to be done per-filesystem in ->writepage
+	 */
+
+	status = actor(mapping, src, pos, length, &iomap);
+	printk("mpws: pos %lld, len %lld, status %lld\n", pos, length, status);
+	if (status == -ERANGE)
+		status = 0;
+	if (status <= 0)
+		goto out_failed_write;
+
+	/* now the data has been copied, allocate the range we've copied */
+	if (need_alloc) {
+		int error;
+		/*
+		 * allocate should not fail unless the filesystem has had a
+		 * fatal error. Issue a warning here to track this situation.
+		 */
+		error = a_ops->iomap(mapping, pos, status, &iomap, IOMAP_ALLOCATE);
+		if (error) {
+			WARN_ON(0);
+			status = error;
+			/* XXX: mark all pages not-up-to-date? */
+			goto out_failed_write;
+		}
+	}
+
+
+out:
+	return status;
+	/*
+	 * if we copied less than we reserved, release any unused
+	 * reservation we hold so that we don't leak the space. Unreserving
+	 * space never fails.
+	 */
+out_failed_write:
+	if (need_alloc)
+		a_ops->iomap(mapping, pos, 0, &iomap, IOMAP_UNRESERVE);
+	return status;
+}
+EXPORT_SYMBOL(multipage_write_segment);
+
+/*
+ * Loop writing multiple pages in segments until we have run out
+ * of data to write in the iovec iterator.
+ */
+static ssize_t
+generic_perform_multipage_write(struct file *file,
+				struct iov_iter *i, loff_t pos)
+{
+	long status = 0;
+	ssize_t written = 0;
+
+	do {
+		status = multipage_write_segment(file->f_mapping, i, pos,
+				iov_iter_count(i), multipage_write_actor);
+		if (status <= 0)
+			break;
+		pos += status;
+		written += status;
+	} while (iov_iter_count(i));
+
+	return written ? written : status;
+}
+
+static ssize_t generic_perform_write(struct file *file,
+				struct iov_iter *i, loff_t pos)
+{
+	void *fs_data;
+
+	return __generic_perform_write(file, file->f_mapping, i, pos, &fs_data);
+}
+
 ssize_t
 generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos, loff_t *ppos,
@@ -2320,13 +2477,17 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	struct iov_iter i;
 
 	iov_iter_init(&i, iov, nr_segs, count, written);
-	status = generic_perform_write(file, &i, pos);
+
+	if (file->f_mapping->a_ops->iomap)
+		status = generic_perform_multipage_write(file, &i, pos);
+	else
+		status = generic_perform_write(file, &i, pos);
 
 	if (likely(status >= 0)) {
 		written += status;
 		*ppos = pos + status;
-  	}
-	
+	}
+
 	return written ? written : status;
 }
 EXPORT_SYMBOL(generic_file_buffered_write);
