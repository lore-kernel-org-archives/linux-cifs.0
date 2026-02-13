Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DCC34CFC3;
	Fri, 13 Feb 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990741; cv=none; b=DWF/wk66fZesdptyLJY5bp/mG3RBbOSaTOcGTM8K3FHRYypmd3Z06ouvNDT16y2SSRJ8AfGLf6/ccZFoBgVWWq4PrgeAMw1jiO3ufXJD9xE2gxKMhE3HtdB100yq3hoMlM0aF4ydD04JDvxkQlaNcxyvTaF0AZVF+hJ+ZfWEnVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990741; c=relaxed/simple;
	bh=uicr+uzG78xsHblpRBUcgDtc58/ZqPyK9elPpdF1h0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw7YSkSUMfG3Z5mVbfJNiu6q4qAhdA+JiJ0TJMG3Y14ngIvxbrUJF5XO4DUPBJbula+SWNW8y+RWbejs6V+gP/L8xZpbQVq+5aKAvdYbKDeJXYVyVEUqSQ1jq/WfBGyJL11DLwNM97aV+nP3Vs8aO+z17XX/F/YEbkUzvlB+n7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou9vKXTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou9vKXTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA4C16AAE;
	Fri, 13 Feb 2026 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990741;
	bh=uicr+uzG78xsHblpRBUcgDtc58/ZqPyK9elPpdF1h0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou9vKXTfgX1+qp6OpyolISTwPTBIMlmTqmx6Ad8/7l1iLhi+I8nyCmFIrY1cygUVH
	 k6Dt/hhIGfUuox6iLXoHZCjfm4I9AfgqTKrSANow588k+EBDgn7bu3uhrNBY+qZfNs
	 OTf2XJIlWtZfp3TyxFvebNIxjaHQMZOKr8EAEH1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 11/49] smb: server: make use of smbdirect_socket.send_io.bcredits
Date: Fri, 13 Feb 2026 14:47:55 +0100
Message-ID: <20260213134709.301003604@linuxfoundation.org>
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

commit 34abd408c8ba24d7c97bd02ba874d8c714f49db1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   53 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -221,6 +221,7 @@ static void smb_direct_disconnect_wake_u
 	 * in order to notice the broken connection.
 	 */
 	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.bcredits.wait_queue);
 	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
 	wake_up_all(&sc->send_io.pending.zero_wait_queue);
@@ -1050,6 +1051,7 @@ static void smb_direct_send_ctx_init(str
 	send_ctx->wr_cnt = 0;
 	send_ctx->need_invalidate_rkey = need_invalidate_rkey;
 	send_ctx->remote_key = remote_key;
+	send_ctx->credit = 0;
 }
 
 static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
@@ -1057,10 +1059,10 @@ static int smb_direct_flush_send_list(st
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
@@ -1102,6 +1104,13 @@ static int smb_direct_flush_send_list(st
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
 
@@ -1127,6 +1136,25 @@ static int wait_for_credits(struct smbdi
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
@@ -1328,6 +1356,16 @@ static int smb_direct_post_send_data(str
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
@@ -1380,6 +1418,13 @@ static int smb_direct_post_send_data(str
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
@@ -1388,6 +1433,9 @@ header_failed:
 credit_failed:
 	atomic_inc(&sc->send_io.lcredits.count);
 lcredit_failed:
+	atomic_add(send_ctx->credit, &sc->send_io.bcredits.count);
+	send_ctx->credit = 0;
+bcredit_failed:
 	return ret;
 }
 
@@ -1849,6 +1897,7 @@ static int smb_direct_send_negotiate_res
 		resp->max_fragmented_size =
 				cpu_to_le32(sp->max_fragmented_recv_size);
 
+		atomic_set(&sc->send_io.bcredits.count, 1);
 		sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 	}


