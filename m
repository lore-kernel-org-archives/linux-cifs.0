From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Fix splice read for non-cached files
Date: Mon, 30 Jan 2017 15:49:49 -0800
Message-ID: <1485820189-11841-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently we call copy_page_to_iter() for uncached reading into a pipe.
This is wrong because it treats pages as VFS cache pages and copies references
rather than actual data. When we are trying to read from the pipe we end up
calling page_cache_pipe_buf_confirm() which returns -ENODATA. This error
is translated into 0 which is returned to a user.

This issue is reproduced by running xfs-tests suite (generic test #249)
against mount points with "cache=none". Fix it by mapping pages manually
and calling copy_to_iter() that copies data into the pipe.

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 18a1e1d..7e23261 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2884,7 +2884,14 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
 	for (i = 0; i < rdata->nr_pages; i++) {
 		struct page *page = rdata->pages[i];
 		size_t copy = min_t(size_t, remaining, PAGE_SIZE);
-		size_t written = copy_page_to_iter(page, 0, copy, iter);
+		size_t written;
+
+		if (unlikely(iter->type & ITER_PIPE)) {
+			void *addr = kmap_atomic(page);
+			written = copy_to_iter(addr, copy, iter);
+			kunmap_atomic(addr);
+		} else
+			written = copy_page_to_iter(page, 0, copy, iter);
 		remaining -= written;
 		if (written < copy && iov_iter_count(iter) > 0)
 			break;
-- 
2.7.4
