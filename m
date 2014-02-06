From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: clean up page array when uncached write send fails
Date: Thu,  6 Feb 2014 14:42:44 -0500
Message-ID: <1391715764-21225-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the event that a send fails in an uncached write, or we end up
needing to reissue it (-EAGAIN case), we'll kfree the wdata but
the pages currently leak.

Fix this by adding a new kref release routine for uncached writedata
that releases the pages, and have the uncached codepaths use that.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 853d6d1..d76c935 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2331,9 +2331,20 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 }
 
 static void
-cifs_uncached_writev_complete(struct work_struct *work)
+cifs_uncached_writedata_release(struct kref *refcount)
 {
 	int i;
+	struct cifs_writedata *wdata = container_of(refcount,
+					struct cifs_writedata, refcount);
+
+	for (i = 0; i < wdata->nr_pages; i++)
+		put_page(wdata->pages[i]);
+	cifs_writedata_release(refcount);
+}
+
+static void
+cifs_uncached_writev_complete(struct work_struct *work)
+{
 	struct cifs_writedata *wdata = container_of(work,
 					struct cifs_writedata, work);
 	struct inode *inode = wdata->cfile->dentry->d_inode;
@@ -2347,12 +2358,7 @@ cifs_uncached_writev_complete(struct work_struct *work)
 
 	complete(&wdata->done);
 
-	if (wdata->result != -EAGAIN) {
-		for (i = 0; i < wdata->nr_pages; i++)
-			put_page(wdata->pages[i]);
-	}
-
-	kref_put(&wdata->refcount, cifs_writedata_release);
+	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 }
 
 /* attempt to send write to server, retry on any -EAGAIN errors */
@@ -2454,7 +2460,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
 		rc = cifs_uncached_retry_writev(wdata);
 		if (rc) {
-			kref_put(&wdata->refcount, cifs_writedata_release);
+			kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 			break;
 		}
 
@@ -2496,7 +2502,7 @@ restart_loop:
 			}
 		}
 		list_del_init(&wdata->list);
-		kref_put(&wdata->refcount, cifs_writedata_release);
+		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
 	if (total_written > 0)
-- 
1.8.5.3
