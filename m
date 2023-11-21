Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="c55Gx/15"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F5610E
	for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 15:13:15 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OoSVNP2oVJkFkTYPe/svGY/PoaEujrzgjwvBX4+DSvU=;
	b=c55Gx/15r1oKn4gRMIhlPOY1wAT7TJMNAmTTljl3kRzzY42ik9ebibvAKlOgKeojowCNzQ
	XF1pk8ujnI+1pOsopEDRgMCOSZFzXs+ZG+RJpyOhPMle4+aQYZDg8kmvyM5rbFZSYquGFt
	x37bkDzfvQ54IhOT18QpU4pu3j3Y1pjnBQetktGc1w86zcVxkYMW1NISfMirSPgIN0Zhjo
	ocOxSIT5n0yryTvPabey0hCdS2IEG6jDiOCgk6Vzd8P0lJvQhlSOU0UxiNn1ihB6CNzgVb
	hER0itDXpeCbDg8hNrVBrqmtO/jeLibUgKUODBtFKwEXd8K/2Y+GGsEfw4N1Rw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700608394; a=rsa-sha256;
	cv=none;
	b=L1O2jKkO7PNPJjCghOFNPRT2v/LuX6EsM6DnMt4W2UG0z0TKc9Dq0/5xGI0JL8TnlCTuB3
	O4U/0BUTSZubyjy8t3pnuIif8uieWKOR0u5K8Alm4BvZStzSMNGlmTB9O0F5HSfhrLOfO2
	SUcXs/MFYkvTrgIjWW8Y1ZLK+qg2jVIRY1zcx8S5LqrO1wct+232+BCk7ld4AAjyBljoT8
	TzE4reScdaJGo8xT8K9w/izUdEMSBfKx4yls5qLqC07CgPVRHXHrKXAUyzVctjsqPSOz1o
	H5qfh22VuK6K8pPbYp9LeVC7UzeQDpn/bwmlYOAADxM0HLwjmrtIu8SWG4jrsA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608394; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OoSVNP2oVJkFkTYPe/svGY/PoaEujrzgjwvBX4+DSvU=;
	b=O6LWIP1q5bdEPfOKJLgJtZdGklRlGcOig916/wS5YuRNeKCqAaEsz2p9lTYRxRjd3uWnT5
	OUlcoPAgsGOrZqwQf9tWgtXPVBwPRB1leyZLQWEHFvQNPIyPt7N0TsR8Uavnc8/e/IKCHw
	kmkMgp4fGLZ0QPmMs2XSjrwWRCidsaZOV/xyIBcY6ZGcE975RC78uPrBu2QyrWGq3wsLcw
	Mqf/1HRw5w36grq8TTWDDs7mYg3WGOxKKKdx2P6+IkFUnzFVc2PehvwOJQq4w8qdKOwIqG
	skXhBkeuUil0T1AUz21t4/6fQg8Zu6q3wxkn5Fnpt4z2JJlgIaEKgct2yhdN3Q==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 5/7] smb: client: allow creating special files via reparse points
Date: Tue, 21 Nov 2023 20:12:56 -0300
Message-ID: <20231121231258.29562-5-pc@manguebit.com>
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

Add support for creating special files (e.g. char/block devices,
sockets, fifos) via NFS reparse points on SMB2+, which are fully
supported by most SMB servers and documented in MS-FSCC.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/inode.c     |   3 +-
 fs/smb/client/smb2inode.c |  32 +++++++
 fs/smb/client/smb2ops.c   | 185 ++++++++++++++++++++++++++++++++++++--
 fs/smb/client/smb2proto.h |  10 +++
 4 files changed, 220 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 47f49be69ced..88b7cf23348c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1090,7 +1090,8 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		rc = 0;
 		goto out;
 	default:
