From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix return code when failing to rename a file onto a directory
Date: Thu,  9 Nov 2017 16:11:57 +1100
Message-ID: <20171109051157.30814-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Cifs servers return ACCESS_DENIED when trying to rename onto a non-empty
directory. This is different from xfstest where we expect this to return
-EEXIST instead.

As a workaround, if we failed to rename the file and we got -EACCES
then try to open the target file and check the attributes if it is a
directory or not and if so remap the error to -EEXIST.

This makes us pass xfstest  generic/245

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2ops.c   | 39 +++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 13 ++++++++++++-
 fs/cifs/smb2proto.h |  2 ++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bdb963d0ba32..1c46aab0d015 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -426,6 +426,45 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+int
+smb2_is_dir(const unsigned int xid, struct cifs_tcon *tcon,
+	    __le16 *target_file)
+{
+	int rc;
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
+	struct smb2_file_all_info *smb2_data;
+
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL)
+		return -ENOMEM;
+
+	oparms.tcon = tcon;
+	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.disposition = FILE_OPEN;
+	oparms.create_options = 0;
+	oparms.fid = &fid;
+	oparms.reconnect = false;
+
+	rc = SMB2_open(xid, &oparms, target_file, &oplock, NULL, NULL);
+	if (rc)
+		goto out;
+
+	rc = SMB2_query_info(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+			     smb2_data);
+	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+	if (rc)
+		goto out;
+
+	rc = !!(le32_to_cpu(smb2_data->Attributes) & FILE_ATTRIBUTE_DIRECTORY);
+
+out:
+	kfree(smb2_data);
+	return rc;
+}
+
 #ifdef CONFIG_CIFS_XATTR
 static ssize_t
 move_smb2_ea_to_cifs(char *dst, size_t dst_size,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 553d574940b9..91f0b4a5e749 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3144,7 +3144,7 @@ SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_file_rename_info info;
 	void **data;
 	unsigned int size[2];
-	int rc;
+	int rc, is_dir;
 	int len = (2 * UniStrnlen((wchar_t *)target_file, PATH_MAX));
 
 	data = kmalloc(sizeof(void *) * 2, GFP_KERNEL);
@@ -3165,6 +3165,17 @@ SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
 		current->tgid, FILE_RENAME_INFORMATION, SMB2_O_INFO_FILE,
 		0, 2, data, size);
+
+	/* SMB2 servers responds with ACCESS_DENIED when trying to rename
+	 * and replace onto a non-empty directory. Check for this and remap
+	 * to EEXIST.
+	 */
+	if (rc == -EACCES) {
+		is_dir = smb2_is_dir(xid, tcon, target_file);
+		if (is_dir == 1)
+			rc = -EEXIST;
+	}
+
 	kfree(data);
 	return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index e9ab5227e7a8..35c075364f7e 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -203,4 +203,6 @@ extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
 extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
+extern int smb2_is_dir(const unsigned int xid, struct cifs_tcon *tcon,
+		       __le16 *target_file);
 #endif			/* _SMB2PROTO_H */
-- 
2.13.3
