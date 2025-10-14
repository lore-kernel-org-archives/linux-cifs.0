Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F830E0F6
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426500; cv=none; b=Q+XE7Jn7onIIUHn2OkHC+8YyvX6BXJBwJJqnvPXDRERCyj7qSURAXG/RykEzeQgqoRtlm3exFw9TsEyeXnL0Wk0mTPJlDT/ckN6j8xc8D0pLTjiPVfkoQT64aBgcoIirz+cR+NaZiz/IgDc4SlHlxYe1cYFlhB6wGzLqAa/nKrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426500; c=relaxed/simple;
	bh=fUKthNy2wlDGAqzuUnZdkSIU7ZaaNp3xh67aJrzdFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpP1s3Xx9yfqX2BX5xrERGNbWBTrEiLx/jtnE9vMpupcMtI/rDi4RpPPOfPbis0aekI61UcbUckNbullOrE1TI/u8i6dBPDxiKfuANsm/SLhLN7A6ZTNfF8/aOXO+9WIXjSnPwOa8a1C9Cv2lhzZGqdL/S+bYnK6HXw/aKGzg9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G1bdu9qH; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G1bdu9qH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BopO87yNeGrc851BB+HELrNNKYNXy/R/2W5NlpGz3KE=;
	b=G1bdu9qHSjgespG9nITUpXDWiWEwOeYw5CUwdSKoU2s0lpJFq9PdLweQp/TU5Kn4Fwxf/V
	8BuI2mBklTWLi5Tb0cz3fSzjf20abY3IyXy/7WbG3U3RFTkwTscgPdMhJmWzQOYlADPC0z
	AqTkzr85X/HHp9Fn1eFNaph8uhINUI4=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 10/22] smb: move resume_key_ioctl_rsp to common/smb2pdu.h
Date: Tue, 14 Oct 2025 15:19:05 +0800
Message-ID: <20251014071917.3004573-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename 2 places:

  - resume_key_req -> resume_key_ioctl_rsp
  - server: ResumeKey -> ResumeKeyU64

Merge the struct members of the server and the client, then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/smb2ops.c |  4 ++--
 fs/smb/client/smb2pdu.h |  6 ------
 fs/smb/common/smb2pdu.h | 10 ++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h |  6 ------
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ea9709d81851..8da5fe4efa2d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1528,7 +1528,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	unsigned int ret_data_len;
-	struct resume_key_req *res_key;
+	struct resume_key_ioctl_rsp *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
 			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
@@ -1541,7 +1541,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
 		goto req_res_key_exit;
 	}
-	if (ret_data_len < sizeof(struct resume_key_req)) {
+	if (ret_data_len < sizeof(struct resume_key_ioctl_rsp)) {
 		cifs_tcon_dbg(VFS, "Invalid refcopy resume key length\n");
 		rc = -EINVAL;
 		goto req_res_key_exit;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 9b5880e60a4e..77dceca20240 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -191,12 +191,6 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-struct resume_key_req {
-	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32	ContextLength;	/* MBZ */
-	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
 /* See MS-FSCC 2.3.29 and 2.3.30 */
 struct get_retrieval_pointer_count_req {
 	__le64 StartingVcn; /* virtual cluster number (signed) */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 857e6a577e84..15932ee05c98 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1421,6 +1421,16 @@ struct copychunk_ioctl_rsp {
 	__le32 TotalBytesWritten;
 } __packed;
 
+/* See MS-SMB2 2.2.32.3 */
+struct resume_key_ioctl_rsp {
+	union {
+		char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
+		__u64 ResumeKeyU64[3];
+	};
+	__le32	ContextLength;	/* MBZ */
+	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
+} __packed;
+
 struct smb2_ioctl_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 846cca45195b..200bce13b467 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8115,8 +8115,8 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
 		return -ENOENT;
 
 	memset(key_rsp, 0, sizeof(*key_rsp));
-	key_rsp->ResumeKey[0] = req->VolatileFileId;
-	key_rsp->ResumeKey[1] = req->PersistentFileId;
+	key_rsp->ResumeKeyU64[0] = req->VolatileFileId;
+	key_rsp->ResumeKeyU64[1] = req->PersistentFileId;
 	ksmbd_fd_put(work, fp);
 
 	return 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index eecd1f1f5505..3d000c5d964b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -151,12 +151,6 @@ struct file_object_buf_type1_ioctl_rsp {
 	__u8 DomainId[16];
 } __packed;
 
-struct resume_key_ioctl_rsp {
-	__u64 ResumeKey[3];
-	__le32 ContextLength;
-	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
 struct file_sparse {
 	__u8	SetSparse;
 } __packed;
-- 
2.43.0

