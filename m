From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] cifs_dbg() outputs an uninitialized buffer in cifs_readdir()
Date: Thu, 14 Jan 2016 13:41:14 +0300
Message-ID: <56977B4A.3070002@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In some cases tmp_bug can be not filled in cifs_filldir and stay uninitialized,
therefore its printk with "%s" modifier can leak content of kernelspace memory.
If old content of this buffer does not contain '\0' access bejond end of
allocated object can crash the host.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/cifs/readdir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 0557c45..b30a4a6 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -847,6 +847,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		 * if buggy server returns . and .. late do we want to
 		 * check for that here?
 		 */
+		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
 				  tmp_buf, max_len);
 		if (rc) {
-- 
1.9.1
