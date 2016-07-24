From: Pavel Shilovsky <piastry-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] CIFS: Fix a possible invalid memory access in smb2_query_symlink()
Date: Sun, 24 Jul 2016 10:37:38 +0300
Message-ID: <1469345858-5571-1-git-send-email-piastry@altlinux.org>
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

During following a symbolic link we received err_buf from SMB2_open().
While the validity of SMB2 error response is checked previously
in smb2_check_message() a symbolic link payload is not checked at all.
Fix it by adding such checks.

Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 527d1ac..9ec025c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1044,6 +1044,9 @@ smb2_new_lease_key(struct cifs_fid *fid)
 	get_random_bytes(fid->lease_key, SMB2_LEASE_KEY_SIZE);
 }
 
+#define SMB2_SYMLINK_STRUCT_SIZE \
+	(sizeof(struct smb2_err_rsp) - 1 + sizeof(struct smb2_symlink_err_rsp))
+
 static int
 smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *full_path, char **target_path,
@@ -1056,7 +1059,10 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	struct smb2_err_rsp *err_buf = NULL;
 	struct smb2_symlink_err_rsp *symlink;
-	unsigned int sub_len, sub_offset;
+	unsigned int sub_len;
+	unsigned int sub_offset;
+	unsigned int print_len;
+	unsigned int print_offset;
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
@@ -1077,11 +1083,33 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 		kfree(utf16_path);
 		return -ENOENT;
 	}
+
+	if (err_buf->ByteCount < sizeof(struct smb2_symlink_err_rsp) ||
+	    get_rfc1002_length(err_buf) + 4 < SMB2_SYMLINK_STRUCT_SIZE) {
+		kfree(utf16_path);
+		return -ENOENT;
+	}
+
 	/* open must fail on symlink - reset rc */
 	rc = 0;
 	symlink = (struct smb2_symlink_err_rsp *)err_buf->ErrorData;
 	sub_len = le16_to_cpu(symlink->SubstituteNameLength);
 	sub_offset = le16_to_cpu(symlink->SubstituteNameOffset);
+	print_len = le16_to_cpu(symlink->PrintNameLength);
+	print_offset = le16_to_cpu(symlink->PrintNameOffset);
+
+	if (get_rfc1002_length(err_buf) + 4 <
+			SMB2_SYMLINK_STRUCT_SIZE + sub_offset + sub_len) {
+		kfree(utf16_path);
+		return -ENOENT;
+	}
+
+	if (get_rfc1002_length(err_buf) + 4 <
+			SMB2_SYMLINK_STRUCT_SIZE + print_offset + print_len) {
+		kfree(utf16_path);
+		return -ENOENT;
+	}
+
 	*target_path = cifs_strndup_from_utf16(
 				(char *)symlink->PathBuffer + sub_offset,
 				sub_len, true, cifs_sb->local_nls);
-- 
2.1.4
