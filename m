Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="N0BlQ/4M"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2090B128
	for <linux-cifs@vger.kernel.org>; Sun, 19 Nov 2023 13:45:19 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700430317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CjiSIC+FhuxQFAEFER/xZDAF15NrcTUkWUy8+8MMaA0=;
	b=N0BlQ/4MA6uc8NIcJIIkN6H7LMglvcQ55Vb63EA68JN8pbFGv04Kn/ilO/kkljxb2aI51C
	6ElDGNo9xM51SZevA3tZ098DmzJO7t0tIfJAmJrDa2M4cd4vGSKLASopd+TUm/ds3BDdlt
	3pDHEF6/qBE2rqiaB/YQZ4Om8IIcPklXx88KaqeGbFsOYMAeb8gzf8qim3oHqiFKbXyU1V
	jpUwJ0f/pMn3APZ9Zfszv4UfQTs2DEz+jK6KKoCJs6T8+4JdsGq71SCysC4sS2tYF20xJ8
	xWAu4fIgMzv2bz96Xsnqul6wNTHe3o6K7sCE6lBLXD7gvy1Fe2SUn4qSwE+Qpg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700430317; a=rsa-sha256;
	cv=none;
	b=JR1R29eJBf8thEasQCPorSQO91q9liKWxeeO+cmspnq85ytoflLPOtm4WLqDx7DAdS1yaH
	p3U9ebizIxncsBrYoAu2PYogFsFYJgKcyT/WfV0Ch3uxdICIR/5um71qpFxSrtR7R3rKFb
	WyysAkOHH5UlqttUk4Gkd588Rx+zIHt4Cvu6sqKHCuO0be5/hFy1V7K9FLG0oEXbgBVUXI
	um4W81z6RfoBzoG16d/A7TxeqoaLaBcHRhsQXbBtH3siL9VvcZRdWtpiMVTJ5Fa95IVyus
	l6QIQCi/l8DJfIRx3cKHGDDNIbvaa9I8dNcfYADzv5c0bo1hPkINRgto4DuhaA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700430317; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CjiSIC+FhuxQFAEFER/xZDAF15NrcTUkWUy8+8MMaA0=;
	b=DurU+TFPNeZAXqGo51SscfcjSjg+ONQuWnp0alGYW0wUbFHpc+kbqTKywPmNyvGIL8b1rZ
	dDfUGJcjZ0NiaM3RMbIuL5u6wfZR0JgBA9ZeTcb0ydCHJoGjBSOMV2wT87SNJ4ExGDFSJ5
	nWlYbLuroP4TB8xqdie60cP1xZXD1/Qnj8hFdFYWp1W+FWumWi9kG4GR3JkFEP1r7dj01u
	OKsRQvk52XENrxZWcALHRK+was/LVP0WCHcqowfgCT0FeFtDvNMGhUXtD6Csk2xtdvWGEy
	46k1N7o/C7Tzfw5FgSe32l+lptFa5Qdar+8xAFzQx4n4nBCTgTlZb2ynmoKXtA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 2/3] smb: client: introduce ->parse_reparse_point()
Date: Sun, 19 Nov 2023 18:44:49 -0300
Message-ID: <20231119214450.23779-2-pc@manguebit.com>
In-Reply-To: <20231119214450.23779-1-pc@manguebit.com>
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231119214450.23779-1-pc@manguebit.com>
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
v1 -> v2: add missing WSL reparse point check in parse_reparse_point()
to avoid returning -EOPNOTSUPP on them.  Reported by Steve.

 fs/smb/client/cifsglob.h |  6 ++++--
 fs/smb/client/inode.c    | 23 +++++++++++++---------
 fs/smb/client/smb1ops.c  | 41 ++++++++++++++++++++++------------------
 fs/smb/client/smb2ops.c  | 28 ++++++++++++++-------------
 4 files changed, 56 insertions(+), 42 deletions(-)

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
index e9c8cff0b1d2..2955eaa51d4d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2949,6 +2949,12 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 		return parse_reparse_symlink(
 			(struct reparse_symlink_data_buffer *)buf,
 			plen, unicode, target_path, cifs_sb);
+	case IO_REPARSE_TAG_LX_SYMLINK:
+	case IO_REPARSE_TAG_AF_UNIX:
+	case IO_REPARSE_TAG_LX_FIFO:
+	case IO_REPARSE_TAG_LX_CHR:
+	case IO_REPARSE_TAG_LX_BLK:
+		return 0;
 	default:
 		cifs_dbg(VFS, "srv returned unknown symlink buffer tag:0x%08x\n",
 			 le32_to_cpu(buf->ReparseTag));
@@ -2956,22 +2962,18 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
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
@@ -5206,7 +5208,7 @@ struct smb_version_operations smb20_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
@@ -5308,7 +5310,7 @@ struct smb_version_operations smb21_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
@@ -5413,7 +5415,7 @@ struct smb_version_operations smb30_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.query_symlink = smb2_query_symlink,
+	.parse_reparse_point = smb2_parse_reparse_point,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.open = smb2_open_file,
@@ -5527,7 +5529,7 @@ struct smb_version_operations smb311_operations = {
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

