Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF834126C03
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894379; cv=none; b=C9AZ5k4IZEYdNOMU9y2YjKsnnt8O8yhD8B2VxV3WfbAxUj02DS5QllPDUNAkpnv3qr8PHbwi72qrs31KYuEcnoCH6x8ThaAOCW9XZnUnjyAO146WAHrZD18rYAPOd5dCvK3tnI1zmQ09x+9MvE+Dj/qpN6V8pcHbMhFh1hgUwy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894379; c=relaxed/simple;
	bh=Z5innHxgh8TrRD1wrzpJLKCFY9CWcslXMH/AvwLCeOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9i8RcipGofxB8p7BK4jTkkXEaByqg4+avMJW33/DiBMjkUxa65pFHEbAs14VdunvBtYERYFRcZ8L5SOIUut9UzYT+17pAeOFj/sy1feapgFawNvuQpNVe7ZQm9g+HKr4/4BRH4bYK/zclEXmbr9rh+0ujp2CT5QAxSnG+2xLP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=oNz+Vgsu; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="oNz+Vgsu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gn1aqJxAMSDHWrta+PPC91OZOHgtIDIGz/WyKiddW44=;
	b=oNz+Vgsu/5Xhnb3ydyz+lvu65Yb7DpL/42jcbK9BbEtqQweoV7SB2i8MP8DfmwncFqC2c7
	OYc2jM2jNSeBXQKHhEgNdhzNAn0YC/CuuwwjLgKgOdSjzhqAM1dAwsUi17fpXK23F0kHul
	Sc8Jxdcskviyg7LbeHUM1tsJuLmzSU9oSIsHeQv2RwRjjrP7Jiz5dgwegWrQBfwH4iv22C
	vqi/yizbKWV/3s93rgvEaIziWTFTCzTuwbrJZ/+FKXp4mzuUNHLNQ8EJRK4PxgVEmx3692
	xGlpuAN64JiBomdt5Z4RZNJ1Ev9HfGEGDYIf+SLUWeIrDdXpHnjKaEU5ZHCCpw==
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
Subject: [PATCH 6/9] smb/client: add helpers for sending cancel requests
Date: Wed,  1 Jul 2026 08:25:04 +0000
Message-ID: <20260701082507.786487-7-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

SMB cancel requests are sent after the waiter has already been interrupted,
so they need to get onto the wire even when the current task has a pending
signal.

Split the low-level send path so normal requests keep the existing blocking
and signal checks, while cancel requests can ignore the pre-send fatal
signal check and force non-blocking socket sends.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/transport.c | 49 +++++++++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index dfbad6bc0a9b..4afe2163ef67 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -109,6 +109,8 @@ int cifs_sync_mid_result(struct mid_q_entry *mid,
 			 struct TCP_Server_Info *server);
 int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		    struct smb_rqst *rqst);
+int __smb_send_cancel_rqst(struct TCP_Server_Info *server, int num_rqst,
+			   struct smb_rqst *rqst);
 int wait_for_free_request(struct TCP_Server_Info *server, const int flags,
 			  unsigned int *instance);
 int cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ce..652e1e5711ad 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -130,17 +130,18 @@ delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 }
 
 /*
- * smb_send_kvec - send an array of kvecs to the server
+ * smb_send_kvec_flags - send an array of kvecs to the server
  * @server:	Server to send the data to
  * @smb_msg:	Message to send
  * @sent:	amount of data sent on socket is stored here
+ * @force_nonblock:	force non-blocking socket sends
  *
- * Our basic "send data to server" function. Should be called with srv_mutex
+ * Our basic "send data to server" helper. Should be called with srv_mutex
  * held. The caller is responsible for handling the results.
  */
-int
-smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
-	      size_t *sent)
+static int
+smb_send_kvec_flags(struct TCP_Server_Info *server, struct msghdr *smb_msg,
+		    size_t *sent, bool force_nonblock)
 {
 	int rc = 0;
 	int retries = 0;
@@ -148,7 +149,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 
 	*sent = 0;
 
-	if (server->noblocksnd)
+	if (server->noblocksnd || force_nonblock)
 		smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
 	else
 		smb_msg->msg_flags = MSG_NOSIGNAL;
@@ -210,6 +211,13 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	return 0;
 }
 
+int
+smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
+	      size_t *sent)
+{
+	return smb_send_kvec_flags(server, smb_msg, sent, false);
+}
+
 unsigned long
 smb_rqst_len(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
@@ -235,8 +243,10 @@ smb_rqst_len(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	return buflen;
 }
 
-int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
-		    struct smb_rqst *rqst)
+static int
+__smb_send_rqst_common(struct TCP_Server_Info *server, int num_rqst,
+		       struct smb_rqst *rqst, bool ignore_signal,
+		       bool force_nonblock)
 {
 	int rc;
 	struct kvec *iov;
@@ -263,7 +273,7 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		goto out;
 
 	rc = -ERESTARTSYS;
-	if (fatal_signal_pending(current)) {
+	if (!ignore_signal && fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
 		goto out;
 	}
@@ -293,7 +303,8 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			.iov_len  = 4
 		};
 		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, &hiov, 1, 4);
-		rc = smb_send_kvec(server, &smb_msg, &sent);
+		rc = smb_send_kvec_flags(server, &smb_msg, &sent,
+					 force_nonblock);
 		if (rc < 0)
 			goto unmask;
 
@@ -315,7 +326,8 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 
 		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, iov, n_vec, size);
 
-		rc = smb_send_kvec(server, &smb_msg, &sent);
+		rc = smb_send_kvec_flags(server, &smb_msg, &sent,
+					 force_nonblock);
 		if (rc < 0)
 			goto unmask;
 
@@ -323,7 +335,8 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 
 		if (iov_iter_count(&rqst[j].rq_iter) > 0) {
 			smb_msg.msg_iter = rqst[j].rq_iter;
-			rc = smb_send_kvec(server, &smb_msg, &sent);
+			rc = smb_send_kvec_flags(server, &smb_msg,
+						 &sent, force_nonblock);
 			if (rc < 0)
 				break;
 			total_len += sent;
@@ -382,6 +395,18 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
+int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
+		    struct smb_rqst *rqst)
+{
+	return __smb_send_rqst_common(server, num_rqst, rqst, false, false);
+}
+
+int __smb_send_cancel_rqst(struct TCP_Server_Info *server, int num_rqst,
+			   struct smb_rqst *rqst)
+{
+	return __smb_send_rqst_common(server, num_rqst, rqst, true, true);
+}
+
 static int
 smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
-- 
2.54.0

