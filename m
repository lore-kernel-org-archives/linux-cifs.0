Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C059175D5F;
	Thu, 22 Aug 2024 08:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315027; cv=none; b=n+pjtSZYisCQ7+a3CSF2VzKsQqh1MY1nK/ck3ubrZkANKHrP/Bj+FxKYD6vCmbVjSl84X8l3729iGAFoIMQ1pfWmL2Rt+OFOzjb8+QzqpFhC0oJPuvALL/8iIuOtUABU5NixgZx5jVqfi3T0ZcdD8rNED6mU8Dbhm6QcNU6FxKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315027; c=relaxed/simple;
	bh=B4r809MJzzxLix81dlTD30go0lSL6FGSPAn6aiK3vyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VICH0xgE9dN8BdJGY/77kb4oX14CHKWMLBI+wtjdI5+QMmhZRj34JYNGaB6iVK79p3vKRw8lgrCRAz4SzAgKKMO+ukWpCRHoa0sQwKRHcjVVZHqcjPog7L0PuGq85GNtNNkOGb6cT7jY0UBnXqkta29AAE8hn1+aPLr0jpdUivo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314919tzv7pevg
X-QQ-Originating-IP: A8jhjxsq+9D9VKPcj91wRGhzXlP6aHQ2LLmIAB19yw4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:21:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13919036902503210924
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
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 02/12] smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
Date: Thu, 22 Aug 2024 08:20:51 +0000
Message-Id: <20240822082101.391272-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

null-ptr-deref will occur when (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
and parse_lease_state() return NULL.

Fix this by check if 'lease_ctx_info' is NULL.

Additionally, remove the redundant parentheses in
parse_durable_handle_context().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/oplock.c  |  2 +-
 fs/smb/server/smb2pdu.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a8f52c4ebbda..e546ffa57b55 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1510,7 +1510,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
  * parse_lease_state() - parse lease context containted in file open request
  * @open_req:	buffer containing smb2 file open(create) request
  *
- * Return:  oplock state, -ENOENT if create lease context not found
+ * Return: allocated lease context object on success, otherwise NULL
  */
 struct lease_ctx_info *parse_lease_state(void *open_req)
 {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d8a827e0dced..154bc27d1db8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2767,8 +2767,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				}
 			}
 
-			if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-			     req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
+			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
+			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				dh_info->CreateGuid =
 					durable_v2_blob->CreateGuid;
 				dh_info->persistent =
@@ -2788,8 +2788,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-			     req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
+			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
+			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				ksmbd_debug(SMB, "Request for durable open\n");
 				dh_info->type = dh_idx;
 			}
@@ -3411,7 +3411,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
-		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			if (S_ISDIR(file_inode(filp)->i_mode)) {
 				lc->req_state &= ~SMB2_LEASE_WRITE_CACHING_LE;
 				lc->is_dir = true;
-- 
2.34.1

