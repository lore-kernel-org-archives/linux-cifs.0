Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9E11E0B86;
	Sun,  1 Mar 2026 01:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329060; cv=none; b=YUhkaHFe8cqqNvTAK5Ur1Q4AUpM5CgPsh94c/zi9yvUwF65Ho9Oj5VHpuoboNys209XfOdOhDxFzqV9LE7kQS4diM46k2mpqZ0ztQuOTwOlELXogYb5bM7kUoeDo6dt6eDwioDAX09DFhvFD0PEu/Q9KTpLO9R8v1ytClc2bHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329060; c=relaxed/simple;
	bh=DoMNIYkp5hYbxoFpPXSwcYLhxzQULTml3XK6dWcN/oE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JIVqj32iWYrt6V+65MFa2JdYKPOLkVJSZFcZKPiOVl1E7Nma9LVCb7qfWrI5oMtdwaAXl7PI6CBg3y8qWrpaSU8Hd90bIGEgWUERyFkuFkJi+0k6NbHj5QJEUpZjJ5jwWdUzmD4euemzSJf9ymQnamjGYI8cYFYDFSndK6UG4Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/6HE+ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/6HE+ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB96C2BC86;
	Sun,  1 Mar 2026 01:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329059;
	bh=DoMNIYkp5hYbxoFpPXSwcYLhxzQULTml3XK6dWcN/oE=;
	h=From:To:Cc:Subject:Date:From;
	b=d/6HE+ME64IX54fuFIhljJeawnAPeOgUXkDXlxewH9cnu//JXZDZdtKm7lgX56m7h
	 NJHgI7c45opY8eQnkBz3KuSjdxOlqjSOF12uLZT2OC87zlso8FA+6NVppAJ4+hB3TQ
	 QECEBzfopXwSm8VJ/Qi9y7EXsrjbtknq6qCUXyTM1Ist5egZo0UhudzE0v5cce6t9P
	 AMv7C776h/B3wfvqRqZG4kdgHawwrXw5Y2bQ4+wDNZM6goEeNgw0WDxqyJII1I7jn5
	 3MPG59+4OjUvQntdFju7fy1DA7rwusiBXMMw6OYmp+b6Il7SqC3RZsusfuboU+a+xd
	 JxtpBs7+bDEog==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: make use of smbdirect_socket.send_io.bcredits" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:37:37 -0500
Message-ID: <20260301013737.1697865-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 21538121efe6c8c5b51c742fa02cbe820bc48714 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:57 +0100
Subject: [PATCH] smb: client: make use of smbdirect_socket.send_io.bcredits

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 58 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ef3b237bccc13..dbb2d939bc44d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -657,6 +657,7 @@ static bool process_negotiation_response(
 			sp->max_frmr_depth * PAGE_SIZE);
 	sp->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
 
+	atomic_set(&sc->send_io.bcredits.count, 1);
 	sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 	return true;
 }
@@ -1214,6 +1215,7 @@ static void smbd_send_batch_init(struct smbdirect_send_batch *batch,
 	batch->wr_cnt = 0;
 	batch->need_invalidate_rkey = need_invalidate_rkey;
 	batch->remote_key = remote_key;
+	batch->credit = 0;
 }
 
 static int smbd_send_batch_flush(struct smbdirect_socket *sc,
@@ -1224,7 +1226,7 @@ static int smbd_send_batch_flush(struct smbdirect_socket *sc,
 	int ret = 0;
 
 	if (list_empty(&batch->msg_list))
-		return 0;
+		goto release_credit;
 
 	first = list_first_entry(&batch->msg_list,
 				 struct smbdirect_send_io,
@@ -1266,6 +1268,13 @@ static int smbd_send_batch_flush(struct smbdirect_socket *sc,
 		smbd_free_send_io(last);
 	}
 
+release_credit:
+	if (is_last && !ret && batch->credit) {
+		atomic_add(batch->credit, &sc->send_io.bcredits.count);
+		batch->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
+
 	return ret;
 }
 
@@ -1291,6 +1300,25 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
+static int wait_for_send_bcredit(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *batch)
+{
+	int ret;
+
+	if (batch->credit)
+		return 0;
+
+	ret = wait_for_credits(sc,
+			       &sc->send_io.bcredits.wait_queue,
+			       &sc->send_io.bcredits.count,
+			       1);
+	if (ret)
+		return ret;
+
+	batch->credit = 1;
+	return 0;
+}
+
 static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *batch)
 {
@@ -1338,6 +1366,19 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_send_io *request;
 	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
+	struct smbdirect_send_batch _batch;
+
+	if (!batch) {
+		smbd_send_batch_init(&_batch, false, 0);
+		batch = &_batch;
+	}
+
+	rc = wait_for_send_bcredit(sc, batch);
+	if (rc) {
+		log_outgoing(ERR, "disconnected not sending on wait_bcredit\n");
+		rc = -EAGAIN;
+		goto err_wait_bcredit;
+	}
 
 	rc = wait_for_send_lcredit(sc, batch);
 	if (rc) {
@@ -1432,8 +1473,14 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->remaining_data_length));
 
 	rc = smbd_post_send(sc, batch, request);
-	if (!rc)
-		return 0;
+	if (!rc) {
+		if (batch != &_batch)
+			return 0;
+
+		rc = smbd_send_batch_flush(sc, batch, true);
+		if (!rc)
+			return 0;
+	}
 
 err_dma:
 	smbd_free_send_io(request);
@@ -1447,6 +1494,11 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	wake_up(&sc->send_io.lcredits.wait_queue);
 
 err_wait_lcredit:
+	atomic_add(batch->credit, &sc->send_io.bcredits.count);
+	batch->credit = 0;
+	wake_up(&sc->send_io.bcredits.wait_queue);
+
+err_wait_bcredit:
 	return rc;
 }
 
-- 
2.51.0




