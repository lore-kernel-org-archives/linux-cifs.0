Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232314307A8
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783528012; cv=none; b=ak4i1Zi0N71Gz1Xk5D0es0E35DdYy+ZWl4giuHZ/mIFjmQS2JtmvstxcVYauZywBzaWqIwdOdQKAagbVgejbX6cj9Nbo4IodCK5JiLvj9tGFBIiGwLhRK3WZKN0x/knsJceXqqV9CWOIcZzT/+0nVEpbdfyh7Gyt4u2R87cy7jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783528012; c=relaxed/simple;
	bh=EqzBKnvDJB3LmiI17p0uyFu3HMkeVKsXsqFjuQxkd6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFaFADl4BdotChM+78PIwjow8VzgFs41zcJv40r0jA+HGlC3eo0w07vqpTWY/9SZTPD62w6++whBSnNYVqMQzVrmspbNN5piDaAgZzFENGtbdhCpIi4oMPlBqpUWW1AXYI2qyNWW1VrFQGTEoNuwo0Myq/l7eoB/rHp3i6oQATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=jnkTDG7x; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="jnkTDG7x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783528005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvmrIc6Cp/uhWRYU9hjPXW0Rv9GIf3cH+rum9nWX38A=;
	b=jnkTDG7xM6ltO0bJbUC4XhkY2psZb+bH24XcpivvopYy+py7uEiHNrxg0Nl8+RBD4lui7w
	s8zEzUzLvFdqUXQukyPaOuwXZX8KUO8nkGaOoDjuGPEpczyft8Onyn8x5PNNozmz3WgOUU
	OH2h0QlytF45+/C2IdDN1bJDpGs58yzY8XIFBPcPvRe+BwScErvl4Jv8zeYT5MExlll8vu
	j5E8o12FCoH0RaYqFLFYcRsLRwg2zBsOnf2XekHYE7ff/ccE7BM3iE+338oiHPi3Jf54Hd
	daMkA2II2XIUl8Q3LitqtXYCoJaYjjFBI4KPz26UkefHGuGcgqhzgm5JxceiPA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 2/3] smb/client: pass cifs_open_info_data to SMB2_open()
Date: Wed,  8 Jul 2026 16:25:51 +0000
Message-ID: <20260708162552.209468-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
References: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Let SMB2_open() fill the smb2_file_all_info embedded in cifs_open_info_data
directly. This removes the temporary smb2_file_all_info copy in
smb2_open_file().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/link.c      |  6 +++---
 fs/smb/client/smb2file.c  | 19 ++++++++-----------
 fs/smb/client/smb2pdu.c   | 25 +++++++++++++------------
 fs/smb/client/smb2proto.h |  2 +-
 4 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 0014523d6511..b60dc407815d 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -320,7 +320,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info file_info = {};
+	struct cifs_open_info_data data = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -336,12 +336,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &data, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (data.fi.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 6860eff31693..5ef919bce52d 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -154,8 +154,6 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	__le16 *smb2_path;
 	__u8 smb2_oplock;
 	struct cifs_open_info_data *data = buf;
-	struct smb2_file_all_info file_info = {};
-	struct smb2_file_all_info *smb2_data = data ? &file_info : NULL;
 	struct kvec err_iov = {};
 	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_fid *fid = oparms->fid;
@@ -182,14 +180,14 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
-	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
-		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
 	if (rc && data) {
@@ -202,9 +200,9 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 							 oparms->path,
 							 &data->symlink_target);
 			if (!rc) {
-				memset(smb2_data, 0, sizeof(*smb2_data));
+				memset(&data->fi, 0, sizeof(data->fi));
 				oparms->create_options |= OPEN_REPARSE_POINT;
-				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data,
+				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data,
 					       NULL, NULL, NULL);
 				oparms->create_options &= ~OPEN_REPARSE_POINT;
 			}
@@ -238,23 +236,22 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		rc = 0;
 	}
 
-	if (smb2_data) {
+	if (data) {
 		/* if open response does not have IndexNumber field - get it */
-		if (smb2_data->IndexNumber == 0) {
+		if (data->fi.IndexNumber == 0) {
 			rc = SMB2_get_srv_num(xid, oparms->tcon,
 				      fid->persistent_fid,
 				      fid->volatile_fid,
-				      &smb2_data->IndexNumber);
+				      &data->fi.IndexNumber);
 			if (rc) {
 				/*
 				 * let get_inode_info disable server inode
 				 * numbers
 				 */
-				smb2_data->IndexNumber = 0;
+				data->fi.IndexNumber = 0;
 				rc = 0;
 			}
 		}
-		memcpy(&data->fi, smb2_data, sizeof(data->fi));
 	}
 
 	*oplock = smb2_oplock;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ec79acd328b4..5707d76a8647 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3287,7 +3287,7 @@ SMB2_open_free(struct smb_rqst *rqst)
 
 int
 SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
-	  __u8 *oplock, struct smb2_file_all_info *buf,
+	  __u8 *oplock, struct cifs_open_info_data *buf,
 	  struct create_posix_rsp *posix,
 	  struct kvec *err_iov, int *buftype)
 {
@@ -3302,6 +3302,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int rc = 0;
 	int flags = 0;
 	int retries = 0, cur_sleep = 0;
+	struct smb2_file_all_info *file_info = buf ? &buf->fi : NULL;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3370,21 +3371,21 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (buf) {
-		buf->CreationTime = rsp->CreationTime;
-		buf->LastAccessTime = rsp->LastAccessTime;
-		buf->LastWriteTime = rsp->LastWriteTime;
-		buf->ChangeTime = rsp->ChangeTime;
-		buf->AllocationSize = rsp->AllocationSize;
-		buf->EndOfFile = rsp->EndofFile;
-		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0; /* successful open = not delete pending */
+	if (file_info) {
+		file_info->CreationTime = rsp->CreationTime;
+		file_info->LastAccessTime = rsp->LastAccessTime;
+		file_info->LastWriteTime = rsp->LastWriteTime;
+		file_info->ChangeTime = rsp->ChangeTime;
+		file_info->AllocationSize = rsp->AllocationSize;
+		file_info->EndOfFile = rsp->EndofFile;
+		file_info->Attributes = rsp->FileAttributes;
+		file_info->NumberOfLinks = cpu_to_le32(1);
+		file_info->DeletePending = 0; /* successful open = not delete pending */
 	}
 
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
-				 oparms->fid->lease_key, oplock, buf, posix);
+				 oparms->fid->lease_key, oplock, file_info, posix);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 855d5c4637f0..11f22eea8900 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -139,7 +139,7 @@ int SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	      struct cifs_tcon *tcon, const struct nls_table *cp);
 int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
 int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
-	      __le16 *path, __u8 *oplock, struct smb2_file_all_info *buf,
+	      __le16 *path, __u8 *oplock, struct cifs_open_info_data *buf,
 	      struct create_posix_rsp *posix, struct kvec *err_iov,
 	      int *buftype);
 int SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
-- 
2.54.0

