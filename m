Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="A844aujt"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BFA103
	for <linux-cifs@vger.kernel.org>; Sun, 19 Nov 2023 10:22:26 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700418144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1Ym6zn3qet6HFvhRtMmdFlNw7sW1hE0gqyfsV1gbUU=;
	b=A844aujt5GXTKtu+YC1USv3O5MKIsIIkh5aP7iiw0fH7CKhf/tk9nCJamp/O2v5QyDBcKk
	QHrADjOKtmIBTfnZuitU+RhMItb1tIY6CK4vyoBKhJ+L/OCyh8xVlWWS7fYtd839AZyu+P
	EIw8thRAK8dkX64X3WcK6X7g1LiTik8VElrnKGoifmNsvGTuEyGqrzIV5NGQ5cewd8UKNa
	Xloxo6iesmMTU9AoxOFJk2kWHlNRF2mPHPo6p2Sno7bQ4++B6/2A23Yc0b1jIwGpTqSNHq
	8yFXvqRLDjcaDXc4xA3g/2dVRFfjm55I2YnlO5FJvQz22BbZIGBBqeDS7S3gYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700418144; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1Ym6zn3qet6HFvhRtMmdFlNw7sW1hE0gqyfsV1gbUU=;
	b=llcuwTofBc5V6Zy8UUCxlzNxgZVhC3MPNBP2mvftYa64PCL27k/JY2QwbCFGimTVgHJ1Me
	ov/WJEsfjTnxyn8YJpDlxkwO8+Zy5AWAREHZjcEuKKhhIARuR1jGRXSi6KRedE1ehmxsC1
	kz4Qlhs/3rOAZ4cpR+4XLKGyy0vWOknwFUxoSHgnsNQiEVhUR1JpmaQBQnnQCVBpyxMtR3
	74JPWc6vMEDHmPZgP9sF5hOm+H/Z4HuY6gB+SfRjcFJjh69KiP4Pgyduu2JMWYr94T9FXE
	EoYq6fGGITd6jCa2vmCANMT+qgu5M7EcgctuZV3edZ8xOyeEyM2UhtRV7XToXA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700418144; a=rsa-sha256;
	cv=none;
	b=AieE+41nVWz9GiqzNs7VJOLoT12X3Rk9rVEnQ1RlZS9Sp3Nbdn78ZzYlafHWquiJyPfjHq
	9nyb1RZK0Hatnw5OyVMio5rNYwCt1ksXAUMDzd6cyHUFKWHAuJLvDt4c8RuXt/AhDzJkGd
	1c3pWoRuqlXXRZOxaSXxqN5Ey/y+3fhhLPCPXXzm4MEfDp+W7kvbw2E3GmQ17suPZUk+on
	GaC3vy50m7Mub9KfEMUhU/qWYUXtO4DHeqL3I19krWolpVo+7yalxZRVpsTT8LyVkogQqT
	0/YAD5T2CsgqmRynw2jajoN6w62nySHIKRg00sJI2NBXRy/MbEU0tweC+pDTJQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/3] smb: client: introduce ->parse_reparse_point()
Date: Sun, 19 Nov 2023 15:22:08 -0300
Message-ID: <20231119182209.5140-2-pc@manguebit.com>
In-Reply-To: <20231119182209.5140-1-pc@manguebit.com>
References: <20231119182209.5140-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parse reparse point into cifs_open_info_data structure and feed it
through cifs_open_info_to_fattr().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h |  6 ++++--
 fs/smb/client/inode.c    | 23 +++++++++++++---------
 fs/smb/client/smb1ops.c  | 41 ++++++++++++++++++++++------------------
 fs/smb/client/smb2ops.c  | 22 +++++++++------------
 4 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6ffbd81bd109..111daa4ff261 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -395,8 +395,7 @@ struct smb_version_operations {
 			     struct cifs_tcon *tcon,
 			     struct cifs_sb_info *cifs_sb,
 			     const char *full_path,
-			     char **target_path,
-			     struct kvec *rsp_iov);
+			     char **target_path);
 	/* open a file for non-posix mounts */
 	int (*open)(const unsigned int xid, struct cifs_open_parms *oparms, __u32 *oplock,
 		    void *buf);
@@ -551,6 +550,9 @@ struct smb_version_operations {
 	bool (*is_status_io_timeout)(char *buf);
 	/* Check for STATUS_NETWORK_NAME_DELETED */
 	bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
+	int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
+				   struct kvec *rsp_iov,
+				   struct cifs_open_info_data *data);
 };
 
 struct smb_version_values {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 86fbd3f847d6..dd482de3dc3f 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -459,8 +459,7 @@ static int cifs_get_unix_fattr(const unsigned char *full_path,
 			return -EOPNOTSUPP;
 		rc = server->ops->query_symlink(xid, tcon,
 						cifs_sb, full_path,
-						&fattr->cf_symlink_target,
-						NULL);
+						&fattr->cf_symlink_target);
 		cifs_dbg(FYI, "%s: query_symlink: %d\n", __func__, rc);
 	}
 	return rc;
