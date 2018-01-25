From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 1/1] CIFS: document tcon/ses/server refcount dance
Date: Thu, 25 Jan 2018 18:47:52 +0100
Message-ID: <20180125174752.5139-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/connect.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8b5e401f547a..ff7a653fd322 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2704,6 +2704,13 @@ cifs_set_cifscreds(struct smb_vol *vol __attribute__((unused)),
 }
 #endif /* CONFIG_KEYS */
 
+/**
+ * cifs_get_smb_ses - get a session matching @volume_info data from @server
+ *
+ * This function assumes it is being called from cifs_mount() where we
+ * already got a server reference (server refcount +1). See
+ * cifs_get_tcon() for refcount explanations.
+ */
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
@@ -2877,6 +2884,26 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	cifs_put_smb_ses(ses);
 }
 
+/**
+ * cifs_get_tcon - get a tcon matching @volume_info data from @ses
+ *
+ * - tcon refcount is the number of mount points using the tcon.
+ * - ses refcount is the number of tcon using the session.
+ *
+ * 1. This function assumes it is being called from cifs_mount() where
+ *    we already got a session reference (ses refcount +1).
+ *
+ * 2. Since we're in the context of adding a mount point, the end
+ *    result should be either:
+ *
+ * a) a new tcon already allocated with refcount=1 (1 mount point) and
+ *    its session refcount incremented (1 new tcon). This +1 was
+ *    already done in (1).
+ *
+ * b) an existing tcon with refcount+1 (add a mount point to it) and
+ *    identical ses refcount (no new tcon). Because of (1) we need to
+ *    decrement the ses refcount.
+ */
 static struct cifs_tcon *
 cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 {
@@ -2885,8 +2912,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 
 	tcon = cifs_find_tcon(ses, volume_info);
 	if (tcon) {
+		/*
+		 * tcon has refcount already incremented but we need to
+		 * decrement extra ses reference gotten by caller (case b)
+		 */
 		cifs_dbg(FYI, "Found match on UNC path\n");
-		/* existing tcon already has a reference */
 		cifs_put_smb_ses(ses);
 		return tcon;
 	}
-- 
2.12.3
