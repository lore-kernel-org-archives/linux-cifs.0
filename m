From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 21/45] CIFS: Add SMB2 r/wsize negotiating
Date: Wed, 18 Jul 2012 19:48:37 +0400
Message-ID: <1342626541-29872-22-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 fs/cifs/smb2ops.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d81e1da..c0997ad 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -157,6 +157,40 @@ smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	return rc;
 }
 
+static unsigned int
+smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int wsize;
+
+	/* start with specified wsize, or default */
+	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
+	wsize = min_t(unsigned int, wsize, server->max_write);
+	/*
+	 * limit write size to 2 ** 16, because we don't support multicredit
+	 * requests now.
+	 */
+	wsize = min_t(unsigned int, wsize, 2 << 15);
+	return wsize;
+}
+
+static unsigned int
+smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int rsize;
+
+	/* start with specified rsize, or default */
+	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
+	rsize = min_t(unsigned int, rsize, server->max_read);
+	/*
+	 * limit write size to 2 ** 16, because we don't support multicredit
+	 * requests now.
+	 */
+	rsize = min_t(unsigned int, rsize, 2 << 15);
+	return rsize;
+}
+
 static int
 smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
@@ -352,6 +386,8 @@ struct smb_version_operations smb21_operations = {
 	.print_stats = smb2_print_stats,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
+	.negotiate_wsize = smb2_negotiate_wsize,
+	.negotiate_rsize = smb2_negotiate_rsize,
 	.sess_setup = SMB2_sess_setup,
 	.logoff = SMB2_logoff,
 	.tree_connect = SMB2_tcon,
-- 
1.7.1
