From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] Add missing defines for ACL query support
Date: Mon, 20 Oct 2014 15:09:01 -0500
Message-ID: <1413835743-13566-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

 Add missing defines needed for ACL query support.
 For definitions of these security info type additionalinfo flags
 and also the EA Flags see MS-SMB2 (2.2.37) or MS-DTYP

Signed-of-by: Steven French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e3188ab..d84f46c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -836,6 +836,25 @@ struct smb2_query_directory_rsp {
 #define SMB2_O_INFO_SECURITY	0x03
 #define SMB2_O_INFO_QUOTA	0x04
 
+/* Security info type additionalinfo flags. See MS-SMB2 (2.2.37) or MS-DTYP */
+#define OWNER_SECINFO   0x00000001
+#define GROUP_SECINFO   0x00000002
+#define DACL_SECINFO   0x00000004
+#define SACL_SECINFO   0x00000008
+#define LABEL_SECINFO   0x00000010
+#define ATTRIBUTE_SECINFO   0x00000020
+#define SCOPE_SECINFO   0x00000040
+#define BACKUP_SECINFO   0x00010000
+#define UNPROTECTED_SACL_SECINFO   0x10000000
+#define UNPROTECTED_DACL_SECINFO   0x20000000
+#define PROTECTED_SACL_SECINFO   0x40000000
+#define PROTECTED_DACL_SECINFO   0x80000000
+
+/* Flags used for FileFullEAinfo */
+#define SL_RESTART_SCAN		0x00000001
+#define SL_RETURN_SINGLE_ENTRY	0x00000002
+#define SL_INDEX_SPECIFIED	0x00000004
+
 struct smb2_query_info_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 41 */
-- 
1.9.1
