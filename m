Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AB81F8902;
	Fri, 27 Dec 2024 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321276; cv=none; b=jW8muxUPpFkok+TcKqkCfKApSKs5d5SnLC2XHeYiNGsy+Du2e7b/jPIJAP6sM7U4UeTc+bejuMrKwLnzS59OX0gDYNj8RBsRNtUpsGhUCrUMA+3NTi0aXn8nBmL1UTVs8IZqw7Ed4EvNgoeoC0mDLBD8PQ3fJqVmiH4AGtep6PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321276; c=relaxed/simple;
	bh=aMh6eyQJmCXo1gnF6PgVpby0tODrWii2A+N+sdIJfY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F1xU7kT1Lahkp4FicPFZ0LKIe7CE16bjBFrmwQsMprmS1YI/UfyresK7wEzAv8RpFRrkKBxJsNpwQASQlOuzFOHlpYOtchF46RIehbQp0lbpVLEO82WEdpNKcAKqk0BjPRvjO3w2H4z2I3G0Y+Pe6U4k2umVAECB+XbD6Z6hCeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHH/bpUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHH/bpUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF96C4CED7;
	Fri, 27 Dec 2024 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321275;
	bh=aMh6eyQJmCXo1gnF6PgVpby0tODrWii2A+N+sdIJfY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHH/bpUE4Escliu9Y3QiIZS9hSibIB7FAJkJsa4Z1cBSW3Us9rP7gvKAynpJjDgGB
	 TgeuwzY8K7Z/RHeiXbazQxr31d70md/ZFhUCJVBGwo4sbXz/yyQPM4StKoOHV9upSE
	 YVVr/gleuDr9qzGnkOHYjHtzHu+rus8atysugQ1WZ1TB8S9EvdDluYGNJrfgyFTD0c
	 TaZCwDyCGZXNldQ4tOp7/eVovWeqklOCjVHOIe+AkpWoIkitMQndT8BdHOmYuc2VdM
	 aghQi8ScXajH2+IhiNcqoqTpDMgdEQi5D1QZ4l4WJcWhapMeEbna6I5rJbNJ/F9dyM
	 ZP08j3sEWTuUQ==
Received: by pali.im (Postfix)
	id E77CEA7F; Fri, 27 Dec 2024 18:41:05 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cifs: Add support for creating reparse points over SMB1
Date: Fri, 27 Dec 2024 18:40:47 +0100
Message-Id: <20241227174047.23030-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241227174047.23030-1-pali@kernel.org>
References: <20241227174047.23030-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB1 already supports querying reparse points and detecting types of
symlink, fifo, socket, block and char.

This change implements the missing part - ability to create a new reparse
points over SMB1. This includes everything which SMB2+ already supports:
- native SMB symlinks and sockets
- NFS style of special files (symlinks, fifos, sockets, char/block devs)
- WSL style of special files (symlinks, fifos, sockets, char/block devs)

Attaching a reparse point to an existing file or directory is done via
SMB1 SMB_COM_NT_TRANSACT/NT_TRANSACT_IOCTL/FSCTL_SET_REPARSE_POINT command
and implemented in a new cifs_create_reparse_inode() function.

This change introduce a new callback ->create_reparse_inode() which creates
a new reperse point file or directory and returns inode. For SMB1 it is
provided via that new cifs_create_reparse_inode() function.

Existing reparse.c code was only slightly updated to call new protocol
callback ->create_reparse_inode() instead of hardcoded SMB2+ function.
This make the whole reparse.c code to work with every SMB dialect.

