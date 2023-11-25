Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="FFFdQxgz"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0C1115
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 14:08:32 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HS6UiNMa31HBEVoWz/Kpl7owJyaoFXBedGpmjWXHM0s=;
	b=FFFdQxgzOkkiea6kYR7PxV0ja9+mM9Ar3HegwOMnQRMESGXXTFzNSyiWBUdukfASTru6rp
	G5BqmES/i174Wv1z43ypcikL248tmeYL+ZnhD6MU4wp5Z/oY6qEXAMH6xtReosHEaD6efZ
	HQQAK0+yppt122BWfMIPTL6hui+1GGdXVysrgbFC0xz9vASlIkrX+RgUk7QkWavfUE/Cn1
	3I60vL+Wfu6mM8f4cqGlgp/R+BqBUtCz0pDQ4j6m2vD6yka5cSF2es/WT1oWUO5rD7F8Ij
	/TQiRLBGbP+7bRKSbUnawF1atWU7YKWgRCvGxPSDOjqaprKrs4D6IQ8VYNyB6g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700950111; a=rsa-sha256;
	cv=none;
	b=e5W/5XMpQ3XbX8CRf70fkcmLcNaneo7piiHsNhC47iZXT00+ECPabjtlAvF5jgfNdNNUEO
	OiZ4Ei22X3vaZEujKLEd5dr9P0TBDb6nuLTqFCQNgBcvVnrBykBODL5tobT8bMKdxQZNYJ
	yNgiN8Bwaa8yQqCF3bgCmEmM051hMK2FEqE4N8grfVWanfi3I/FP/VwLe1pBOuxWwSq6iF
	BsvdNTHDmq7QG0cPPc6twrrKL12HsQHlkNhFZSB7CR7O8pJi3HnMIdwyz7/9GZywyJEk7b
	Y4a9rWADthtnjPSjqDycKXzXKRDb2vBGAJKaoiF9MVg1cqugVUa2sL0/wtGEVQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950111; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HS6UiNMa31HBEVoWz/Kpl7owJyaoFXBedGpmjWXHM0s=;
	b=Ofc6bEs3dnwMgK570u9kpl3v67C1IrAIEEVy5sVXDOmaYuRPb97gxjyA/1o5Jea5hRzAxI
	a3h8xpLxD76i1Of1glEex0RU/+HMdc0rdiR15aAGTh+yyCmWhkQAnCMJti/smDxVfNdIY4
	Idn1LF1DhUi5qkSUb+QXWp9URQ+IDDylRkAYcK9XRJRztxjOV6/AsFuVHD6BxQkZL8jdWN
	zEug/iSRfCmCxN7r0y8FESYsDaJy2vWro/ZRHRdNtlOgPgmW3M212sT58mbSNyYu8KGR2Y
	mfsUCb5su9aU1a4ck5ZQfkG9WU6ZNPmEGi/VPq4UetLCHpP4xP51FKYZWfYCBg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/8] smb: client: allow creating symlinks via reparse points
Date: Sat, 25 Nov 2023 19:08:08 -0300
Message-ID: <20231125220813.30538-4-pc@manguebit.com>
In-Reply-To: <20231125220813.30538-1-pc@manguebit.com>
References: <20231125220813.30538-1-pc@manguebit.com>
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
index be84683b01ee..cec8f8d53e2e 100644
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
index 5ce0f74be4ec..82fb069c6ce4 100644
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
 		if (pTcon->posix_extensions) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c1fe7ba02f6f..c8441e766369 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5209,6 +5209,72 @@ static int nfs_make_node(unsigned int xid, struct inode *inode,
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
+	struct kvec iov;
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
+	iov.iov_base = buf;
+	iov.iov_len = len;
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+				     tcon, full_path, &iov);
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
@@ -5285,6 +5351,7 @@ struct smb_version_operations smb20_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5387,6 +5454,7 @@ struct smb_version_operations smb21_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5492,6 +5560,7 @@ struct smb_version_operations smb30_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5606,6 +5675,7 @@ struct smb_version_operations smb311_operations = {
 	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
+	.create_reparse_symlink = smb2_create_reparse_symlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
-- 
2.43.0

