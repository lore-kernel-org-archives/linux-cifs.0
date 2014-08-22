From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/3] CIFS: Fix wrong restart readdir for SMB1
Date: Fri, 22 Aug 2014 13:32:10 +0400
Message-ID: <1408699931-22515-3-git-send-email-pshilovsky@samba.org>
References: <1408699931-22515-1-git-send-email-pshilovsky@samba.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408699931-22515-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The existing code calls server->ops->close() that is not
right. This causes XFS test generic/310 to fail. Fix this
by using server->ops->closedir() function.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.7+
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 798c80a..58e413c 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -597,7 +597,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
 			if (server->ops->close)
-				server->ops->close(xid, tcon, &cfile->fid);
+				server->ops->close_dir(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cfile->srch_inf.ntwrk_buf_start) {
-- 
1.9.1
