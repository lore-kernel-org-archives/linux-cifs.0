Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E4E34250E
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413585; cv=none; b=KewwUinz7g/Bp+GtEHYHSEJ/MyAiVNoA1/9FvI+ElMK3LTUW5cqCdA9N3ttOgXF7rhj/s5poo9Q18uAwK6rNFrVRHMTsSAwynvcBcFNz9cZxBe45BMMb9+38tTPzlA3AS8IHEI0gh41fCK640mPcbxLe57WvuGIJVuWIICmUZPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413585; c=relaxed/simple;
	bh=M5SB8Vg50ZNwzHlvexHehiO0cDY1aoKxdOCIKbLs3y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzcYy5KT6JTRdex28PycbF+IBiLxUpH6v6ELUVhSWy2/NgIOlYzSZlnIkPBPfjnFGpuF1mlNdLX+kXxekCujy5cdCCY5MVUZWJqpFipRNyRJDyJVWS01hUSDw4vYCdU8s/6KXCMYaeEnFP1Ikf9DLfNFu9CgZb65ECuOkJOUx/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=s3Zl37KQ; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="s3Zl37KQ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=M5SB8Vg50ZNwzHlvexHehiO0cDY1aoKxdOCIKbLs3y8=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413580; v=1; x=1791018380;
 b=s3Zl37KQSiMe6DruXnW638cbv42TkNrAMINQudEtXoWXt+FXq0C0InFvWkmysjbDKmpVCUC6
 GVHIv7sAgHRiuPdzKECPbBK2ALmd2UzYiU5JWDE1YXqLwQ0vnvcKslCp8L1kCR/Gas4+tVwGoxH
 Q3aPHKzO71id/cOXm4RDCXXD6dlAO5fLMuTsuAHidHx49mDpkczH75ZKRZwLvNnxHoX/l25ZmMI
 YZhyv9eFoCjNmE79qW+Tlhxy8ZIPCpaSXCT/na/XhCgbge9jrPwrkYzknGD7XdD62O1fgt1beQk
 mqk7KoJPhuyUi1OWYE+1t4jtP3+DU7uBtdbqr+ST7Bh1w==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 735c926924e84459;
	Sat, 26 Sep 2026 09:06:19 +0000
X-Mizu-Trace-ID: 735c926924e84459
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 03/12] smb/server: add debug type for change notify
Date: Sat, 26 Sep 2026 09:05:09 +0000
Message-ID: <20260926090518.78547-4-chenxiaosong@chenxiaosong.com>
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

Add KSMBD_DEBUG_NOTIFY and expose it as "notify" to print logs
for the change notify feature.

Example:

  ksmbd.control --debug=notify
  [ksmbd.control/802]: INFO: smb auth vfs oplock ipc conn rdma [notify]

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/glob.h    |  3 ++-
 fs/smb/server/notify.c  | 12 ++++++++++++
 fs/smb/server/server.c  |  2 +-
 fs/smb/server/smb2pdu.c |  2 +-
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/glob.h b/fs/smb/server/glob.h
index 4ea187af2348..5131bad88d96 100644
--- a/fs/smb/server/glob.h
+++ b/fs/smb/server/glob.h
@@ -21,10 +21,11 @@ extern int ksmbd_debug_types;
 #define KSMBD_DEBUG_IPC         BIT(4)
 #define KSMBD_DEBUG_CONN        BIT(5)
 #define KSMBD_DEBUG_RDMA        BIT(6)
+#define KSMBD_DEBUG_NOTIFY      BIT(7)
 #define KSMBD_DEBUG_ALL         (KSMBD_DEBUG_SMB | KSMBD_DEBUG_AUTH |	\
 				KSMBD_DEBUG_VFS | KSMBD_DEBUG_OPLOCK |	\
 				KSMBD_DEBUG_IPC | KSMBD_DEBUG_CONN |	\
-				KSMBD_DEBUG_RDMA)
+				KSMBD_DEBUG_RDMA | KSMBD_DEBUG_NOTIFY)
 
 #ifdef pr_fmt
 #undef pr_fmt
diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 18cf0005a037..502ec551c01e 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -39,6 +39,7 @@ static void smb2_notify_cancel(void **argv)
 {
 	struct ksmbd_notify_req *notify_req = argv[0];
 
+	ksmbd_debug(NOTIFY, "Wake pending notify request\n");
 	wake_up(&notify_req->wait);
 }
 
@@ -66,6 +67,11 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 		return ERR_PTR(-ENOENT);
 	}
 
+	ksmbd_debug(NOTIFY,
+		    "fid %llu:%llu, handle notify request, filter 0x%x, flags 0x%x\n",
+		    fp->persistent_id, fp->volatile_id,
+		    le32_to_cpu(req->CompletionFilter), le16_to_cpu(req->Flags));
+
 	if (le32_to_cpu(req->OutputBufferLength) >
 	    work->conn->vals->max_trans_size) {
 		pr_err("Notify output buffer length %u exceeds maximum %u\n",
@@ -121,6 +127,8 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	spin_unlock(&fp->f_lock);
 	read_unlock(&work->sess->file_table.lock);
 
+	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
+		    work->async_id);
 	smb2_send_interim_resp(work, STATUS_PENDING);
 
 	err = wait_event_interruptible(notify_req->wait,
@@ -195,8 +203,12 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 
 	if (work->state == KSMBD_WORK_CLOSED) {
 		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
+		ksmbd_debug(NOTIFY, "Notify handle closed, async id %d\n",
+			    work->async_id);
 	} else {
 		rsp->hdr.Status = STATUS_CANCELLED;
+		ksmbd_debug(NOTIFY, "Notify request cancelled, async id %d\n",
+			    work->async_id);
 	}
 	smb2_send_interim_resp(work, rsp->hdr.Status);
 	work->send_no_response = 1;
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0827c8c51006..958e952223aa 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -564,7 +564,7 @@ static ssize_t kill_server_store(const struct class *class,
 
 static const char * const debug_type_strings[] = {"smb", "auth", "vfs",
 						  "oplock", "ipc", "conn",
-						  "rdma"};
+						  "rdma", "notify"};
 
 static ssize_t debug_show(const struct class *class, const struct class_attribute *attr,
 			  char *buf)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1f45a0836fe9..eb15cda699b7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11830,7 +11830,7 @@ int smb2_notify(struct ksmbd_work *work)
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
 
-	ksmbd_debug(SMB, "Received smb2 notify\n");
+	ksmbd_debug(NOTIFY, "Received smb2 notify\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
-- 
2.55.0