-		if (data->symlink_target) {
+		/* Check for cached reparse point data */
+		if (data->symlink_target || data->reparse.buf) {
 			rc = 0;
 		} else if (server->ops->parse_reparse_point) {
 			rc = server->ops->parse_reparse_point(cifs_sb,
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c94940af5d4b..c09da386a36b 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -529,6 +529,38 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+				     struct super_block *sb,
+				     const unsigned int xid,
+				     struct cifs_tcon *tcon,
+				     const char *full_path)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifsFileInfo *cfile;
+	struct inode *new = NULL;
+	int rc;
+
+	if (tcon->posix_extensions) {
+		rc = smb311_posix_get_inode_info(&new, full_path, sb, xid);
+	} else {
+		/*
+		 * Since we know it is a reparse point already, query info it
+		 * directly and provide cached file metadata to
+		 * cifs_get_inode_info() in order to avoid extra roundtrips.
+		 */
+		cifs_get_readable_path(tcon, full_path, &cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				      FILE_READ_ATTRIBUTES, FILE_OPEN,
+				      OPEN_REPARSE_POINT, ACL_NO_MODE, data,
+				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
+				      NULL, NULL);
+		if (rc)
+			return ERR_PTR(rc);
+		rc = cifs_get_inode_info(&new, full_path, data, sb, xid, NULL);
+	}
+	return rc ? ERR_PTR(rc) : new;
+}
+
 static int parse_create_response(struct cifs_open_info_data *data,
 				 struct cifs_sb_info *cifs_sb,
 				 const struct kvec *iov)
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 82ab62fd0040..bc069deb5031 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3114,6 +3114,97 @@ static int smb2_query_reparse_point(const unsigned int xid,
 	return rc;
 }
 
+int smb2_create_reparse_point(const unsigned int xid,
+			      struct cifs_tcon *tcon,
+			      struct cifs_sb_info *cifs_sb,
+			      const char *full_path,
+			      void *rbuf, u16 rsize)
+{
+	struct smb2_compound_vars *vars;
+	struct cifs_open_parms oparms;
+	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
+	struct smb_rqst *rqst;
+	struct cifs_fid fid;
+	struct kvec *rsp_iov;
+	__le16 *utf16_path = NULL;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
+	int resp_buftype[3];
+	int rc;
+
+	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
+
+	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
+	if (!vars) {
+		kfree(utf16_path);
+		return -ENOMEM;
+	}
+	rqst = vars->rqst;
+	rsp_iov = vars->rsp_iov;
+
+	rqst[0].rq_iov = vars->open_iov;
+	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = SYNCHRONIZE | DELETE |
+				FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      OPEN_REPARSE_POINT),
+		.disposition = FILE_CREATE,
+		.path = full_path,
+		.fid = &fid,
+	};
+
+	rc = SMB2_open_init(tcon, server, &rqst[0],
+			    &oplock, &oparms, utf16_path);
+	if (rc)
+		goto out;
+	smb2_set_next_command(tcon, &rqst[0]);
+
+	rqst[1].rq_iov = vars->io_iov;
+	rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
+
+	rc = SMB2_ioctl_init(tcon, server, &rqst[1],
+			     COMPOUND_FID, COMPOUND_FID,
+			     FSCTL_SET_REPARSE_POINT,
+			     rbuf, rsize, 0);
+	if (rc)
+		goto out;
+	smb2_set_next_command(tcon, &rqst[1]);
+	smb2_set_related(&rqst[1]);
+
+	rqst[2].rq_iov = &vars->close_iov;
+	rqst[2].rq_nvec = 1;
+
+	rc = SMB2_close_init(tcon, server, &rqst[2],
+			     COMPOUND_FID, COMPOUND_FID, false);
+	if (rc)
+		goto out;
+	smb2_set_related(&rqst[2]);
+
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
+	rc = compound_send_recv(xid, tcon->ses, server, flags,
+				3, rqst, resp_buftype, rsp_iov);
+
+out:
+	SMB2_open_free(&rqst[0]);
+	SMB2_ioctl_free(&rqst[1]);
+	SMB2_close_free(&rqst[2]);
+	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
+	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	kfree(utf16_path);
+	kfree(vars);
+	return rc;
+}
+
 static struct cifs_ntsd *
 get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
 		    const struct cifs_fid *cifsfid, u32 *pacllen, u32 info)
