From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 4/5] cifs: add wrapper for cifs_async_readv to retry opening file
Date: Fri, 13 Apr 2012 22:23:21 -0400
Message-ID: <1334370202-30711-5-git-send-email-jlayton@redhat.com>
References: <1334370202-30711-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334370202-30711-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need this same bit of code for the uncached case.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ae285e0..d2a4259 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2366,6 +2366,23 @@ cifs_readdata_release(struct kref *refcount)
 	kfree(rdata);
 }
 
+static int
+cifs_retry_async_readv(struct cifs_readdata *rdata)
+{
+	int rc;
+
+	do {
+		if (rdata->cfile->invalidHandle) {
+			rc = cifs_reopen_file(rdata->cfile, true);
+			if (rc != 0)
+				continue;
+		}
+		rc = cifs_async_readv(rdata);
+	} while (rc == -EAGAIN);
+
+	return rc;
+}
+
 static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
@@ -2852,15 +2869,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		rdata->marshal_iov = cifs_readpages_marshal_iov;
 		list_splice_init(&tmplist, &rdata->pages);
 
-		do {
-			if (open_file->invalidHandle) {
-				rc = cifs_reopen_file(open_file, true);
-				if (rc != 0)
-					continue;
-			}
-			rc = cifs_async_readv(rdata);
-		} while (rc == -EAGAIN);
-
+		rc = cifs_retry_async_readv(rdata);
 		if (rc != 0) {
 			list_for_each_entry_safe(page, tpage, &rdata->pages,
 						 lru) {
-- 
1.7.7.6
