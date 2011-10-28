From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 29/53] CIFS: Respect max buf size for SMB2 read and write
Date: Fri, 28 Oct 2011 23:54:40 +0400
Message-ID: <1319831704-3572-30-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0187f11..62edb10 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3078,6 +3078,18 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
 				CIFS_DEFAULT_IOSIZE;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2) {
+		wsize = min_t(unsigned int, wsize, server->max_write);
+		/*
+		 * limit write size to 2 ** 16, because we don't support
+		 * multicredit requests now.
+		 */
+		wsize = min_t(unsigned int, wsize, 2 << 15);
+		return wsize;
+	}
+#endif
+
 	/* can server support 24-bit write sizes? (via UNIX extensions) */
 	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
 		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1002_WSIZE);
@@ -3106,6 +3118,20 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int rsize, defsize;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2) {
+		rsize = pvolume_info->rsize ? pvolume_info->rsize :
+			CIFS_DEFAULT_IOSIZE;
+		rsize = min_t(unsigned int, rsize, server->max_read);
+		/*
+		 * limit write size to 2 ** 16, because we don't support
+		 * multicredit requests now.
+		 */
+		rsize = min_t(unsigned int, rsize, 2 << 15);
+		return rsize;
+	}
+#endif
+
 	/*
 	 * Set default value...
 	 *
-- 
1.7.1
