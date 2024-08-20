Received: from bg5.exmail.qq.com (bg5.exmail.qq.com [43.154.197.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054541922D5;
	Tue, 20 Aug 2024 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.197.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164629; cv=none; b=ZeYGFRjbxjIfdPw9+vbqBL/eS3FDUb5qbWYcHfHFx6PnHQGQxI4neghRv3eRwvo1YlqiJQ19IhNzFuTj6TwObGTtZqf2WocHtDwZpYR1cXpFfn8u7jHUezuvO34XXeL0wrmP4w/zlnIVpD/9p1YFbTC4E7fnxmeE1kjUeQDEGxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164629; c=relaxed/simple;
	bh=UaTjhsrSU+4YcXulYJz5XJIUWIlRgRVTchGO6dZPxq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KkqHnPGt/tMFxgbiQD+LAdb3quNSTJztSj8tag3gEi+QOMYvdMcdMlRQGJa9YNkQXScJ6Mg1xUg0D5mv04elZphYAL1h3TXIkQzN+C1r6bZSAkc1VEg8dHAt518w+euXjEkchgw+BHXGrVp/q6wZw7MgqUko4cyTn+Vv1jNR55A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.197.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz13t1724164443tqg9yz
X-QQ-Originating-IP: dPMKYDXMOjPLOaW4z1aia1MK4dITPS1tmcXpU+Dbrig=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 20 Aug 2024 22:33:58 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17776703071977044454
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH 2/8] smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
Date: Tue, 20 Aug 2024 14:33:13 +0000
Message-Id: <20240820143319.274033-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

null-ptr-deref will occur when (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
and parse_lease_state() return NULL.

Fix this by returning error pointer on parse_lease_state() and checking
error.

Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
---
 fs/smb/server/oplock.c  | 11 +++++++----
 fs/smb/server/smb2pdu.c | 17 ++++++++++++-----
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a8f52c4ebbda..e8591686a037 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1510,7 +1510,8 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
  * parse_lease_state() - parse lease context containted in file open request
  * @open_req:	buffer containing smb2 file open(create) request
  *
- * Return:  oplock state, -ENOENT if create lease context not found
+ * Return: allocated lease context object on success, otherwise error pointer.
+ * 	   -ENOENT pointer if create lease context not found.
  */
 struct lease_ctx_info *parse_lease_state(void *open_req)
 {
@@ -1519,12 +1520,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 	struct lease_ctx_info *lreq;
 
 	cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
-	if (IS_ERR_OR_NULL(cc))
-		return NULL;
+	if (!cc)
+		return ERR_PTR(-ENOENT);
+	if (IS_ERR(cc))
+		return ERR_CAST(cc);
 
 	lreq = kzalloc(sizeof(struct lease_ctx_info), GFP_KERNEL);
 	if (!lreq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d8a827e0dced..119c1ba5f255 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2767,8 +2767,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				}
 			}
 
-			if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-			     req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
+			if ((!IS_ERR_OR_NULL(lc) > 0 &&
+			     (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
+			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				dh_info->CreateGuid =
 					durable_v2_blob->CreateGuid;
 				dh_info->persistent =
@@ -2788,8 +2789,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-			     req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
+			if ((!IS_ERR_OR_NULL(lc) &&
+			     (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
+			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				ksmbd_debug(SMB, "Request for durable open\n");
 				dh_info->type = dh_idx;
 			}
@@ -2935,8 +2937,13 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_put_durable_fd(fp);
 			goto reconnected_fp;
 		}
-	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
+	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
 		lc = parse_lease_state(req);
+		if (IS_ERR(lc)) {
+			rc = PTR_ERR(lc);
+			goto err_out2;
+		}
+	}
 
 	if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
 		pr_err("Invalid impersonationlevel : 0x%x\n",
-- 
2.34.1

