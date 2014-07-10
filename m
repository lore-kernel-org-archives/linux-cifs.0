From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 6/7] CIFS: Optimize cifs_user_read() in a short read case on reconnects
Date: Thu, 10 Jul 2014 13:30:46 +0400
Message-ID: <1404984647-8710-7-git-send-email-pshilovsky@samba.org>
References: <1404984647-8710-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404984647-8710-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by filling the output buffer with a data got from a partially received
response and requesting the remaining data from the server.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6896cb5..d7246cb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3029,13 +3029,30 @@ again:
 			else if (rdata->result == -EAGAIN) {
 				/* resend call if it's a retryable error */
 				struct list_head tmp_list;
+				unsigned int got_bytes = rdata->got_bytes;
 
 				list_del_init(&rdata->list);
 				INIT_LIST_HEAD(&tmp_list);
 
-				rc = cifs_send_async_read(rdata->offset,
-						rdata->bytes, rdata->cfile,
-						cifs_sb, &tmp_list);
+				/*
+				 * Got a part of data and then reconnect has
+				 * happened -- discard anything left and return
+				 * a short read.
+				 */
+				if (got_bytes && got_bytes < rdata->bytes) {
+					rc = cifs_readdata_to_iov(rdata, to);
+					if (rc) {
+						kref_put(&rdata->refcount,
+						cifs_uncached_readdata_release);
+						continue;
+					}
+				}
+
+				rc = cifs_send_async_read(
+						rdata->offset + got_bytes,
+						rdata->bytes - got_bytes,
+						rdata->cfile, cifs_sb,
+						&tmp_list);
 
 				list_splice(&tmp_list, &rdata_list);
 
-- 
1.8.1.2