The original callback ->create_reparse_symlink() is not needed anymore as
the implementation of new create_reparse_symlink() function is dialect
agnostic too. So the link.c code was updated to call that function directly
(and not via callback).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  14 +++--
 fs/smb/client/cifsproto.h |   8 +++
 fs/smb/client/cifssmb.c   | 128 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/link.c      |  13 ++--
 fs/smb/client/reparse.c   |  16 +++--
 fs/smb/client/reparse.h   |   4 +-
 fs/smb/client/smb1ops.c   |  31 ++++++---
 fs/smb/client/smb2inode.c |   2 +-
 fs/smb/client/smb2ops.c   |  10 +--
 fs/smb/client/smb2proto.h |   5 +-
 10 files changed, 188 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index e1deb5f6209d..06ad727e824b 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -625,12 +625,14 @@ struct smb_version_operations {
 	bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
 	struct reparse_data_buffer * (*get_reparse_point_buffer)(const struct kvec *rsp_iov,
 								 u32 *plen);
-	int (*create_reparse_symlink)(const unsigned int xid,
-				      struct inode *inode,
-				      struct dentry *dentry,
-				      struct cifs_tcon *tcon,
-				      const char *full_path,
-				      const char *symname);
+	struct inode * (*create_reparse_inode)(struct cifs_open_info_data *data,
+					       struct super_block *sb,
+					       const unsigned int xid,
+					       struct cifs_tcon *tcon,
+					       const char *full_path,
+					       bool directory,
+					       struct kvec *reparse_iov,
+					       struct kvec *xattr_iov);
 };
 
 struct smb_version_values {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 9833837c6299..ea8a0ecce9dc 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -477,6 +477,14 @@ extern int cifs_query_reparse_point(const unsigned int xid,
 				    const char *full_path,
 				    u32 *tag, struct kvec *rsp,
 				    int *rsp_buftype);
+extern struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
+					       struct super_block *sb,
+					       const unsigned int xid,
+					       struct cifs_tcon *tcon,
+					       const char *full_path,
+					       bool directory,
+					       struct kvec *reparse_iov,
+					       struct kvec *xattr_iov);
 extern int CIFSSMB_set_compression(const unsigned int xid,
 				   struct cifs_tcon *tcon, __u16 fid);
 extern int CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index ff8633fde85c..dd71c4c8f776 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2795,6 +2795,134 @@ int cifs_query_reparse_point(const unsigned int xid,
 	return rc;
 }
 
+struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
+					struct super_block *sb,
+					const unsigned int xid,
+					struct cifs_tcon *tcon,
+					const char *full_path,
+					bool directory,
+					struct kvec *reparse_iov,
+					struct kvec *xattr_iov)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_open_parms oparms;
+	TRANSACT_IOCTL_REQ *io_req;
+	struct inode *new = NULL;
+	struct kvec in_iov[2];
+	struct kvec out_iov;
+	struct cifs_fid fid;
+	int io_req_len;
+	int oplock = 0;
+	int buf_type = 0;
+	int rc;
+
+	cifs_tcon_dbg(FYI, "%s: path=%s\n", __func__, full_path);
+
+	/*
+	 * If server filesystem does not support reparse points then do not
+	 * attempt to create reparse point. This will prevent creating unusable
+	 * empty object on the server.
+	 */
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+		return ERR_PTR(-EOPNOTSUPP);
+
+#ifndef CONFIG_CIFS_XATTR
+	if (xattr_iov)
+		return ERR_PTR(-EOPNOTSUPP);
+#endif
+
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     FILE_READ_ATTRIBUTES | FILE_WRITE_DATA | FILE_WRITE_EA,
+			     FILE_CREATE,
+			     (directory ? CREATE_NOT_FILE : CREATE_NOT_DIR) | OPEN_REPARSE_POINT,
+			     ACL_NO_MODE);
+	oparms.fid = &fid;
+
+	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	if (rc)
+		return ERR_PTR(rc);
+
+#ifdef CONFIG_CIFS_XATTR
+	if (xattr_iov) {
+		struct smb2_file_full_ea_info *ea;
+
+		ea = &((struct smb2_create_ea_ctx *)xattr_iov->iov_base)->ea;
+		while (1) {
+			rc = CIFSSMBSetEA(xid,
+					  tcon,
+					  full_path,
+					  &ea->ea_data[0],
+					  &ea->ea_data[ea->ea_name_length+1],
+					  le16_to_cpu(ea->ea_value_length),
+					  cifs_sb->local_nls,
+					  cifs_sb);
+			if (rc)
+				goto out_close;
+			if (le32_to_cpu(ea->next_entry_offset) == 0)
+				break;
+			ea = (struct smb2_file_full_ea_info *)((u8 *)ea +
+				le32_to_cpu(ea->next_entry_offset));
+		}
+	}
+#endif
+
+	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **)&io_req, NULL);
+	if (rc)
+		goto out_close;
+
+	inc_rfc1001_len(io_req, sizeof(io_req->Pad));
+
+	io_req_len = be32_to_cpu(io_req->hdr.smb_buf_length) + sizeof(io_req->hdr.smb_buf_length);
+
+	/* NT IOCTL response contains one-word long output setup buffer with size of output data. */
+	io_req->MaxSetupCount = 1;
+	/* NT IOCTL response does not contain output parameters. */
+	io_req->MaxParameterCount = cpu_to_le32(0);
+	/* FSCTL_SET_REPARSE_POINT response contains empty output data. */
+	io_req->MaxDataCount = cpu_to_le32(0);
+
+	io_req->TotalParameterCount = cpu_to_le32(0);
+	io_req->TotalDataCount = cpu_to_le32(reparse_iov->iov_len);
+	io_req->ParameterCount = io_req->TotalParameterCount;
+	io_req->ParameterOffset = cpu_to_le32(0);
+	io_req->DataCount = io_req->TotalDataCount;
+	io_req->DataOffset = cpu_to_le32(offsetof(typeof(*io_req), Data) -
+					 sizeof(io_req->hdr.smb_buf_length));
+	io_req->SetupCount = 4;
+	io_req->SubCommand = cpu_to_le16(NT_TRANSACT_IOCTL);
+	io_req->FunctionCode = cpu_to_le32(FSCTL_SET_REPARSE_POINT);
+	io_req->Fid = fid.netfid;
+	io_req->IsFsctl = 1;
+	io_req->IsRootFlag = 0;
+	io_req->ByteCount = cpu_to_le32(le32_to_cpu(io_req->DataCount) + sizeof(io_req->Pad));
+
+	inc_rfc1001_len(io_req, reparse_iov->iov_len);
+
+	in_iov[0].iov_base = (char *)io_req;
+	in_iov[0].iov_len = io_req_len;
+	in_iov[1] = *reparse_iov;
+	rc = SendReceive2(xid, tcon->ses, in_iov, ARRAY_SIZE(in_iov), &buf_type,
+			  CIFS_NO_RSP_BUF, &out_iov);
+
+	cifs_buf_release(io_req);
+
+	if (!rc)
+		rc = cifs_get_inode_info(&new, full_path, data, sb, xid, NULL);
+
+out_close:
+	CIFSSMBClose(xid, tcon, fid.netfid);
+
+	/*
+	 * If CREATE was successful but FSCTL_SET_REPARSE_POINT failed then
+	 * remove the intermediate object created by CREATE. Otherwise
+	 * empty object stay on the server when reparse call failed.
+	 */
+	if (rc)
+		CIFSSMBDelFile(xid, tcon, full_path, cifs_sb, NULL);
+
+	return rc ? ERR_PTR(rc) : new;
+}
+
 int
 CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		    __u16 fid)
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index a88253668286..b1a346e20b07 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -19,6 +19,7 @@
 #include "smb2proto.h"
 #include "cifs_ioctl.h"
 #include "fs_context.h"