@@ -1035,22 +1034,28 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		if (!rc)
 			iov = &rsp_iov;
 	}
+
+	rc = -EOPNOTSUPP;
 	switch ((data->reparse_tag = tag)) {
 	case 0: /* SMB1 symlink */
-		iov = NULL;
-		fallthrough;
-	case IO_REPARSE_TAG_NFS:
-	case IO_REPARSE_TAG_SYMLINK:
-		if (!data->symlink_target && server->ops->query_symlink) {
+		if (server->ops->query_symlink) {
 			rc = server->ops->query_symlink(xid, tcon,
 							cifs_sb, full_path,
-							&data->symlink_target,
-							iov);
+							&data->symlink_target);
 		}
 		break;
 	case IO_REPARSE_TAG_MOUNT_POINT:
 		cifs_create_junction_fattr(fattr, sb);
+		rc = 0;
 		goto out;
+	default:
+		if (data->symlink_target) {
+			rc = 0;
+		} else if (server->ops->parse_reparse_point) {
+			rc = server->ops->parse_reparse_point(cifs_sb,
+							      iov, data);
+		}
+		break;
 	}
 
 	cifs_open_info_to_fattr(fattr, data, sb);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 6b4d8effa79d..0dd599004e04 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -976,32 +976,36 @@ static int cifs_query_symlink(const unsigned int xid,
 			      struct cifs_tcon *tcon,
 			      struct cifs_sb_info *cifs_sb,
 			      const char *full_path,
-			      char **target_path,
-			      struct kvec *rsp_iov)
+			      char **target_path)
+{
+	int rc;
+
+	cifs_tcon_dbg(FYI, "%s: path=%s\n", __func__, full_path);
+
+	if (!cap_unix(tcon->ses))
+		return -EOPNOTSUPP;
+
+	rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, target_path,
+				     cifs_sb->local_nls, cifs_remap(cifs_sb));
+	if (rc == -EREMOTE)
+		rc = cifs_unix_dfs_readlink(xid, tcon, full_path,
+					    target_path, cifs_sb->local_nls);
+	return rc;
+}
+
+static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
+				    struct kvec *rsp_iov,
+				    struct cifs_open_info_data *data)
 {
 	struct reparse_data_buffer *buf;
 	TRANSACT_IOCTL_RSP *io = rsp_iov->iov_base;
 	bool unicode = !!(io->hdr.Flags2 & SMBFLG2_UNICODE);
 	u32 plen = le16_to_cpu(io->ByteCount);
-	int rc;
-
-	cifs_tcon_dbg(FYI, "%s: path=%s\n", __func__, full_path);
-
-	/* Check for unix extensions */
-	if (cap_unix(tcon->ses)) {
-		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, target_path,
-					     cifs_sb->local_nls,
-					     cifs_remap(cifs_sb));
-		if (rc == -EREMOTE)
-			rc = cifs_unix_dfs_readlink(xid, tcon, full_path,
-						    target_path,
-						    cifs_sb->local_nls);
-		return rc;
-	}
 
 	buf = (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
 					     le32_to_cpu(io->DataOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, unicode, target_path);
+	return parse_reparse_point(buf, plen, cifs_sb, unicode,
+				   &data->symlink_target);
 }
 
 static bool
@@ -1200,6 +1204,7 @@ struct smb_version_operations smb1_operations = {
 	.rename = CIFSSMBRename,
 	.create_hardlink = CIFSCreateHardLink,
 	.query_symlink = cifs_query_symlink,
+	.parse_reparse_point = cifs_parse_reparse_point,
 	.open = cifs_open_file,
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e9c8cff0b1d2..6a25b65c7b22 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2956,22 +2956,18 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	}
 }
 
-static int smb2_query_symlink(const unsigned int xid,
-			      struct cifs_tcon *tcon,
-			      struct cifs_sb_info *cifs_sb,
-			      const char *full_path,
-			      char **target_path,
-			      struct kvec *rsp_iov)
+static int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
+				    struct kvec *rsp_iov,
+				    struct cifs_open_info_data *data)
 {
 	struct reparse_data_buffer *buf;
 	struct smb2_ioctl_rsp *io = rsp_iov->iov_base;
 	u32 plen = le32_to_cpu(io->OutputCount);
 
-	cifs_tcon_dbg(FYI, "%s: path: %s\n", __func__, full_path);
-
 	buf = (struct reparse_data_buffer *)((u8 *)io +
 					     le32_to_cpu(io->OutputOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, true, target_path);
+	return parse_reparse_point(buf, plen, cifs_sb,
+				   true, &data->symlink_target);
 }
 
 static int smb2_query_reparse_point(const unsigned int xid,
@@ -5206,7 +5202,7 @@ struct smb_version_operations smb20_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
@@ -5308,7 +5304,7 @@ struct smb_version_operations smb21_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
@@ -5413,7 +5409,7 @@ struct smb_version_operations smb30_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
@@ -5527,7 +5523,7 @@ struct smb_version_operations smb311_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
-- 
2.42.1

