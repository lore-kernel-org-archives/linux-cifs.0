Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87263E5EE7
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 11:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789299367; cv=none; b=oYhlEgFdJlZ2SdcNG5tEFaeZ082K/7tuN46fM1ncOWbQw3uPDeqeSfTgO5tqOdhWslVsJPGMkhEAXAgXd1nktoiEqTRAdhIJyhQ7NTc38Hau9iEIg/6GiHxR2giCp5q8D/fkIQPgxQD5TykwltFIr2dS1ELVaPurWF9GrUnuqBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789299367; c=relaxed/simple;
	bh=1A4R5meFnAJXf5LoKxJKoOL4eMrMT6ynepj72AJIE28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HWYT61KOtDnFzBTT/O5WW40NUQ5xzGK9j3C45EWzVFjWs/5tLup8v/9g0H9fyJuAlWzCwmspQKsdaP/5zKUxfm56Zvlm932Ps3bUQymRP7IN9axAqzbFRtP16N3bAocr8N79WqnP5DyJi1g5rOnEItuUOiVCrXdXLrxT/cWWiJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPFY3r9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPFY3r9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738DA1F000FF;
	Sun, 13 Sep 2026 11:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789299364;
	bh=M7TZ00Gp+7CD+rT8aKLR5brZA0MI11ZVT0oo2dqeaU0=;
	h=From:To:Cc:Subject:Date;
	b=HPFY3r9VxmUXa70axa0t7tp3PiGSOdNmmBdIiY4IIqjrx7Pj4qA/+kb2H+6ExBbKA
	 mM3GkuESIYW4+7HZCUeSx+tmpvE3sHY19qMYWEoUyBK43CvG7Nci0wulgkITpZ+eLE
	 8l6XMkxOU48zKCbALR3jmmXNTe/nzGWN+kzNR7rVgYWhzcrnGW5YJ9FyArn5QtJWQg
	 2yhi8S4tFjxCXYiK7TwpAw7/A8Kv6uyeUUCcqPYinn+YXbuIJsC4vXin7G1x8ROWOS
	 Vt60SxTL8awdCTTciiWyXQwVX+2jrUD3klSKE/g0IV9WGKVKdBKM8L/YN7c1sHSTuk
	 wRJiv8jL/1img==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Mobin Aydinfar <mobin@mobintestserver.ir>
Subject: [PATCH 3/3] ksmbd: keep compound responses on query info errors
Date: Sun, 13 Sep 2026 20:36:00 +0900
Message-Id: <20260913113600.11540-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
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
response together.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 38cddbf3e6ed..3d4a8057a8af 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6277,21 +6277,18 @@ int smb2_query_dir(struct ksmbd_work *work)
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
 
@@ -6363,13 +6360,13 @@ static int smb2_get_info_file_pipe(struct ksmbd_session *sess,
 		get_standard_info_pipe(rsp, rsp_org);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      le32_to_cpu(rsp->OutputBufferLength),
-				      rsp, rsp_org);
+				      rsp);
 		break;
 	case FILE_INTERNAL_INFORMATION:
 		get_internal_info_pipe(rsp, id, rsp_org);
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      le32_to_cpu(rsp->OutputBufferLength),
-				      rsp, rsp_org);
+				      rsp);
 		break;
 	default:
 		ksmbd_debug(SMB, "smb2_info_file_pipe for %u not supported\n",
@@ -7327,7 +7324,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		}
 		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 				      fixed_len,
-				      rsp, work->response_buf);
+				      rsp);
 	}
 	ksmbd_fd_put(work, fp);
 
@@ -7598,7 +7595,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      fixed_len,
-			      rsp, work->response_buf);
+			      rsp);
 	path_put(&path);
 
 	if (!rc)
@@ -7712,7 +7709,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	rsp->OutputBufferLength = cpu_to_le32(secdesclen);
 	rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
 			      le32_to_cpu(rsp->OutputBufferLength),
-			      rsp, work->response_buf);
+			      rsp);
 	if (rc)
 		goto err_out;
 
-- 
2.25.1

