From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Improve identation in cifs_unlock_range
Date: Thu, 31 May 2012 14:44:04 +0400
Message-ID: <1338461044-6896-2-git-send-email-pshilovsky@samba.org>
References: <1338461044-6896-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338461044-6896-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |   75 ++++++++++++++++++++++++++-----------------------------
 1 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index de8abb6..513adbc 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1266,46 +1266,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 				continue;
 			if (types[i] != li->type)
 				continue;
-			if (!cinode->can_cache_brlcks) {
-				cur->Pid = cpu_to_le16(li->pid);
-				cur->LengthLow = cpu_to_le32((u32)li->length);
-				cur->LengthHigh =
-					cpu_to_le32((u32)(li->length>>32));
-				cur->OffsetLow = cpu_to_le32((u32)li->offset);
-				cur->OffsetHigh =
-					cpu_to_le32((u32)(li->offset>>32));
-				/*
-				 * We need to save a lock here to let us add
-				 * it again to the file's list if the unlock
-				 * range request fails on the server.
-				 */
-				list_move(&li->llist, &tmp_llist);
-				if (++num == max_num) {
-					stored_rc = cifs_lockv(xid, tcon,
-							       cfile->netfid,
-							       li->type, num,
-							       0, buf);
-					if (stored_rc) {
-						/*
-						 * We failed on the unlock range
-						 * request - add all locks from
-						 * the tmp list to the head of
-						 * the file's list.
-						 */
-						cifs_move_llist(&tmp_llist,
-								&cfile->llist);
-						rc = stored_rc;
-					} else
-						/*
-						 * The unlock range request
-						 * succeed - free the tmp list.
-						 */
-						cifs_free_llist(&tmp_llist);
-					cur = buf;
-					num = 0;
-				} else
-					cur++;
-			} else {
+			if (cinode->can_cache_brlcks) {
 				/*
 				 * We can cache brlock requests - simply remove
 				 * a lock from the file's list.
@@ -1313,7 +1274,41 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
 				list_del(&li->llist);
 				cifs_del_lock_waiters(li);
 				kfree(li);
+				continue;
 			}
+			cur->Pid = cpu_to_le16(li->pid);
+			cur->LengthLow = cpu_to_le32((u32)li->length);
+			cur->LengthHigh = cpu_to_le32((u32)(li->length>>32));
+			cur->OffsetLow = cpu_to_le32((u32)li->offset);
+			cur->OffsetHigh = cpu_to_le32((u32)(li->offset>>32));
+			/*
+			 * We need to save a lock here to let us add it again to
+			 * the file's list if the unlock range request fails on
+			 * the server.
+			 */
+			list_move(&li->llist, &tmp_llist);
+			if (++num == max_num) {
+				stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+						       li->type, num, 0, buf);
+				if (stored_rc) {
+					/*
+					 * We failed on the unlock range
+					 * request - add all locks from the tmp
+					 * list to the head of the file's list.
+					 */
+					cifs_move_llist(&tmp_llist,
+							&cfile->llist);
+					rc = stored_rc;
+				} else
+					/*
+					 * The unlock range request succeed -
+					 * free the tmp list.
+					 */
+					cifs_free_llist(&tmp_llist);
+				cur = buf;
+				num = 0;
+			} else
+				cur++;
 		}
 		if (num) {
 			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
-- 
1.7.1
