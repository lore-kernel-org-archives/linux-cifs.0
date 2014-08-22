From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH 3/3] CIFS: Fix wrong filename length for SMB2
Date: Fri, 22 Aug 2014 13:32:11 +0400
Message-ID: <1408699931-22515-4-git-send-email-pshilovsky@samba.org>
References: <1408699931-22515-1-git-send-email-pshilovsky@samba.org>
Cc: <stable@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1408699931-22515-1-git-send-email-pshilovsky@samba.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The existing code uses the old MAX_NAME constant. This causes
XFS test generic/013 to fail. Fix it by replacing MAX_NAME with
PATH_MAX that SMB1 uses. Also remove an unused MAX_NAME constant
definition.

Cc: <stable@vger.kernel.org> # v3.7+
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
---
 fs/cifs/cifsglob.h  | 5 -----
 fs/cifs/smb2file.c  | 2 +-
 fs/cifs/smb2inode.c | 2 +-
 fs/cifs/smb2ops.c   | 2 +-
 fs/cifs/smb2pdu.c   | 2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 31f8ecc..636e1f9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -70,11 +70,6 @@
 #define SERVER_NAME_LENGTH 40
 #define SERVER_NAME_LEN_WITH_NULL     (SERVER_NAME_LENGTH + 1)
 
-/* used to define string lengths for reversing unicode strings */
-/*         (256+1)*2 = 514                                     */
-/*           (max path length + 1 for null) * 2 for unicode    */
-#define MAX_NAME 514
-
 /* SMB echo "timeout" -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (60 * HZ)
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 3f17b45..4599294 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -50,7 +50,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		goto out;
 	}
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL) {
 		rc = -ENOMEM;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 0150182..899bbc8 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -131,7 +131,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	*adjust_tz = false;
 	*symlink = false;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4e4eecd..f522193 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -389,7 +389,7 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 
-	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			    GFP_KERNEL);
 	if (smb2_data == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0709494..28e5a12 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1533,7 +1533,7 @@ SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  FILE_ALL_INFORMATION,
-			  sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			  sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
 			  sizeof(struct smb2_file_all_info), data);
 }
 
-- 
1.9.1
