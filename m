From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] CIFS: Reset read oplock to NONE if we have mandatory locks after reopen
Date: Tue, 11 Oct 2016 15:34:07 -0700
Message-ID: <1476225247-30177-3-git-send-email-piastryyy@gmail.com>
References: <1476225247-30177-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476225247-30177-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

We are already doing the same thing for an ordinary open case:
we can't keep read oplock on a file if we have mandatory byte-range
locks because pagereading can conflict with these locks on a server.
Fix it by setting oplock level to NONE.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 40b015b..16433a7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -739,6 +739,15 @@ reopen_success:
 	 * to the server to get the new inode info.
 	 */
 
+	/*
+	 * If the server returned a read oplock and we have mandatory brlocks,
+	 * set oplock level to None.
+	 */
+	if (server->ops->is_read_op(oplock) && cifs_has_mand_locks(cinode)) {
+		cifs_dbg(FYI, "Reset oplock val from read to None due to mand locks\n");
+		oplock = 0;
+	}
+
 	server->ops->set_fid(cfile, &cfile->fid, oplock);
 	if (oparms.reconnect)
 		cifs_relock_file(cfile);
-- 
2.7.4
