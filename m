Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033EF267B89;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=ncRU8n8S2TGUSza1LPsmtGjpJoKWm7NUuyTeV79rDnhNstl3oLJbZeaPXaGflq9cZgWgc63Cxng993gnUMjYLOd5tq6UFxitiJhQvx65Q5E1tfQpQxZbFq3FS+by23Y58anzBpTajbu9rMXPXX4Uh05ZutfqNP9L51iRozFdrhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=4OxJ1hA+cvUqeyyfmVv74EFqlJPYDWJGHmo1sOfaEIA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8ztQdjAARmKBG7jsthR5MEtjs50u23pDZn7U3F8/ZRe29TwCFdV+MyeV0inuNT6yO36qxtec8Pkf1KT/RDZ7Qh4z3PQywRmI5BLpZ3xxnNRkqgX5i2n4PAKKZkbB1JvTYYIZSKAn6jAoDAIwqsha3NBnigoAWTv2OZlLQ1NY8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fs77t22j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fs77t22j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915AAC4CEFD;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=4OxJ1hA+cvUqeyyfmVv74EFqlJPYDWJGHmo1sOfaEIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fs77t22j90PJfOo/4F3GBQZRPFeCyx269wD0cmskPny+S9K6dbofNwj3FlK1uJE+i
	 NrsPlS9S6BX2jM8GWSY3i5TEF2HM0fpfXnGkB4vqW6BmqAujU72GNEl6sglMjwMMXX
	 1tQjQbEuV5wu4CSFcNJma4Wmx0zdM9/cst3w5Yvy+rtW4qXY+M84Oo+eObWcNYYo7Y
	 5TRZXpwcwSBxwVdep3to4KXnibWpLYF+HnbroecwxfS+xsu98hSHz63YuxRJA0HtHq
	 7U5N89WTF8kRtnmeAt+BO0aVfjhABmKECDrmI3j1DOhPaEGyfOWMeli1F3Z6jrePbW
	 uJiswiZY0SpPg==
Received: by pali.im (Postfix)
	id D3BFA1168; Sun, 31 Aug 2025 14:36:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 25/35] cifs: Add a new callback rename_opened_file() for renaming an opened file
Date: Sun, 31 Aug 2025 14:35:52 +0200
Message-Id: <20250831123602.14037-26-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Implement it for all SMB dialects. It will be used by follow up changes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  4 ++++
 fs/smb/client/smb1ops.c   | 18 ++++++++++++++++++
 fs/smb/client/smb2ops.c   | 13 +++++++++++++
 fs/smb/client/smb2pdu.c   | 28 ++++++++++++++++++++++++++++
 fs/smb/client/smb2proto.h |  4 ++++
 5 files changed, 67 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7162b9120198..ec5608924ce7 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -462,6 +462,10 @@ struct smb_version_operations {
 		      struct dentry *source_dentry,
 		      const char *from_name, const char *to_name,
 		      struct cifs_sb_info *cifs_sb);
+	/* send rename request for opened file */
+	int (*rename_opened_file)(const unsigned int xid, struct cifs_tcon *tcon,
+				  struct cifs_fid *fid, const char *new_full_path,
+				  bool overwrite, struct cifs_sb_info *cifs_sb);
 	/* send create hardlink request */
 	int (*create_hardlink)(const unsigned int xid,
 			       struct cifs_tcon *tcon,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e37104d3c5d7..26798db5c00b 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1086,6 +1086,23 @@ cifs_set_file_disp(const unsigned int xid, struct cifs_tcon *tcon,
 	return CIFSSMBSetFileDisposition(xid, tcon, delete_pending, fid->netfid, current->tgid);
 }
 
+static int
+cifs_rename_opened_file(const unsigned int xid, struct cifs_tcon *tcon,
+			struct cifs_fid *fid, const char *new_full_path,
+			bool overwrite, struct cifs_sb_info *cifs_sb)
+{
+	const char *name;
+
+	/* CIFSSMBRenameOpenFile() requires just new basename of the file */
+	name = strrchr(new_full_path, CIFS_DIR_SEP(cifs_sb));
+	if (name)
+		name++;
+	else
+		name = new_full_path;
+	return CIFSSMBRenameOpenFile(xid, tcon, fid->netfid, name, overwrite,
+				     cifs_sb->local_nls, cifs_remap(cifs_sb));
+}
+
 static int
 cifs_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile)
