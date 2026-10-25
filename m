Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917342;
	b=yAC7QpdGlyot/9mONhjTTigBV+l/UMHBJwpJSy4oOpDgJ4J+FwZ9kFUtaYSCWdIlbR1q
	 UAQb0SE+yNxy+g28WGiGrxMzUPZpqqoiXs/Vu3vSpqgMLiZUHH0XRv8whXO7IQIh06UD3
	 GnXkbCUQ7qSO9TcaRKXUrSQhtG4g1G0yGgQxIg2IHdx1rwS55JHmLrjoFoR3SWh4qlh8f
	 TwiQkbguMYHgHURaTioQ7/usxu9YIfOnAnQIjuIQpMMfVBxKcbg16QTGqGMzeADCmNgrB
	 F6fw7SQ3+gZXFoqqlwZiiefpXaE9B0n1FKpt71oMTXYIU8yYDnb5trF3aOg7a114C2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917342;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5445wC328ZzVFq6BXFI+vWmcy8MZd1xunk4SwQ3xU1g=;
	b=VRg/ugxV2dhEMRsywHNztRFKF4jixZbr83ko2evzxzCTIzbc1hVFc/gmlYyKhPEYBldH
	 Vf+TMKdwsUgtgmU3Fya9AkOwZaHdXvbbaZm2wi0vYmcaDalPlytdfYLQFyZI6g3HQ/MB9
	 QiulaDEpWRm/wWGBhHP6V9og878wMwDaJi8UV6imImjgxF1QqRRgrqhyI3h2Bz04mFI9R
	 AJ1a1dF7/p4L+7f+1bhwff5tvA0LL+d5SLDyyZ4lxojCUUFjFGwvhtwBrCckelXZf/kES
	 9wD0ESZPimO0r5EsKh5mfjrQccYmD26xLSVcVvPZev1vZn/T1ziHW4pUnoEON1koIWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Ed5ySF+J;
	arc=none smtp.remote-ip=91.218.175.57
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB074606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB074606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Ed5ySF+J
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BLl2tjYCgA0Q9YWtUZdBqreV2inQCA6W7oL6yfCZfuM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917340; v=1; x=1793522140;
 b=Ed5ySF+J2anseN9S4RZ2wN6JXjSB66gX0L24WWezuA6TtN/XQaabKoQs41rmAcCU07lW17NX
 FC/5AbDxHFVFL8zOBxih5Un/r4ZqpJ7b3VvLZF1uwP6KjAyuQIVfmSitaMkw1iEpYqAVfQ9jCu5
 /ey6CWOJO7LXWaN3CgsjR7dme9TAq+bHgFdPmazG2oEPxgP8el6ZVrSVD1AvyWWTCNuLlbvE512
 3IrV2QvA+g4qyPWYChK/HELYdhZ0mhhqWIqwVx6tBYJ+LeagZ1UWUNEKc0mTUg4lT3H6GIG0yN7
 fs+/YXiiYZ+wo5YvjrScCDrKZp3vaQRADKIvWktHTV89A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id af7bfc090744ce25;
	Sun, 25 Oct 2026 08:35:39 +0000
X-Mizu-Trace-ID: af7bfc090744ce25
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 03/13] smb/server: add debug type for change notify
Date: Sun, 25 Oct 2026 08:34:40 +0000
Message-ID: <20261025083450.212604-4-chenxiaosong@chenxiaosong.com>
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
index a5a71c2efe5d..744dacc070c6 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -35,6 +35,7 @@ static void smb2_notify_cancel(void **argv)
 {
 	struct ksmbd_notify_req *notify_req = argv[0];
 
+	ksmbd_debug(NOTIFY, "Wake pending notify request\n");
 	wake_up(&notify_req->wait);
 }
 
@@ -62,6 +63,11 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
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
@@ -117,6 +123,8 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	spin_unlock(&fp->f_lock);
 	read_unlock(&work->sess->file_table.lock);
 
+	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
+		    work->async_id);
 	smb2_send_interim_resp(work, STATUS_PENDING);
 
 	err = wait_event_interruptible(notify_req->wait,
@@ -191,8 +199,12 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 
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
index 064f99427ca6..387e3a13ec7e 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -589,7 +589,7 @@ static ssize_t kill_server_store(const struct class *class,
 
 static const char * const debug_type_strings[] = {"smb", "auth", "vfs",
 						  "oplock", "ipc", "conn",
-						  "rdma"};
+						  "rdma", "notify"};
 
 static ssize_t debug_show(const struct class *class, const struct class_attribute *attr,
 			  char *buf)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5ad78e3eee2d..8ee53c0ba93a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12478,7 +12478,7 @@ int smb2_notify(struct ksmbd_work *work)
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
 
-	ksmbd_debug(SMB, "Received smb2 notify\n");
+	ksmbd_debug(NOTIFY, "Received smb2 notify\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
-- 
2.55.0

