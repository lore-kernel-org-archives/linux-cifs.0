Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125CE2609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792297; cv=none; b=VHY60UOQ4QvmxgtBFtpMHx5MGAbGCXXphnU5ZN0tKB6s/oyKGpVJEG3QNlkLb8T/skWpfavaWl5j15WdArJO12XDHs9V7aBBXuF3rvTTSPHBd40OXNksYo49/vJ21CnvT2ozCP+5y1M0ie2MGlISs0zZPstkuvA2XaNLvM6y1vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792297; c=relaxed/simple;
	bh=2aN3faIBm5MuVGgcXdGwCXHqQDg1gAp5H04B9z9afQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=shrPmaf34OLlinC6Qg/NH7PGqpGzbTWZtAifs0h4S3ySQInW8VdfgND4aoBMIFtl93Bp92lS4pO7wbojvAP348UabmoaO6Z4XZvuR2Ro2jChrhRTKZkE/r4aJAmn/Zga+lspc94rVtxjaZgpdBpN74lYGPCU97JMzleGbf/xyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D72mNQrn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D72mNQrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4081F000E9;
	Thu, 18 Jun 2026 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792295;
	bh=N5wYmBALR4wb7u4vvtsbp7D4dfOLQ9M8108F6XwgxcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D72mNQrnyoRmR43R1Zq2aNoYsH/Z771+n7JxbBeJXRl9gpwCDkWwO48aN06BO4c62
	 jwKkBsKjPTT/8ZJDnNDQVYX8WYWoTn+uVaYVEEVilvI9RPeCi2qs4KgWG1jkRFimqr
	 u/sv1oBT2/GP6dCekl/Wt8hrcEuTR9yIp8sMfLcwjgLuIUGTiVEqNxV6T65rmxOMlb
	 VIaqgeKc5P3skUzObsA0OAFpis2//HpdxZHbqw23DY7GYX4yjqPVarm/HstXeOAIrX
	 kUHeyFzc3IB+6kdaCVkGOBExYt3RvLxwPsfUuFQKG4vJ5l0eA3S2SDV3ASNoSl8yTZ
	 rbKqjMSUW4EnA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 14/14] ksmbd: keep common response iovecs in the work item
Date: Thu, 18 Jun 2026 23:17:39 +0900
Message-Id: <20260618141739.9029-14-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260618141739.9029-1-linkinjeon@kernel.org>
References: <20260618141739.9029-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most SMB responses need no more than four kvec entries, but every work
item currently allocates a separate four-entry array and frees it after
the response is sent.

Embed the common array in struct ksmbd_work and allocate a larger array
only when a response exceeds the inline capacity. This removes one
allocation and one free from the common request path while preserving
support for larger compound and read responses.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 58 ++++++++++++++++++++++++--------------
 fs/smb/server/ksmbd_work.h |  3 ++
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index a5ab6799a65c..e2c2f45264be 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -16,6 +16,36 @@
 static struct kmem_cache *work_cache;
 static struct workqueue_struct *ksmbd_wq;
 
+static int ksmbd_reserve_iov(struct ksmbd_work *work, int need_iov_cnt)
+{
+	struct kvec *new;
+	int new_alloc_cnt = work->iov_alloc_cnt;
+
+	if (work->iov_alloc_cnt >= work->iov_cnt + need_iov_cnt)
+		return 0;
+
+	do {
+		new_alloc_cnt += KSMBD_WORK_INLINE_IOVS;
+	} while (new_alloc_cnt < work->iov_cnt + need_iov_cnt);
+
+	if (work->iov == work->iov_inline) {
+		new = kcalloc(new_alloc_cnt, sizeof(*new), KSMBD_DEFAULT_GFP);
+		if (!new)
+			return -ENOMEM;
+
+		memcpy(new, work->iov_inline, sizeof(work->iov_inline));
+	} else {
+		new = krealloc(work->iov, sizeof(*new) * new_alloc_cnt,
+			       KSMBD_DEFAULT_GFP | __GFP_ZERO);
+		if (!new)
+			return -ENOMEM;
+	}
+
+	work->iov = new;
+	work->iov_alloc_cnt = new_alloc_cnt;
+	return 0;
+}
+
 struct ksmbd_work *ksmbd_alloc_work_struct(void)
 {
 	struct ksmbd_work *work = kmem_cache_zalloc(work_cache, KSMBD_DEFAULT_GFP);
@@ -27,13 +57,8 @@ struct ksmbd_work *ksmbd_alloc_work_struct(void)
 		INIT_LIST_HEAD(&work->async_request_entry);
 		INIT_LIST_HEAD(&work->fp_entry);
 		INIT_LIST_HEAD(&work->aux_read_list);
-		work->iov_alloc_cnt = 4;
-		work->iov = kzalloc_objs(struct kvec, work->iov_alloc_cnt,
-					 KSMBD_DEFAULT_GFP);
-		if (!work->iov) {
-			kmem_cache_free(work_cache, work);
-			work = NULL;
-		}
+		work->iov_alloc_cnt = ARRAY_SIZE(work->iov_inline);
+		work->iov = work->iov_inline;
 	}
 	return work;
 }
@@ -55,7 +80,8 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	kfree(work->tr_buf);
 	kvfree(work->compress_buf);
 	kvfree(work->request_buf);
-	kfree(work->iov);
+	if (work->iov != work->iov_inline)
+		kfree(work->iov);
 
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
@@ -117,19 +143,9 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 			return -ENOMEM;
 	}
 
-	if (work->iov_alloc_cnt < work->iov_cnt + need_iov_cnt) {
-		struct kvec *new;
-
-		work->iov_alloc_cnt += 4;
-		new = krealloc(work->iov,
-			       sizeof(struct kvec) * work->iov_alloc_cnt,
-			       KSMBD_DEFAULT_GFP | __GFP_ZERO);
-		if (!new) {
-			kfree(ar);
-			work->iov_alloc_cnt -= 4;
-			return -ENOMEM;
-		}
-		work->iov = new;
+	if (ksmbd_reserve_iov(work, need_iov_cnt)) {
+		kfree(ar);
+		return -ENOMEM;
 	}
 
 	/* Plus rfc_length size on first iov */
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 0da8cc0972d6..5368430561fb 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -13,6 +13,8 @@ struct ksmbd_conn;
 struct ksmbd_session;
 struct ksmbd_tree_connect;
 
+#define KSMBD_WORK_INLINE_IOVS	4
+
 enum {
 	KSMBD_WORK_ACTIVE = 0,
 	KSMBD_WORK_CANCELLED,
@@ -42,6 +44,7 @@ struct ksmbd_work {
 	int				iov_alloc_cnt;
 	int				iov_cnt;
 	int				iov_idx;
+	struct kvec			iov_inline[KSMBD_WORK_INLINE_IOVS];
 
 	/* Next cmd hdr in compound req buf*/
 	int                             next_smb2_rcv_hdr_off;
-- 
2.25.1

