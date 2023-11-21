Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="On4LfKEQ"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D34C193
	for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 15:13:17 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=87BX2o10Xvsnqcrr/dGZxpxsLgT7kRBjl26s33XdIyA=;
	b=On4LfKEQkO+0UvZBlUrd8wCzhdTbFYfDmGuna8CFQMK1e3HHDOYqsnQ8FFG6SncB0lGh60
	lFnjJ+9ebsErA7MrpzPZ5uQeRiorejL9dbo43FrMEYy95BQeDZoqNcdNwaFu6sFvlnRc6G
	rkdggJIfEcnpLTQMGOtxCc7YE6vyauroX/oHV/bgYf5rNPD3NswrvDoj6lVYT216tkvJ1e
	HTJ7VOft3gbmoKDRSwqs1R/eXlZjNNu+yMjvouvxj5aFyZAK1st8/SVyOueaqSPhD88wD5
	GC8vAeAdKS1O6v41iD51XTRxOtAgWYOLqM45gFsoPX4r8KEKBKWhOKep8Wko3g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700608395; a=rsa-sha256;
	cv=none;
	b=F7f2ImbVP2o16wqKYwDhZXSf7cb9OYD7Frb4se7d4xzk93j+xadkKiLvMavi51weu9g2tZ
	2ota7bgUr0FDsrE/1RjZAhyW/bkmr7N2IG8z0St1kAkTvKhwqsUhx8IMFFjyXqWnO6c1Qi
	vTqlZWM9sWfk/a7f6Xl4bAjaGO1RughE9aQo9qmiQhnWzXVeM4gmL6o/8o39JDJfSZ/isw
	YfAkKmcHw8kqznN4ox5WDiJLR+LzLgdAL4/Y1Q2OOhImxDpRPInB0UMNpqnLPIkHvaxmyh
	srU0w9UcfamvhvLTsV0J5mA+2SXd5Ywrnh44S5SX+k8tGABAuBtVwCHAihphHQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608395; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=87BX2o10Xvsnqcrr/dGZxpxsLgT7kRBjl26s33XdIyA=;
	b=QXx+63vVCY3x+wWVXE5WVuI0zBmgP0W1CkKPqNwYZgLbZ278XmFUSwEWbovxP37NGg6gvs
	f/U8YabWtwpgLEy2UeseSl9kJKbfQNVLbOH+MT3PXn1N4YpDc0G4zZ6qiop9fxNuFz8Sf9
	bE4k0swQoqpLiMriFCc6HXc3bl+FO6dGHOTqZVZlNq11rFdN6x0OfEkyMVXFtw/dGIDMQT
	W/Uoesf+ioTVKq8JE/zdxEPtBTP0IpubJFgw0xIqKxvioYfNYBR30ZfOHhZmd7vl6eklci
	YAkusSLYvsC29PdsX75c+3Pm7TZ1U0NjLjs9txcfQve0kYdWJbozR+Jb17X52g==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 6/7] smb: client: allow creating symlinks via reparse points
Date: Tue, 21 Nov 2023 20:12:57 -0300
Message-ID: <20231121231258.29562-6-pc@manguebit.com>
In-Reply-To: <20231121231258.29562-1-pc@manguebit.com>
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231121231258.29562-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for creating symlinks via IO_REPARSE_TAG_SYMLINK reparse
points in SMB2+.

These are fully supported by most SMB servers and documented in
MS-FSCC.  Also have the advantage of requiring fewer roundtrips as
their symlink targets can be parsed directly from CREATE responses on
STATUS_STOPPED_ON_SYMLINK errors.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h |  6 ++++
 fs/smb/client/link.c     | 15 ++++++---
 fs/smb/client/smb2ops.c  | 70 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7558167f603c..ec5a21c34b35 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -559,6 +559,12 @@ struct smb_version_operations {
 	int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
 				   struct kvec *rsp_iov,
 				   struct cifs_open_info_data *data);