+#include "reparse.h"
 
 /*
  * M-F Symlink Functions - Begin
@@ -570,7 +571,6 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	int rc = -EOPNOTSUPP;
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	const char *full_path;
@@ -593,7 +593,6 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 		goto symlink_exit;
 	}
 	pTcon = tlink_tcon(tlink);
-	server = cifs_pick_channel(pTcon->ses);
 
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
@@ -643,13 +642,9 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	case CIFS_SYMLINK_TYPE_NATIVE:
 	case CIFS_SYMLINK_TYPE_NFS:
 	case CIFS_SYMLINK_TYPE_WSL:
-		if (server->ops->create_reparse_symlink &&
-		    (le32_to_cpu(pTcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS)) {
-			rc = server->ops->create_reparse_symlink(xid, inode,
-								 direntry,
-								 pTcon,
-								 full_path,
-								 symname);
+		if (le32_to_cpu(pTcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
+			rc = create_reparse_symlink(xid, inode, direntry, pTcon,
+						    full_path, symname);
 			goto symlink_exit;
 		}
 		break;
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 9e40f5709c7f..69efbcae6683 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -34,7 +34,7 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 					   const char *symname,
 					   bool *directory);
 
-int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
+int create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname)
 {
@@ -225,7 +225,8 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 
 	iov.iov_base = buf;
 	iov.iov_len = len;
-	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+	new = tcon->ses->server->ops->create_reparse_inode(
+				     &data, inode->i_sb, xid,
 				     tcon, full_path, directory,
 				     &iov, NULL);
 	if (!IS_ERR(new))
@@ -397,7 +398,8 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 	struct inode *new;
 	int rc = 0;
 
-	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+	new = tcon->ses->server->ops->create_reparse_inode(
+				     &data, inode->i_sb, xid,
 				     tcon, full_path, false, &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
@@ -490,7 +492,8 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 		.symlink_target = kstrdup(symname, GFP_KERNEL),
 	};
 
-	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+	new = tcon->ses->server->ops->create_reparse_inode(
+				     &data, inode->i_sb, xid,
 				     tcon, full_path, false, &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
@@ -683,7 +686,8 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	memcpy(data.wsl.eas, &cc->ea, len);
 	data.wsl.eas_len = len;
 
-	new = smb2_get_reparse_inode(&data, inode->i_sb,
+	new = tcon->ses->server->ops->create_reparse_inode(
+				     &data, inode->i_sb,
 				     xid, tcon, full_path, false,
 				     &reparse_iov, &xattr_iov);
 	if (!IS_ERR(new))
@@ -696,7 +700,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
-int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
+int mknod_reparse(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev)
 {
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index c17130657def..8cb11db076a7 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -113,10 +113,10 @@ static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 				 struct cifs_fattr *fattr,
 				 struct cifs_open_info_data *data);
-int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
+int create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname);
-int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
+int mknod_reparse(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
 struct reparse_data_buffer *smb2_get_reparse_point_buffer(const struct kvec *rsp_iov, u32 *len);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index c52fc4c1557c..a0a15dda0949 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -16,6 +16,7 @@
 #include "fs_context.h"
 #include "nterr.h"
 #include "smberr.h"
+#include "reparse.h"
 
 /*
  * An NT cancel request header looks just like the original request except:
@@ -1076,17 +1077,26 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 		if (rc == 0)
 			d_instantiate(dentry, newinode);
 		return rc;
+	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+		/*
+		 * Check if mounted with mount parm 'sfu' mount parm.
+		 * SFU emulation should work with all servers
+		 * and was used by default in earlier versions of Windows.
+		 */
+		return cifs_sfu_make_node(xid, inode, dentry, tcon,
+					  full_path, mode, dev);
+	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
+		/*
+		 * mknod via reparse points requires server support for
+		 * storing reparse points, which is available since
+		 * Windows 2000, but was not widely used until release
+		 * of Windows Server 2012 by the Windows NFS server.
+		 */
+		return mknod_reparse(xid, inode, dentry, tcon,
+				     full_path, mode, dev);
+	} else {
+		return -EOPNOTSUPP;
 	}
