Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B952F221FAC;
	Tue, 12 Aug 2025 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021206; cv=none; b=iWFq0BDt4DNycAb0r8H8ORYsNYjn4vOvqjd9YfTAhooEeKAwZ2+mc5SExhOPsA2yj/BrVTWPP13cMs+mPz2BYYQVq308aWd0/0fJa6VMW6kG92AyigVfixv2tfTFN8nPJJ2QKS2xdTxRywDy9d3JXFgk3y3nFd/LcdTtD31+30Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021206; c=relaxed/simple;
	bh=ZOVvG48/JSStAoxl03ONiBCmvsUrXNcm84umHW+6zFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0UmgOQ6VDN+VU60zf+9AVsZbazc9l8rn7RneI+M0xtPnZQPa3X8LkWOh7Yg7zruL9VvQTdCi8+g+8+ZrXIRoc6or/Ct0a5v5PCHLN3c1I3EKKo1kukBB75ezfqqQQvleZAHuJ6xcXxjuHdVAZRyxe58xbCssQe0uOftwJ6zohE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ijq7FM1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ijq7FM1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A8DC4CEF0;
	Tue, 12 Aug 2025 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021206;
	bh=ZOVvG48/JSStAoxl03ONiBCmvsUrXNcm84umHW+6zFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ijq7FM1Md3O2jPfLW3DeRwkurBuSztoBpRO6Jrfg21QXdMcr5aDGaj+S7mV4yibXn
	 zRl8vsI0uvB6kKc0GWlJ0pr9Jdx2LPClLsIJHgmAZiXrjMUlr5AId6MYcV6dyUbQCk
	 Jvd0gVLq3lftt2xnJKVHWj3AqzITbhVBIsmU048Q=
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
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/253] smb: server: let recv_done() consistently call put_recvmsg/smb_direct_disconnect_rdma_connection
Date: Tue, 12 Aug 2025 19:30:17 +0200
Message-ID: <20250812172958.573087899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit cfe76fdbb9729c650f3505d9cfb2f70ddda2dbdc ]

We should call put_recvmsg() before smb_direct_disconnect_rdma_connection()
in order to call it before waking up the callers.

In all error cases we should call smb_direct_disconnect_rdma_connection()
in order to avoid stale connections.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 71a12953089c..f9c0c5267e6e 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -515,13 +515,13 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	t = recvmsg->transport;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
+		put_recvmsg(t, recvmsg);
 		if (wc->status != IB_WC_WR_FLUSH_ERR) {
 			pr_err("Recv error. status='%s (%d)' opcode=%d\n",
 			       ib_wc_status_msg(wc->status), wc->status,
 			       wc->opcode);
 			smb_direct_disconnect_rdma_connection(t);
 		}
-		put_recvmsg(t, recvmsg);
 		return;
 	}
 
@@ -536,6 +536,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
 			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
 			return;
 		}
 		t->negotiation_requested = true;
@@ -543,7 +544,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		t->status = SMB_DIRECT_CS_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
-		break;
+		return;
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
@@ -553,6 +554,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->byte_len <
 		    offsetof(struct smb_direct_data_transfer, padding)) {
 			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
 			return;
 		}
 
@@ -561,6 +563,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
 			    (u64)data_length) {
 				put_recvmsg(t, recvmsg);
+				smb_direct_disconnect_rdma_connection(t);
 				return;
 			}
 
@@ -603,11 +606,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (is_receive_credit_post_required(receive_credits, avail_recvmsg_count))
 			mod_delayed_work(smb_direct_wq,
 					 &t->post_recv_credits_work, 0);
-		break;
+		return;
 	}
-	default:
-		break;
 	}
+
+	/*
+	 * This is an internal error!
+	 */
+	WARN_ON_ONCE(recvmsg->type != SMB_DIRECT_MSG_DATA_TRANSFER);
+	put_recvmsg(t, recvmsg);
+	smb_direct_disconnect_rdma_connection(t);
 }
 
 static int smb_direct_post_recv(struct smb_direct_transport *t,
-- 
2.39.5



