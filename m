Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="DR8yUkh8"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E7CC
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:37 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKDciLqrSZQ9TjHrZ5C8iWhHx3ouZL4kL0n+xHF3NP8=;
	b=DR8yUkh8Op1Qj9qbHhvSVTbw6SM0YCPbkCY2hSGzh5zh+NIKZwlZORurpmT2tX5Ti/nAMM
	mc0a5yPv798jHVRvM+bHR4/pzWxz0+iXHHXyE/Yz8iH01YPJsyCw/AoLK8FsLPDt8Qy2g8
	dy9S+gkZHWs9/XocCDjSdMCwE+a9BQVedO01j1zIMWqqog4nsu0LWpd+y+qJVDAeX/MP5Z
	varnQUCgsUywE9LmPFYaeTzDz9IFVkwraNK+6clitIPGC1FktMYWHBn0N8UlZlEAxdfXBw
	KaL8LDM3yT+bI5TyGyFA27zZrf4+aci2E+L254o50f332x+lG86RipkmAZ/rdQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967335; a=rsa-sha256;
	cv=none;
	b=FqThVeC8H/zejwXjudD37jyoI+n1gMb97sTShY/sdwIp0B190Xn7rVkQrThyazybxQw7pU
	GFm/4K9rbM13b7rUXAFfCkk/gHkVrFn4eIM1weKdx/PYa4ZokwgcZbKVs+eIKmMlvh2oAg
	NsZsHFug+oZXJ3LbRs6dax4P9oL9MnXDOWrFcm0OLmtJLXmy5LAXG4RUE0kBi9FHXtacHA
	Jkec+6xLGSM0+9w4eJs/s8StTPBjYVBvQ5sNsmb27dt6DYjToIJLYnbIdx3OVF/eBLp/Vt
	/6JPYI18E9gqCjmfBdfZfyoLihGwqX7mxQrlvKihFXGk291WU3HGTfQVeNMvCg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967335; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKDciLqrSZQ9TjHrZ5C8iWhHx3ouZL4kL0n+xHF3NP8=;
	b=JXJx74Kjs9aye+o2wc9X8xIdqxj0QP6NmxjJlmDERbs4pHp1hZbT11tWH/8k/YlFK9Ospp
	lRP8JdCE9PV2mhbmtzLq0zhJZE9qiLNo0ajZ3LoEhK4kP+gJgsUQgHfZsihEYoL8pICSN8
	bzi6F0N6tSSdUcpX813Ea6EZhaVa20uB2HlbSBycEQrYKKPSkQ0kPtJunH9A2mGhoa2koa
	3hlOt9KWlRt19VJYPpiTLIz4LdqufRvH/lke9zXgDxiy2tEkZxJbqZaizZ/1Ee8mvi1wE2
	O+u2awObqivTylTZPSivaqorch9Rfg5M7oZgjz+RyOUIUBkgxWzpzeVvhM7cvg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2 3/9] smb: client: allow creating symlinks via reparse points
Date: Sat, 25 Nov 2023 23:55:04 -0300
Message-ID: <20231126025510.28147-4-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
References: <20231126025510.28147-1-pc@manguebit.com>
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

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311260838.nx5mkj1j-lkp@intel.com/
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
index c1fe7ba02f6f..5bbba565ad5c 100644
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
+	int rc = 0;
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

