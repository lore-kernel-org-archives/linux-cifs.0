Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917336;
	b=5GJgZt8rR/ddPN3+0dZU2qQ8WJcE3f7eiXrJgtlubr3bBPEXAv/hchKnCqGN+cSH1d0F
	 By9oKPXo4L7kJRp4ByPdNbY3pW+jlMbXZ+zUE+w9xF5JuCSNQRauV6izbcwdp8M3owtqA
	 jjV0QxHTHmF5NhogMFNjFwAu/cuDzkw6DLP+GTiKdxnsAr9mtPxtDlU28xqgkdD7UfqN6
	 i1EmnkuYBDsgF2g6wZcn3n9520nN3ZaAfQFTQdLtT9a8Nv3rnP6hdFVyQ6+e64aGv0gj5
	 8pjZzI0PTf3mg+kj2VlzNmGXa7k321ibZpz6rZnP0xN7I0djs6WmRi488CDd0iRRWug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917336;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HgZYU/9hxL/oMHR7ce/0AWUdgqY3ew23fODZO9qhmOI=;
	b=tJ14P3DTMpwL8Xu1MTBQN8FWBKjwJjMHO7h6SFyUfq9rwPrn1sMuZP/+X+eFLgq85arU
	 fz7LgBznhZlssSY1Pru6zKaK2azdO3Zo3MD1F4jYnVKi5UfTBtMY33XeMvF+6nP3843DB
	 n6JZN7w3pFuyK8qwOP8cfCuumFlLSnD2JQCnL4hBNk+pr88tneAFsD8/1cKhuz2LtB/Cn
	 eq2SpX+T2Cx/nCYLnNbXeWLZy2lgZ7QWM4dETCVdIpgvhy4p1b9f26ji3Dlxbrs4rLw+t
	 N36dCyTiCig4D4xxJWFmqgjRfH7UFhUcHiMdXjIzFQaFPGkZDN2ffw9kfgxG4V6au5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=GQ6tJDKi;
	arc=none smtp.remote-ip=91.218.175.55
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC516606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC516606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=GQ6tJDKi
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lPcAWswdf0hqFTwXUec+4O5FaeZIS4BE692UHJEI1U8=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917333; v=1; x=1793522133;
 b=GQ6tJDKiflLQbJ7VNcses2uESSTJP+diEC91qo1Lq2GSSvD5jaiJ5Ix8GDLdzBXNm3G420Ke
 QRV5U7d3G7pNWB1+0Q7//LP48xvxn85ItHPqF7qeOJvBbiJC+ccKscdhRDyqXvC8IkxrP0kqkj3
 AxVX1rmBJ/dq92j3WnNEHeohzFl8a/LfF8euUpARBrinJtoSXssPVShtgzRTDPsB+7S+iUO/4TV
 vF8uFd+MuYjbNusD2+EgaPHSuMlWtAbgeQrdAMxh4Qj41CB9o83q42wZyUviYXwjX7r9nvSRAQ/
 AvChkCXNaDrKK40AiS6ctQXTokT8kNLV1rNss69rmDoKg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 245c5e8504ba5fd8;
	Sun, 25 Oct 2026 08:35:18 +0000
X-Mizu-Trace-ID: 245c5e8504ba5fd8
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 02/13] smb/server: add more validation for change notify requests
Date: Sun, 25 Oct 2026 08:34:39 +0000
Message-ID: <20261025083450.212604-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
References: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
index 7bf55ee633c3..a5a71c2efe5d 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -44,6 +44,7 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_rsp *rsp)
 {
 	struct ksmbd_file *fp;
+	int err;
 
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
 		pr_err("Notify request is not the last compound command\n");
@@ -61,7 +62,37 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
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

