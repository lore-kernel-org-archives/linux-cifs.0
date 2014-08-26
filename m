From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2] CIFS: Fix wrong restart readdir for SMB1
Date: Tue, 26 Aug 2014 19:04:44 +0400
Message-ID: <1409065484-7438-1-git-send-email-pshilovsky@samba.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The existing code calls server->ops->close() that is not
right. This causes XFS test generic/310 to fail. Fix this
by using server->ops->closedir() function.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.7+
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 798c80a..b334a89 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -596,8 +596,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		if (server->ops->dir_needs_close(cfile)) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			if (server->ops->close)
-				server->ops->close(xid, tcon, &cfile->fid);
+			if (server->ops->close_dir)
+				server->ops->close_dir(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cfile->srch_inf.ntwrk_buf_start) {
-- 
1.9.1
