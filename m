From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 4/7] CIFS: Fix possible buffer corruption in cifs_user_read()
Date: Mon, 14 Jul 2014 13:01:14 +0400
Message-ID: <1405328477-13484-5-git-send-email-pshilovsky@samba.org>
References: <1405328477-13484-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405328477-13484-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If there was a short read in the middle of the rdata list,
we can end up with a corrupt output buffer.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f6cb765..2927f02 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3048,7 +3048,9 @@ again:
 			} else {
 				rc = cifs_readdata_to_iov(rdata, to);
 			}
-
+			/* if there was a short read -- discard anything left */
+			if (rdata->got_bytes && rdata->got_bytes < rdata->bytes)
+				rc = -ENODATA;
 		}
 		list_del_init(&rdata->list);
 		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
-- 
1.8.1.2
