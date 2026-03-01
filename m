Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A42E2D97AA;
	Sun,  1 Mar 2026 01:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329562; cv=none; b=dqBJmeb5FjY1F7okdMAvajZjx+louwqMvcL9L/Vv8JucVWlEVt5vyWwglW8/hBIQSLUhpixmgglpG8rFlM2pziDyyKr6hPmVo27D65a8vz667VimSKFMM86AWS06oGGZGvC0Xahht3DjPVRkbBu0r62hUdP9rQzyHVUjQvGi8Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329562; c=relaxed/simple;
	bh=R+pgEECgS7MoW2PuDQ5eTUgmpi1PCKZQ/lTroDRfrxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uI677LmA90ACnFlvpnVTu2iJuNKqSIdnGO27F6o4DgO6IjkBP5G22hJ8FkiwmXhrE9cCrmYtTQ2QJnnUV+onSohnStfx5W1uHIJ/OgRjPgE+N4Tdd5XjmqlVGmlgghX4R0yxcZJ0MaXPWbJvBmBfe8DcGAvZ0nnKr37W9Pv2TYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kI6SdB0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kI6SdB0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FB1C19424;
	Sun,  1 Mar 2026 01:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329562;
	bh=R+pgEECgS7MoW2PuDQ5eTUgmpi1PCKZQ/lTroDRfrxA=;
	h=From:To:Cc:Subject:Date:From;
	b=kI6SdB0s6qj1AiXHFJR5env/gIfKufSJcrYHt27QS3cqBfirAlJvwCUTJqgq0Vlqc
	 1gRzdsjWiufmd8arz9XlDGUDM8Zx8LErW0arf/BRtlU6l1ot/ZIRUkfS4bxRyU4yX3
	 Vl+WJMk6yzXKJchshZQZGkO3WUkRpnN/bfHfH7SAdzK3DESB5BWBu+E04WTEKP+Mv+
	 SuE+UZgTWu9vtJCAeUWPVMiU15TbBOs5Wud3GmdzXgAddjrtDJH+znrDLhKdNdJ7Ms
	 xAA9lqZFWT7IrQQ0FALNneZepTsUZx3aYg03HT8dUQYXnHs1z4J3j38Vh+OFxvUaGu
	 DNfWOUtMV7k9w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: server: make use of smbdirect_socket.send_io.bcredits" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:00 -0500
Message-ID: <20260301014600.1708848-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 34abd408c8ba24d7c97bd02ba874d8c714f49db1 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:45 +0100
Subject: [PATCH] smb: server: make use of smbdirect_socket.send_io.bcredits

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 53 ++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4a473df1f2b3a..38248b6a1b5ca 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -221,6 +221,7 @@ static void smb_direct_disconnect_wake_up_all(struct smbdirect_socket *sc)
 	 * in order to notice the broken connection.
 	 */
 	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.bcredits.wait_queue);
 	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
 	wake_up_all(&sc->send_io.pending.zero_wait_queue);
@@ -1152,6 +1153,7 @@ static void smb_direct_send_ctx_init(struct smbdirect_send_batch *send_ctx,
 	send_ctx->wr_cnt = 0;
 	send_ctx->need_invalidate_rkey = need_invalidate_rkey;
 	send_ctx->remote_key = remote_key;
+	send_ctx->credit = 0;
 }
 
 static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
@@ -1159,10 +1161,10 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 				      bool is_last)
 {
 	struct smbdirect_send_io *first, *last;
-	int ret;
+	int ret = 0;
 
 	if (list_empty(&send_ctx->msg_list))
-		return 0;
+		goto release_credit;
 
 	first = list_first_entry(&send_ctx->msg_list,
 				 struct smbdirect_send_io,
@@ -1204,6 +1206,13 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 		smb_direct_free_sendmsg(sc, last);
 	}
 
+release_credit:
+	if (is_last && !ret && send_ctx->credit) {
+		atomic_add(send_ctx->credit, &sc->send_io.bcredits.count);
+		send_ctx->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
+
 	return ret;
 }
 
@@ -1229,6 +1238,25 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
+static int wait_for_send_bcredit(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *send_ctx)
+{
+	int ret;
+
+	if (send_ctx->credit)
+		return 0;
+
+	ret = wait_for_credits(sc,
+			       &sc->send_io.bcredits.wait_queue,
+			       &sc->send_io.bcredits.count,
+			       1);
+	if (ret)
+		return ret;
+
+	send_ctx->credit = 1;
+	return 0;
+}
+
 static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *send_ctx)
 {
@@ -1430,6 +1458,16 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	struct smbdirect_send_io *msg;
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
+	struct smbdirect_send_batch _send_ctx;
+
+	if (!send_ctx) {
+		smb_direct_send_ctx_init(&_send_ctx, false, 0);
+		send_ctx = &_send_ctx;
+	}
+
+	ret = wait_for_send_bcredit(sc, send_ctx);
+	if (ret)
+		goto bcredit_failed;
 
 	ret = wait_for_send_lcredit(sc, send_ctx);
 	if (ret)
@@ -1482,6 +1520,13 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	ret = post_sendmsg(sc, send_ctx, msg);
 	if (ret)
 		goto err;
+
+	if (send_ctx == &_send_ctx) {
+		ret = smb_direct_flush_send_list(sc, send_ctx, true);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 err:
 	smb_direct_free_sendmsg(sc, msg);
@@ -1490,6 +1535,9 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 credit_failed:
 	atomic_inc(&sc->send_io.lcredits.count);
 lcredit_failed:
+	atomic_add(send_ctx->credit, &sc->send_io.bcredits.count);
+	send_ctx->credit = 0;
+bcredit_failed:
 	return ret;
 }
 
@@ -1961,6 +2009,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 		resp->max_fragmented_size =
 				cpu_to_le32(sp->max_fragmented_recv_size);
 
+		atomic_set(&sc->send_io.bcredits.count, 1);
 		sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 	}
-- 
2.51.0




