Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE6431E7D
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990369; cv=none; b=lbelKxarm9H31Dir8JuJ7it5JZRhrz7NaOre8sFQlt9t6KAP38Mv9hFJHVJ/nvk+3l/ENp6MSrXerrn3nLyiIbuWYsDatQO/xk32lSJINsAxJ2z/Qydx1UXVF43au7SJUZ/w3EFN4UtEtNkRTo7f8nXBw7pJafLEebhaUSUGlEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990369; c=relaxed/simple;
	bh=oIGQ5ImdhGoWVTSdzSLAiqtr7oNMIml9av8IPruQAjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCts6sVllFTgR73Skv8DCmWSyjHrvzutAB90Ql3iekPYfEInb0TRkUTp/32zGima+Wb6AcJCG2a1GvMUAAKTv9lDVT6GX+9ZzhmmHSquZ8iKAlDtCc49jWQlm4l7Y2ug4yWxCB8w77uRj10T+/8/BJ57gYhaewhY9pH/9OgMVo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=W9ZvFH7o; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="W9ZvFH7o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782990364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lgOV/3jTOEqeLnR+sqHLR226r7ivfU02eYZdkbIgilc=;
	b=W9ZvFH7oPznBmPu0+lX7GyUnYz2KDMcCghxZJnCHO5wA+wZ8BbR287ThBdC0mHj722gi70
	nRaTY22WsqfujfyDOuBvouMKw8U4ARTcNPsUig7fRXBpBsrHram+kDiYAwa/FyZtoat3pt
	d6dzLpUDfKeGaVGYJFb2WrnngT751io2I/GqybCsKjb1lfrSsy6TRgXfaeC8Wg2rBfphVY
	P2bq/nnEYJ8+klvwUcPU/+TbT1DJKndfILlOt9xreexjMCDEaEDMbRzwe4Pwd9kKBSrhsf
	AN1SVA02zSM+NU0D8Ly0b5UVlEr1e/n0/lrxFrlmF7zlpKR2Gm4D/k2e98K69A==
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/2] smb/server: preserve compound prefix for async interim responses
Date: Thu,  2 Jul 2026 11:05:22 +0000
Message-ID: <20260702110522.911411-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
References: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Windows clients can issue a related compound request such as CREATE
followed by CHANGE_NOTIFY. ksmbd defers CHANGE_NOTIFY and sends
STATUS_PENDING through the async interim response path. That path only
built a response for the current command, so responses generated for
earlier commands in the compound chain were dropped.

This means the client never receives the CREATE response that contains
the file id used by the pending notify request. Windows Explorer can
then stall when navigating away from the directory until the connection
is torn down and the pending notify requests are cleaned up.

When sending STATUS_PENDING for an async command, copy the completed
compound response prefix before appending the async interim error
response. Final async completions such as STATUS_CANCELLED and
STATUS_NOTIFY_CLEANUP remain standalone async responses.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 43d0dacc7907..0a3997502732 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -847,7 +847,11 @@ void release_async_work(struct ksmbd_work *work)
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
+	struct smb2_err_rsp *err_rsp;
 	struct ksmbd_work *in_work = ksmbd_alloc_work_struct();
+	char *rsp_buf;
+	unsigned int compound_len = 0;
+	unsigned int msg_len;
 
 	if (!in_work)
 		return;
@@ -859,14 +863,40 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	}
 
 	in_work->conn = work->conn;
-	memcpy(smb_get_msg(in_work->response_buf), ksmbd_resp_buf_next(work),
-	       __SMB2_HEADER_STRUCTURE_SIZE);
+	rsp_buf = smb_get_msg(in_work->response_buf);
+
+	/*
+	 * STATUS_PENDING can complete the last command in a compound chain.
+	 * Preserve the completed prefix before appending the async interim
+	 * response so the client can consume every response in the chain.
+	 */
+	if (status == STATUS_PENDING)
+		compound_len = work->next_smb2_rsp_hdr_off;
+
+	msg_len = compound_len + SMB2_ERROR_RSP_LEN;
+	if (msg_len > MAX_CIFS_SMALL_BUFFER_SIZE) {
+		pr_err("compound interim response too large: %u\n", msg_len);
+		ksmbd_free_work_struct(in_work);
+		return;
+	}
+
+	if (compound_len) {
+		memcpy(rsp_buf, smb_get_msg(work->response_buf),
+		       compound_len);
+	}
+
+	rsp_hdr = (struct smb2_hdr *)(rsp_buf + compound_len);
+	memcpy(rsp_hdr, ksmbd_resp_buf_next(work), __SMB2_HEADER_STRUCTURE_SIZE);
 
-	rsp_hdr = smb_get_msg(in_work->response_buf);
 	rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
 	rsp_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
-	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
+	err_rsp = (struct smb2_err_rsp *)rsp_hdr;
+	smb2_init_err_rsp(err_rsp);
+	if (ksmbd_iov_pin_rsp(in_work, rsp_buf, msg_len)) {
+		ksmbd_free_work_struct(in_work);
+		return;
+	}
 
 	ksmbd_conn_write(in_work);
 	ksmbd_free_work_struct(in_work);
-- 
2.54.0

