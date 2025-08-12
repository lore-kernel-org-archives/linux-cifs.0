Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE47D2DFA3E;
	Tue, 12 Aug 2025 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022979; cv=none; b=P1vpQt2LOPGtWB6LxC/fJuB7UdrsPZ/2p71kf522dtp9fEzZpeIUiO2oFoPCCGE/RLDwMlVUFVSj2uuvpyebN8GUjStGjUzJPxTv4TE4XGysMtZnBxcb9MbMZCAhjsctWu81BsLh7NLkgaRzwdjDpWkTRFdjuhIzkHxipavKq30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022979; c=relaxed/simple;
	bh=AGtTlN+aU4nGXQd1Q/+GH+65gJwO0HSk+6jf7Bcpgm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q50lc3m0btx5SVrcIudOZhVSBcdp8NeWzmb0iPuJW7Btneo3ldvHwiqHXzXB+Y+GKPpaNpppmnti+wpGSOR6f9+vwzQa4JP9DU8fmSVTeeQOQ7VXPPbHofKNua3SAJdmqChg4iAX1QtlPcjvpCYWfkt6eBNjuCsDzzmq4RnungU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHY1SmH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHY1SmH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C496C4CEF6;
	Tue, 12 Aug 2025 18:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022979;
	bh=AGtTlN+aU4nGXQd1Q/+GH+65gJwO0HSk+6jf7Bcpgm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHY1SmH3xG5gBML88Xn7meNKhDdVkGwOfmxQNqaqhoRGgnCw/a6US2vb+9YCdfMIP
	 kb+bXq8yPlCy25Budj6hNAeS7coJcZ2+AcxjZw4S0LBIgCFcvQEBp4ofUD7SvrJ420
	 Yab+uoeQFOgRjdnad7Z1GmQns6v6kEtsDwd9S5Tg=
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
Subject: [PATCH 6.12 313/369] smb: server: let recv_done() consistently call put_recvmsg/smb_direct_disconnect_rdma_connection
Date: Tue, 12 Aug 2025 19:30:10 +0200
Message-ID: <20250812173028.498893050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3bb6cb9dceae..b5e9fd9369e9 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -520,13 +520,13 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
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
 
@@ -541,6 +541,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
 			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
 			return;
 		}
 		t->negotiation_requested = true;
@@ -548,7 +549,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		t->status = SMB_DIRECT_CS_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
-		break;
+		return;
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
@@ -558,6 +559,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (wc->byte_len <
 		    offsetof(struct smb_direct_data_transfer, padding)) {
 			put_recvmsg(t, recvmsg);
+			smb_direct_disconnect_rdma_connection(t);
 			return;
 		}
 
@@ -566,6 +568,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
 			    (u64)data_length) {
 				put_recvmsg(t, recvmsg);
+				smb_direct_disconnect_rdma_connection(t);
 				return;
 			}
 
@@ -608,11 +611,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
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