@@ -5133,11 +5224,88 @@ int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+static inline u64 mode_nfs_type(mode_t mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFBLK: return NFS_SPECFILE_BLK;
+	case S_IFCHR: return NFS_SPECFILE_CHR;
+	case S_IFIFO: return NFS_SPECFILE_FIFO;
+	case S_IFSOCK: return NFS_SPECFILE_SOCK;
+	}
+	return 0;
+}
+
+static int create_nfs_reparse(const unsigned int xid,
+			      struct cifs_tcon *tcon,
+			      struct cifs_sb_info *cifs_sb,
+			      const char *full_path, mode_t mode,
+			      struct reparse_posix_data *buf)
+{
+	u64 type;
+	u16 len, dlen;
+
+	len = sizeof(*buf);
+
+	switch ((type = mode_nfs_type(mode))) {
+	case NFS_SPECFILE_BLK:
+	case NFS_SPECFILE_CHR:
+		dlen = sizeof(__le64);
+		break;
+	case NFS_SPECFILE_FIFO:
+	case NFS_SPECFILE_SOCK:
+		dlen = 0;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	buf->ReparseTag = cpu_to_le32(IO_REPARSE_TAG_NFS);
+	buf->InodeType = cpu_to_le64(type);
+	buf->ReparseDataLength = cpu_to_le16(len + dlen -
+					     sizeof(struct reparse_data_buffer));
+
+	return smb2_create_reparse_point(xid, tcon, cifs_sb,
+					 full_path, buf, len + dlen);
+}
+
+static int nfs_make_node(unsigned int xid, struct inode *inode,
+			 struct dentry *dentry, struct cifs_tcon *tcon,
+			 const char *full_path, umode_t mode, dev_t dev)
+{
+	struct cifs_open_info_data data;
+	struct reparse_posix_data *p;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct inode *new;
+	__u8 buf[sizeof(*p) + sizeof(__le64)];
+	int rc;
+
+	p = (struct reparse_posix_data *)buf;
+	*(__le64 *)p->DataBuffer = cpu_to_le64(((u64)MAJOR(dev) << 32) |
+					       MINOR(dev));
+
+	rc = create_nfs_reparse(xid, tcon, cifs_sb, full_path, mode, p);
+	if (rc)
+		return rc;
+
+	data = (struct cifs_open_info_data) {
+		.reparse_point = true,
+		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
+	};
+
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid, tcon, full_path);
+	if (!IS_ERR(new))
+		d_instantiate(dentry, new);
+	else
+		rc = PTR_ERR(new);
+	return rc;
+}
+
 static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  struct dentry *dentry, struct cifs_tcon *tcon,
 			  const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	int rc;
 
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
@@ -5145,15 +5313,14 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device (no socket & fifo),
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return -EPERM;
-	/*
-	 * TODO: Add ability to create instead via reparse point. Windows (e.g.
-	 * their current NFS server) uses this approach to expose special files
-	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
-	 */
-	return cifs_sfu_make_node(xid, inode, dentry, tcon,
-				  full_path, mode, dev);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
+					full_path, mode, dev);
+	} else {
+		rc = nfs_make_node(xid, inode, dentry, tcon,
+				   full_path, mode, dev);
+	}
+	return rc;
 }
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 46eff9ec302a..c98cda998de2 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -56,6 +56,11 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb, const char *path,
 				__u32 *reparse_tag);
+struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+				     struct super_block *sb,
+				     const unsigned int xid,
+				     struct cifs_tcon *tcon,
+				     const char *full_path);
 int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
@@ -287,4 +292,9 @@ int smb311_posix_query_path_info(const unsigned int xid,
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
 int posix_info_sid_size(const void *beg, const void *end);
+int smb2_create_reparse_point(const unsigned int xid,
+			      struct cifs_tcon *tcon,
+			      struct cifs_sb_info *cifs_sb,
+			      const char *full_path,
+			      void *rbuf, u16 rsize);
 #endif			/* _SMB2PROTO_H */
-- 
2.42.1