@@ -1407,6 +1424,7 @@ struct smb_version_operations smb1_operations = {
 	.unlink = CIFSSMBDelFile,
 	.rename_pending_delete = cifs_rename_pending_delete,
 	.rename = CIFSSMBRename,
+	.rename_opened_file = cifs_rename_opened_file,
 	.create_hardlink = CIFSCreateHardLink,
 	.query_symlink = cifs_query_symlink,
 	.get_reparse_point_buffer = cifs_get_reparse_point_buffer,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 530e66fa4671..0ba15af86582 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1522,6 +1522,15 @@ smb2_set_file_disp(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_set_disp(xid, tcon, fid->persistent_fid, fid->volatile_fid, delete_pending);
 }
 
+static int
+smb2_rename_opened_file(const unsigned int xid, struct cifs_tcon *tcon,
+			struct cifs_fid *fid, const char *new_full_path,
+			bool overwrite, struct cifs_sb_info *cifs_sb)
+{
+	return SMB2_set_full_path(xid, tcon, fid->persistent_fid, fid->volatile_fid,
+				  new_full_path, overwrite, cifs_sb);
+}
+
 static int
 SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid,
@@ -5324,6 +5333,7 @@ struct smb_version_operations smb20_operations = {
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
+	.rename_opened_file = smb2_rename_opened_file,
 	.create_hardlink = smb2_create_hardlink,
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
@@ -5428,6 +5438,7 @@ struct smb_version_operations smb21_operations = {
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
+	.rename_opened_file = smb2_rename_opened_file,
 	.create_hardlink = smb2_create_hardlink,
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
@@ -5536,6 +5547,7 @@ struct smb_version_operations smb30_operations = {
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
+	.rename_opened_file = smb2_rename_opened_file,
 	.create_hardlink = smb2_create_hardlink,
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
@@ -5653,6 +5665,7 @@ struct smb_version_operations smb311_operations = {
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
+	.rename_opened_file = smb2_rename_opened_file,
 	.create_hardlink = smb2_create_hardlink,
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e05ddd446467..a6c69b01ec6b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5768,6 +5768,34 @@ SMB2_set_disp(const unsigned int xid, struct cifs_tcon *tcon,
 			     SMB2_O_INFO_FILE, 0, 1, (void **)&buf, &len);
 }
 
+int
+SMB2_set_full_path(const unsigned int xid, struct cifs_tcon *tcon,
+		   u64 persistent_fid, u64 volatile_fid, const char *new_full_path,
+		   bool overwrite, struct cifs_sb_info *cifs_sb)
+{
+	struct smb2_file_rename_info rename_info = {};
+	unsigned int size[2];
+	void *data[2];
+	int rc;
+
+	data[1] = cifs_convert_path_to_utf16(new_full_path, cifs_sb);
+	if (!data[1])
+		return -ENOMEM;
+	size[1] = 2 * UniStrnlen((wchar_t *)data[1], PATH_MAX);
+
+	rename_info.ReplaceIfExists = overwrite;
+	rename_info.RootDirectory = 0;
+	rename_info.FileNameLength = cpu_to_le32(size[1]);
+	data[0] = &rename_info;
+	size[0] = sizeof(rename_info);
+
+	rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			   current->tgid, FILE_RENAME_INFORMATION,
+			   SMB2_O_INFO_FILE, 0, 2, data, size);
+	kfree(data[1]);
+	return rc;
+}
+
 int
 SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  const u64 persistent_fid, const u64 volatile_fid,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index d78ea3a6a5fb..7c300dd9ea4e 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -251,6 +251,10 @@ extern int SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		       struct smb2_file_full_ea_info *buf, int len);
 extern int SMB2_set_disp(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_fid, u64 volatile_fid, bool delete_pending);
+extern int SMB2_set_full_path(const unsigned int xid, struct cifs_tcon *tcon,
+			      u64 persistent_fid, u64 volatile_fid,
+			      const char *name, bool overwrite,
+			      struct cifs_sb_info *cifs_sb);
 extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 				u64 persistent_fid, u64 volatile_fid);
 extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.20.1

