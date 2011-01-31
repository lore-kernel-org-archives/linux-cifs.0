From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix variable types in cifs_iovec_read/write (try #2)
Date: Mon, 31 Jan 2011 16:03:08 +0300
Message-ID: <1296478988-22307-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Variable 'i' should be unsigned long as it's used in circle with num_pages,
and bytes_read/total_written should be ssize_t according to return value.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 74c0a28..e964b1c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1662,10 +1662,10 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written = 0;
-	unsigned int written = 0;
-	unsigned long num_pages, npages;
-	size_t copied, len, cur_len, i;
+	unsigned int written;
+	unsigned long num_pages, npages, i;
+	size_t copied, len, cur_len;
+	ssize_t total_written = 0;
 	struct kvec *to_send;
 	struct page **pages;
 	struct iov_iter it;
@@ -1821,7 +1821,8 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 {
 	int rc;
 	int xid;
-	unsigned int total_read, bytes_read = 0;
+	ssize_t total_read;
+	unsigned int bytes_read = 0;
 	size_t len, cur_len;
 	int iov_offset = 0;
 	struct cifs_sb_info *cifs_sb;
-- 
1.7.1
