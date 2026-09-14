Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1294D3BCD17
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789384552; cv=none; b=dfFsVW6GyxF08oj5HNWMsDntDh8er78WOV6NweYthUvZh/Zv+W14Zcv+84hji/fAdnfQvfLYUFBJY+IyDm+JLCGm/Olnl+jMayKw80IsOmkZJCz7tnH2Ns0RKgZiR5sYZ0VINpY1IMv/pRAbNPfeIe42efJzoQydEtqAMBBvA6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789384552; c=relaxed/simple;
	bh=S/f0i/UjGXHo9s7AVoD7WJ9Zv2jM9wMGt1IfbLJpn3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sLKZ1u9FuRGwtXKjgV+JsgsgXMf8yoc2cHMAR1HEEJTZWII7jL5OpGSbM46E1BwSmoEdLKMLENanwIhhYB5go6W6O6+bm7yPL4bNBXhtd1dICDR5Zo+51T4M2jlG5c+bgtqP3UwpAJyraDEVEYCgLp3J+3xBugIBKtHEPCX4TOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJj3LtUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJj3LtUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477EC1F00893;
	Mon, 14 Sep 2026 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384550;
	bh=F2kYnG+8BlfJ+bdKZfyrw98s1D4Ozlit8/0T9aiWqJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJj3LtUAIOvtP4Ch+x6kac4cD7PdYzRBVeP62DM9yxbIsCWs5r0UxJlEReb5Yt+iF
	 UtNX5wgKnSKp8Ty9rTSuT5VQeocXMQ9KRfXzVt8jJlKFRR5YtxO+AnmtjloGLnSpkD
	 WppP/s3y7RFqu9lpM9nzO0j2WpWmSNOTc7gDQPYRAYLi1QyuuXPQb0cOtmIoXsv1Zr
	 ouOAIAawNB+A8EpatINMu4ifCcnY81amGhrNVMQr7oSem/H8tkV5KRBTB/NAVjCzZO
	 lqSJyhfwiVYCNQeUOooKQp1nHEgtSXLEFBBjZr96BTlSeHnDdBpZKPF2R9K3XBzBoa
	 /SMDreNf+T8xw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Mobin Aydinfar <mobin@mobintestserver.ir>
Subject: [PATCH v2] ksmbd: keep compound responses on query info errors
Date: Mon, 14 Sep 2026 20:15:43 +0900
Message-Id: <20260914111543.12381-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260914111543.12381-1-linkinjeon@kernel.org>
References: <20260914111543.12381-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not reset the RFC1002 length of the complete response when a query
info buffer is too small. The current command will add its error response
through ksmbd_iov_pin_rsp(), while resetting the base length can truncate
earlier responses in a compound request.

This lets ksmbd return the earlier responses and the query-info error
response together. Remove the now-unused rsp_org parameter from the pipe
query-info helpers.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0436b7c898b1..6b8809f67b92 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6275,21 +6275,18 @@ int smb2_query_dir(struct ksmbd_work *work)
  * @reqOutputBufferLength:	max buffer length expected in command response
  * @fixed_len:			minimum fixed response length
  * @rsp:		query info response buffer contains output buffer length
- * @rsp_org:		base response buffer pointer in case of chained response
  *
  * Return:	0 on success, otherwise error
  */
 static int buffer_check_err(int reqOutputBufferLength,
 			    unsigned int fixed_len,
-			    struct smb2_query_info_rsp *rsp,
-			    void *rsp_org)
+			    struct smb2_query_info_rsp *rsp)
 {
 	unsigned int output_len = le32_to_cpu(rsp->OutputBufferLength);
 
 	if (reqOutputBufferLength < fixed_len) {
 		pr_err("Invalid Buffer Size Requested\n");
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
-		*(__be32 *)rsp_org = cpu_to_be32(sizeof(struct smb2_hdr));
 		return -EINVAL;
 	}
 
@@ -6300,8 +6297,7 @@ static int buffer_check_err(int reqOutputBufferLength,
 	return 0;
 }
 
-static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
-				   void *rsp_org)
+static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp)
 {
 	struct smb2_file_standard_info *sinfo;
 
@@ -6316,8 +6312,7 @@ static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
 }
 
-static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
-				   void *rsp_org)
+static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num)
 {
 	struct smb2_file_internal_info *file_info;
 
@@ -6331,8 +6326,7 @@ static void get_internal_info_pipe(struct smb2_query_info_rsp *rsp, u64 num,
 
 static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 				   struct smb2_query_info_req *req,
-				   struct smb2_query_info_rsp *rsp,
-				   void *rsp_org)
+				   struct smb2_query_info_rsp *rsp)
 {
 	u64 id;
 	int rc;
@@ -6357,16 +6351,16 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 
 	switch (req->FileInfoClass) {
 	case FILE_STANDARD_INFORMATION:
-		get_standard_info_pipe(rsp, rsp_org);
+		get_standard_info_pipe(rsp);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      le32_to_cpu(rsp->OutputBufferLength),
-				      rsp, rsp_org);
+				      rsp);
 		break;
 	case FILE_INTERNAL_INFORMATION:
-		get_internal_info_pipe(rsp, id, rsp_org);
+		get_internal_info_pipe(rsp, id);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      le32_to_cpu(rsp->OutputBufferLength),
-				      rsp, rsp_org);
+				      rsp);
 		break;
 	default:
 		ksmbd_debug(SMB, "smb2_info_file_pipe for %u not supported\n",
@@ -7202,8 +7196,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
 		/* smb2 info file called for pipe */
-		rc = smb2_get_info_file_pipe(work->sess, req, rsp,
-					       work->response_buf);
+		rc = smb2_get_info_file_pipe(work->sess, req, rsp);
 		goto iov_pin_out;
 	}
 
@@ -7321,7 +7314,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		}
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      fixed_len,
-				      rsp, work->response_buf);
+				      rsp);
 	}
 	ksmbd_fd_put(work, fp);
 
@@ -7592,7 +7585,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      fixed_len,
-			      rsp, work->response_buf);
+			      rsp);
 	path_put(&path);
 
 	if (!rc)
@@ -7706,7 +7699,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      le32_to_cpu(rsp->OutputBufferLength),
-			      rsp, work->response_buf);
+			      rsp);
 	if (rc)
 		goto err_out;
 
-- 
2.25.1

