Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6703A1D01
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413580; cv=none; b=tw6MB27UbWTepAVVuApGXvyJnTbEjYJaODikfpi82fSwx9JqaRDQdgrlR+syAX/HNmaE6Qp7Ai5vXB8ZOtmwGSMDFbaTiqAToOuMbBSA8glvU4iNnLliLpTjOklabkMSAPClPapYU2dUXgITseKY3fNhxrDiEtt/q4gufwPs/nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413580; c=relaxed/simple;
	bh=y8hT3w54qb3F+QBal07lzHv5Z3cDmRUReKcZiW0nUG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ok2vSg7dj4MXuTpYbcmNHj4PvHISI/QE4Y0vlwxJSw2f/IGWY+atP08U2TWFpReEjklXN/IBXO+DCvBH6nRHBKYP952g/oAyWfgXbWloa+aQZpb4Km3scLnPpcbcvpvWYRG88antNkdUhiqvJkM4Tfyi3+8OgpfyeqGabIQQZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=MmoCbTdN; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="MmoCbTdN"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=y8hT3w54qb3F+QBal07lzHv5Z3cDmRUReKcZiW0nUG8=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413575; v=1; x=1791018375;
 b=MmoCbTdNAvDL/9WBxRVmrsx6r3DwRYAMDz2wRPS/hqztvpof3XFwqXoxB1M+KS8ICLFXqerg
 /mO12TtMC5CKKtRcjMFlE3cXV1xBcCGhWoKMQnwaBECoSu4d5f1NIhdfBMQiOusiVDURLnWwqwY
 4bILLwT3lSQFcmI+6zhv8HevdxyV4t66cG0GbCPPwgmlJizyBjWFBtdI4Kf6a2YeAh/NqeADs8J
 L9V6V7xtNcFnSxTCOQ+NXdjvrKrqOmEdu1aYoQdquQ68rxiLTtMWffTSxd6BWdpY295rShnjC5f
 johFld2zntwWG111VL+ImHFIjwkCw88GS/zCeK8CVIoZQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 20db26fc6fa49bd3;
	Sat, 26 Sep 2026 09:06:13 +0000
X-Mizu-Trace-ID: 20db26fc6fa49bd3
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 02/12] smb/server: add more validation for change notify requests
Date: Sat, 26 Sep 2026 09:05:08 +0000
Message-ID: <20260926090518.78547-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add validation for the file type, directory list access and output
buffer length before setting up a change notify watch.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 7e324af36b47..18cf0005a037 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -48,6 +48,7 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_rsp *rsp)
 {
 	struct ksmbd_file *fp;
+	int err;
 
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
 		pr_err("Notify request is not the last compound command\n");
@@ -65,7 +66,37 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 		return ERR_PTR(-ENOENT);
 	}
 
+	if (le32_to_cpu(req->OutputBufferLength) >
+	    work->conn->vals->max_trans_size) {
+		pr_err("Notify output buffer length %u exceeds maximum %u\n",
+		       le32_to_cpu(req->OutputBufferLength),
+		       work->conn->vals->max_trans_size);
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		err = -EINVAL;
+		goto err_put_fp;
+	}
+
+	if (!S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		pr_err("Notify file id is not a directory, fid %llu:%llu\n",
+		       fp->persistent_id, fp->volatile_id);
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		err = -EINVAL;
+		goto err_put_fp;
+	}
+
+	if (!(fp->daccess & FILE_LIST_DIRECTORY_LE)) {
+		pr_err("No permission to monitor directory, fid %llu:%llu\n",
+		       fp->persistent_id, fp->volatile_id);
+		rsp->hdr.Status = STATUS_ACCESS_DENIED;
+		err = -EACCES;
+		goto err_put_fp;
+	}
+
 	return fp;
+
+err_put_fp:
+	ksmbd_fd_put(work, fp);
+	return ERR_PTR(err);
 }
 
 static int ksmbd_notify_wait(struct ksmbd_work *work,
-- 
2.55.0

