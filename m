From: shirishpargaonkar@gmail.com
Subject: [PATCH] cifs: For SMB2 security informaion query, check for minimum sized security descriptor instead of sizeof FileAllInformation class
Date: Mon,  4 Jun 2018 06:46:22 -0500
Message-ID: <1528112782-13759-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs@vger.kernel.org, stable@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Noah Morrison <noah.morrison@rubrik.com>
To: smfrench@gmail.com
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

Validate_buf () function checks for an expected minimum sized response
passed to query_info() function.
For security information, the size of a security descriptor can be
smaller (one subauthority, no ACEs) than the size of the structure
that defines FileInfoClass of FileAllInformation.


Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199725
Cc: <stable@vger.kernel.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Noah Morrison <noah.morrison@rubrik.com>

---
 fs/cifs/cifsacl.h | 14 ++++++++++++++
 fs/cifs/smb2pdu.c |  3 +--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 4f38848..dd95a6f 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -98,4 +98,18 @@ struct cifs_ace {
 	struct cifs_sid sid; /* ie UUID of user or group who gets these perms */
 } __attribute__((packed));
 
+/*
+ * Minimum security identifier can be one for system defined Users
+ * and Groups such as NULL SID and World or Built-in accounts such
+ * as Administrator and Guest and consists of
+ * Revision + Num (Sub)Auths + Authority + Domain (one Subauthority)
+ */
+#define MIN_SID_LEN  (1 + 1 + 6 + 4) /* in bytes */
+
+/*
+ * Minimum security descriptor can be one without any SACL and DACL and can
+ * consist of revision, type, and two sids of minimum size for owner and group
+ */
+#define MIN_SEC_DESC_LEN  (sizeof(struct cifs_ntsd) + (2 * MIN_SID_LEN))
+
 #endif /* _CIFSACL_H */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 60db51b..47538a4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2374,8 +2374,7 @@ int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
 			  0, SMB2_O_INFO_SECURITY, additional_info,
-			  SMB2_MAX_BUFFER_SIZE,
-			  sizeof(struct smb2_file_all_info), data, plen);
+			  SMB2_MAX_BUFFER_SIZE, MIN_SEC_DESC_LEN, data, plen);
 }
 
 int
-- 
1.9.1
