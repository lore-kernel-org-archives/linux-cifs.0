From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Make ops->close return void
Date: Tue, 25 Sep 2012 11:00:07 +0400
Message-ID: <1348556409-10339-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 ++-
 fs/cifs/file.c     |    5 ++---
 fs/cifs/smb1ops.c  |    4 ++--
 fs/cifs/smb2ops.c  |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a39e5b7..f6f4063 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -316,7 +316,8 @@ struct smb_version_operations {
 	/* set fid protocol-specific info */
 	void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32);
 	/* close a file */
-	int (*close)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
+	void (*close)(const unsigned int, struct cifs_tcon *,
+		      struct cifs_fid *);
 	/* send a flush request to the server */
 	int (*flush)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
 	/* async read from the server */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 075f7cf..7d7bbdc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -355,12 +355,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		struct TCP_Server_Info *server = tcon->ses->server;
 		unsigned int xid;
-		int rc = -ENOSYS;
 
 		xid = get_xid();
 		if (server->ops->close)
-			rc = server->ops->close(xid, tcon, &cifs_file->fid);
-		free_xid(xid);
+			server->ops->close(xid, tcon, &cifs_file->fid);
+		_free_xid(xid);
 	}
 
 	cifs_del_pending_open(&open);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5fb0fe5..42dccbb 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -720,11 +720,11 @@ cifs_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
 }
 
-static int
+static void
 cifs_close_file(const unsigned int xid, struct cifs_tcon *tcon,
 		struct cifs_fid *fid)
 {
-	return CIFSSMBClose(xid, tcon, fid->netfid);
+	CIFSSMBClose(xid, tcon, fid->netfid);
 }
 
 static int
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2183bb3..1570cbe 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -374,11 +374,11 @@ smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
 }
 
-static int
+static void
 smb2_close_file(const unsigned int xid, struct cifs_tcon *tcon,
 		struct cifs_fid *fid)
 {
-	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+	SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
 static int
-- 
1.7.5.4
