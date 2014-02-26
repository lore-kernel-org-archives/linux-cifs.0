From: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 9/9] iov_iter: Kill written arg to iov_iter_init()
Date: Wed, 26 Feb 2014 15:39:57 -0800
Message-ID: <1393457997-17618-10-git-send-email-kmo@daterainc.com>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Kent Overstreet <kmo@daterainc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.sourceforge.net, Sage Weil <sage@inktank.com>,
	ceph-devel@vger.kernel.org
To: axboe@kernel.dk
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This gets rid of a usually needless call to iov_iter_advance().

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
Cc: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 fs/btrfs/file.c     |  8 +++++---
 fs/ceph/file.c      |  7 ++++---
 fs/cifs/file.c      |  4 ++--
 fs/fuse/file.c      | 11 ++++++-----
 include/linux/uio.h |  9 +++------
 mm/filemap.c        |  4 +++-
 6 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0165b8672f..18b2e127e8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1652,8 +1652,9 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 		return written;
 
 	pos += written;
-	count -= written;
-	iov_iter_init(&i, iov, nr_segs, count, written);
+	iov_iter_init(&i, iov, nr_segs, count);
+	iov_iter_advance(&i, written);
+
 	written_buffered = __btrfs_buffered_write(file, &i, pos);
 	if (written_buffered < 0) {
 		err = written_buffered;
@@ -1768,7 +1769,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	} else {
 		struct iov_iter i;
 
-		iov_iter_init(&i, iov, nr_segs, count, num_written);
+		iov_iter_init(&i, iov, nr_segs, count + num_written);
+		iov_iter_advance(&i, num_written);
 
 		num_written = __btrfs_buffered_write(file, &i, pos);
 		if (num_written > 0)
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index dfd2ce3419..163ae0fe20 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -580,7 +580,7 @@ ceph_sync_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		CEPH_OSD_FLAG_ONDISK |
 		CEPH_OSD_FLAG_WRITE;
 
-	iov_iter_init(&i, iov, nr_segs, count, 0);
+	iov_iter_init(&i, iov, nr_segs, count);
 
 	while (iov_iter_count(&i) > 0) {
 		void __user *data = i.iov->iov_base + i.iov_offset;
@@ -701,7 +701,7 @@ static ssize_t ceph_sync_write(struct kiocb *iocb, const struct iovec *iov,
 		CEPH_OSD_FLAG_WRITE |
 		CEPH_OSD_FLAG_ACK;
 
-	iov_iter_init(&i, iov, nr_segs, count, 0);
+	iov_iter_init(&i, iov, nr_segs, count);
 
 	while ((len = iov_iter_count(&i)) > 0) {
 		size_t left;
@@ -834,7 +834,8 @@ again:
 				goto out;
 		}
 
-		iov_iter_init(&i, iov, nr_segs, len, read);
+		iov_iter_init(&i, iov, nr_segs, len);
+		iov_iter_advance(&i, read);
 
 		/* hmm, this isn't really async... */
 		ret = ceph_sync_read(iocb, &i, &checkeof);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 755584684f..8a03eeb95e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2424,7 +2424,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	else
 		pid = current->tgid;
 
-	iov_iter_init(&it, iov, nr_segs, len, 0);
+	iov_iter_init(&it, iov, nr_segs, len);
 	do {
 		size_t save_len;
 
@@ -2729,7 +2729,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, const struct iovec *iov,
 	unsigned int i;
 
 	/* set up iov_iter and advance to the correct offset */
-	iov_iter_init(&ii, iov, nr_segs, iov_length(iov, nr_segs), 0);
+	iov_iter_init(&ii, iov, nr_segs, iov_length(iov, nr_segs));
 	iov_iter_advance(&ii, pos);
 
 	*copied = 0;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b4c9a14e70..67542da685 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1152,9 +1152,10 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			goto out;
 
 		pos += written;
-		count -= written;
 
-		iov_iter_init(&i, iov, nr_segs, count, written);
+		iov_iter_init(&i, iov, nr_segs, count);
+		iov_iter_advance(&i, written);
+
 		written_buffered = fuse_perform_write(file, mapping, &i, pos);
 		if (written_buffered < 0) {
 			err = written_buffered;
@@ -1174,7 +1175,7 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		written += written_buffered;
 		iocb->ki_pos = pos + written_buffered;
 	} else {
-		iov_iter_init(&i, iov, nr_segs, count, 0);
+		iov_iter_init(&i, iov, nr_segs, count);
 		written = fuse_perform_write(file, mapping, &i, pos);
 		if (written >= 0)
 			iocb->ki_pos = pos + written;
@@ -1300,7 +1301,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 	struct fuse_req *req;
 	struct iov_iter ii;
 
-	iov_iter_init(&ii, iov, nr_segs, count, 0);
+	iov_iter_init(&ii, iov, nr_segs, count);
 
 	if (io->async)
 		req = fuse_get_req_for_background(fc, fuse_iter_npages(&ii));
@@ -2188,7 +2189,7 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 	if (!bytes)
 		return 0;
 
-	iov_iter_init(&ii, iov, nr_segs, bytes, 0);
+	iov_iter_init(&ii, iov, nr_segs, bytes);
 
 	while (iov_iter_count(&ii)) {
 		struct page *page = pages[page_idx++];
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2b99e0d2a1..d653feeeb1 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -67,16 +67,13 @@ size_t iov_iter_copy_from_user(struct page *page,
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
 
-static inline void iov_iter_init(struct iov_iter *i,
-			const struct iovec *iov, unsigned long nr_segs,
-			size_t count, size_t written)
+static inline void iov_iter_init(struct iov_iter *i, const struct iovec *iov,
+				 unsigned long nr_segs, size_t count)
 {
 	i->iov = iov;
 	i->nr_segs = nr_segs;
 	i->iov_offset = 0;
-	i->count = count + written;
-
-	iov_iter_advance(i, written);
+	i->count = count;
 }
 
 static inline size_t iov_iter_count(struct iov_iter *i)
diff --git a/mm/filemap.c b/mm/filemap.c
index 8e509b3225..e756a0cf21 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2385,7 +2385,9 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t status;
 	struct iov_iter i;
 
-	iov_iter_init(&i, iov, nr_segs, count, written);
+	iov_iter_init(&i, iov, nr_segs, count + written);
+	iov_iter_advance(&i, written);
+
 	status = generic_perform_write(file, &i, pos);
 
 	if (likely(status >= 0)) {
-- 
1.9.0

