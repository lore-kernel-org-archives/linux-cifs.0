From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 5/7] CIFS: Improve indentation in cifs_user_read()
Date: Mon, 14 Jul 2014 13:01:15 +0400
Message-ID: <1405328477-13484-6-git-send-email-pshilovsky@samba.org>
References: <1405328477-13484-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405328477-13484-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 2927f02..6896cb5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3026,28 +3026,27 @@ again:
 			rc = wait_for_completion_killable(&rdata->done);
 			if (rc)
 				rc = -EINTR;
-			else if (rdata->result) {
-				rc = rdata->result;
+			else if (rdata->result == -EAGAIN) {
 				/* resend call if it's a retryable error */
-				if (rc == -EAGAIN) {
-					struct list_head tmp_list;
+				struct list_head tmp_list;
 
-					list_del_init(&rdata->list);
-					INIT_LIST_HEAD(&tmp_list);
+				list_del_init(&rdata->list);
+				INIT_LIST_HEAD(&tmp_list);
 
-					rc = cifs_send_async_read(rdata->offset,
+				rc = cifs_send_async_read(rdata->offset,
 						rdata->bytes, rdata->cfile,
 						cifs_sb, &tmp_list);
 
-					list_splice(&tmp_list, &rdata_list);
+				list_splice(&tmp_list, &rdata_list);
 
-					kref_put(&rdata->refcount,
-						cifs_uncached_readdata_release);
-					goto again;
-				}
-			} else {
+				kref_put(&rdata->refcount,
+					 cifs_uncached_readdata_release);
+				goto again;
+			} else if (rdata->result)
+				rc = rdata->result;
+			else
 				rc = cifs_readdata_to_iov(rdata, to);
-			}
+
 			/* if there was a short read -- discard anything left */
 			if (rdata->got_bytes && rdata->got_bytes < rdata->bytes)
 				rc = -ENODATA;
-- 
1.8.1.2