+	int (*create_reparse_symlink)(const unsigned int xid,
+				      struct inode *inode,
+				      struct dentry *dentry,
+				      struct cifs_tcon *tcon,
+				      const char *full_path,
+				      const char *symname);
 };
 
 struct smb_version_values {
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index a1da50e66fbb..5c91376d1c1f 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -569,6 +569,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	int rc = -EOPNOTSUPP;
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	const char *full_path;
@@ -590,6 +591,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 		goto symlink_exit;
 	}
 	pTcon = tlink_tcon(tlink);
+	server = cifs_pick_channel(pTcon->ses);
 
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
@@ -601,17 +603,20 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	else if (pTcon->unix_ext)
+	} else if (pTcon->unix_ext) {
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
 					   cifs_sb->local_nls,
 					   cifs_remap(cifs_sb));
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	/* else
-	   rc = CIFSCreateReparseSymLink(xid, pTcon, fromName, toName,
-					cifs_sb_target->local_nls); */
+	} else if (server->ops->create_reparse_symlink) {
+		rc =  server->ops->create_reparse_symlink(xid, inode, direntry,
+							  pTcon, full_path,
+							  symname);
+		goto symlink_exit;
+	}
 
 	if (rc == 0) {
 		if (pTcon->posix_extensions)
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bc069deb5031..cd266226a16c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5300,6 +5300,72 @@ static int nfs_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+static int smb2_create_reparse_symlink(const unsigned int xid,
+				       struct inode *inode,
+				       struct dentry *dentry,
+				       struct cifs_tcon *tcon,
+				       const char *full_path,
+				       const char *symname)
+{
+	struct reparse_symlink_data_buffer *buf = NULL;
+	struct cifs_open_info_data data;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct inode *new;
+	__le16 *path;
+	char *sym;
+	u16 len, plen;
+	int rc;
+
+	sym = kstrdup(symname, GFP_KERNEL);
+	if (!sym)
+		return -ENOMEM;
+
+	data = (struct cifs_open_info_data) {
+		.reparse_point = true,
+		.reparse = { .tag = IO_REPARSE_TAG_SYMLINK, },
+		.symlink_target = sym,
+	};
+
+	path = cifs_convert_path_to_utf16(symname, cifs_sb);
+	if (!path) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
+	len = sizeof(*buf) + plen * 2;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	buf->ReparseTag = cpu_to_le32(IO_REPARSE_TAG_SYMLINK);
+	buf->ReparseDataLength = cpu_to_le16(len - sizeof(struct reparse_data_buffer));
+	buf->SubstituteNameOffset = cpu_to_le16(plen);
+	buf->SubstituteNameLength = cpu_to_le16(plen);
+	memcpy((u8 *)buf->PathBuffer + plen, path, plen);
+	buf->PrintNameOffset = 0;
+	buf->PrintNameLength = cpu_to_le16(plen);
+	memcpy(buf->PathBuffer, path, plen);
+	buf->Flags = cpu_to_le32(*symname != '/' ? SYMLINK_FLAG_RELATIVE : 0);
+
+	rc = smb2_create_reparse_point(xid, tcon, cifs_sb, full_path, buf, len);
+	if (rc)
+		goto out;
+
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid, tcon, full_path);
+	if (!IS_ERR(new))
+		d_instantiate(dentry, new);
+	else
+		rc = PTR_ERR(new);
+out:
+	kfree(path);
+	cifs_free_open_info(&data);
+	kfree(buf);
+	return rc;
+}
+
 static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  struct dentry *dentry, struct cifs_tcon *tcon,
 			  const char *full_path, umode_t mode, dev_t dev)
@@ -5376,6 +5442,7 @@ struct smb_version_operations smb20_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5478,6 +5545,7 @@ struct smb_version_operations smb21_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5583,6 +5651,7 @@ struct smb_version_operations smb30_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5697,6 +5766,7 @@ struct smb_version_operations smb311_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
-- 
2.42.1

