From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 6/6] CIFS: Make cifs_push_locks send as many locks at once as possible
Date: Fri,  7 Oct 2011 17:10:24 +0400
Message-ID: <1317993024-15003-7-git-send-email-piastry@etersoft.ru>
References: <1317993024-15003-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317993024-15003-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that reduces a traffic and increases a performance.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |   49 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 59410a8..777b837 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -819,6 +819,11 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	struct cifsLockInfo *li, *tmp;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	unsigned int num, max_num;
+	LOCKING_ANDX_RANGE *buf, *cur;
+	int types[] = {LOCKING_ANDX_LARGE_FILES,
+		       LOCKING_ANDX_SHARED_LOCK | LOCKING_ANDX_LARGE_FILES};
+	int i;
 
 	xid = GetXid();
 	tcon = tlink_tcon(cfile->tlink);
@@ -830,17 +835,49 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 		return rc;
 	}
 
-	list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
-		stored_rc = CIFSSMBLock(xid, tcon, cfile->netfid,
-					li->pid, li->length, li->offset,
-					0, 1, li->type, 0, 0);
-		if (stored_rc)
-			rc = stored_rc;
+	max_num = (tcon->ses->server->maxBuf - sizeof(struct smb_hdr)) /
+		  sizeof(LOCKING_ANDX_RANGE);
+	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
+	if (!buf) {
+		mutex_unlock(&cinode->lock_mutex);
+		FreeXid(xid);
+		return rc;
+	}
+
+	for (i = 0; i < 2; i++) {
+		cur = buf;
+		num = 0;
+		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+			if (li->type != types[i])
+				continue;
+			cur->Pid = cpu_to_le16(li->pid);
+			cur->LengthLow = cpu_to_le32((u32)li->length);
+			cur->LengthHigh = cpu_to_le32((u32)(li->length>>32));
+			cur->OffsetLow = cpu_to_le32((u32)li->offset);
+			cur->OffsetHigh = cpu_to_le32((u32)(li->offset>>32));
+			if (++num == max_num) {
+				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+						       li->type, 0, num, buf);
+				if (stored_rc)
+					rc = stored_rc;
+				cur = buf;
+				num = 0;
+			} else
+				cur++;
+		}
+
+		if (num) {
+			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+					       types[i], 0, num, buf);
+			if (stored_rc)
+				rc = stored_rc;
+		}
 	}
 
 	cinode->can_cache_brlcks = false;
 	mutex_unlock(&cinode->lock_mutex);
 
+	kfree(buf);
 	FreeXid(xid);
 	return rc;
 }
-- 
1.7.1
