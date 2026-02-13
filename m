Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21204241665;
	Fri, 13 Feb 2026 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990785; cv=none; b=GlXM/zNQshMBj47CSb7FKHpRDgc3JT49NSaFBG4Ovt527H6XGOfNdDj8avfLrh18jCWJNaPesMzf3rgv6u1K8zSyD+NJAzRjfWeyt1YN3MpAo65dXX9y41G5sc/iavfuJ+s/J0gU7NOR/OHllafByw+krJ8haVMwRk4X9vmhSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990785; c=relaxed/simple;
	bh=sBlJX5hvFTRY0zZyRB4mdWBs4jZm014t1pF+O7YcoyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+2e0B19k9k0SaTIXsAKHAEsDZgIAGTe5OYOzSfVYGoQH1C+3eOgxKR7tPWhba428tJLz8WTcBeXBwT698oH1fT53mpCU7UndOLc/p20DLAFGGevnHlrp2oV8UCdyQq7rlvjq9e96q0XkKf5k7ikSvbs8ACBdaYMJlDkwM02RqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7Za8vma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7Za8vma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1A9C116C6;
	Fri, 13 Feb 2026 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990785;
	bh=sBlJX5hvFTRY0zZyRB4mdWBs4jZm014t1pF+O7YcoyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7Za8vmaH6cOw/a9tEQvtpa3lX3A56a13fBVzJcLeq1UK2MAprnfILkTfQfQHTKf9
	 o/rZTFJ1lNDCs5P7c2go+PQl8dLMdc/SfvZLhIyrzdgVSlzqi5CYgPBMAD4rUHlovi
	 fZ10m2UPaGTKsTXKYOlhZLm8o8IhzyUjDlndpA7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 23/49] smb: client: make use of smbdirect_socket.send_io.bcredits
Date: Fri, 13 Feb 2026 14:48:07 +0100
Message-ID: <20260213134709.736503470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 21538121efe6c8c5b51c742fa02cbe820bc48714 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c | 58 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ef3b237bccc1..dbb2d939bc44 100644
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
2.53.0