-	/*
-	 * Check if mounted with mount parm 'sfu' mount parm.
-	 * SFU emulation should work with all servers, but only
-	 * supports block and char device, socket & fifo,
-	 * and was used by default in earlier versions of Windows
-	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return -EPERM;
-	return cifs_sfu_make_node(xid, inode, dentry, tcon,
-				  full_path, mode, dev);
 }
 
 static bool
@@ -1183,6 +1193,7 @@ struct smb_version_operations smb1_operations = {
 	.create_hardlink = CIFSCreateHardLink,
 	.query_symlink = cifs_query_symlink,
 	.get_reparse_point_buffer = cifs_get_reparse_point_buffer,
+	.create_reparse_inode = cifs_create_reparse_inode,
 	.open = cifs_open_file,
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 426dbaff270a..0b8d6d8f724d 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1305,7 +1305,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	return rc;
 }
 
-struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     struct super_block *sb,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ba81b662f5c7..4aa9f3ac4c34 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5232,7 +5232,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
-		rc = smb2_mknod_reparse(xid, inode, dentry, tcon,
+		rc = mknod_reparse(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	}
 	return rc;
@@ -5291,7 +5291,7 @@ struct smb_version_operations smb20_operations = {
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
-	.create_reparse_symlink = smb2_create_reparse_symlink,
+	.create_reparse_inode = smb2_create_reparse_inode,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5394,7 +5394,7 @@ struct smb_version_operations smb21_operations = {
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
-	.create_reparse_symlink = smb2_create_reparse_symlink,
+	.create_reparse_inode = smb2_create_reparse_inode,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5501,7 +5501,7 @@ struct smb_version_operations smb30_operations = {
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
-	.create_reparse_symlink = smb2_create_reparse_symlink,
+	.create_reparse_inode = smb2_create_reparse_inode,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
@@ -5617,7 +5617,7 @@ struct smb_version_operations smb311_operations = {
 	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
-	.create_reparse_symlink = smb2_create_reparse_symlink,
+	.create_reparse_inode = smb2_create_reparse_inode,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 2336dfb23f36..cec5921bfdd2 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -54,7 +54,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb, const char *path,
 				__u32 *reparse_tag);
-struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     struct super_block *sb,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
@@ -317,9 +317,6 @@ int smb311_posix_query_path_info(const unsigned int xid,
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
 int posix_info_sid_size(const void *beg, const void *end);
-int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
-				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path, const char *symname);
 int smb2_make_nfs_node(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
-- 
2.20.1

