Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875321B041A
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155880; cv=none; b=RY9lhqwEwWyfaQum4O6GcXS8E6rqaowsuITY/G3GuJ1/m0CIQ61ntABqeyoRvO6Au12gSB+UdtjDtPoTa7JxzVywxDRRUK2KxmfJ43aqzYu1ulA98T4WnlvVhePi8xX0/IlLxdbc66ZnvWuovrTQAseVCw81arsJgZbgQxID2vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155880; c=relaxed/simple;
	bh=rCEognuZOYPB9A6FcGj9xeaAak52VM9sWDmXCKfgLow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppr/iRwuiItFHmYcHYrHktMKLo/Dxau66iGH2vSqUS8WVy9lhCZjL8MwgmrzHiwdlb/DI+qpBBhukV8DFtjxoOoLBLPn/Ycz2aKL3jC60Fq94yinVQauu1zo9/97oFxre+UC9GlJgqF99bvjXPRsTMfh59e3K3WTx07NOJRVaAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qDFtjq9U; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qDFtjq9U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pynBxh7fLsoz3of4JiCxtBBCus5L7YjnDUff3N5qq5M=; b=qDFtjq9UIljzYv6JDr6f1+JNS/
	sUpkLMMNBAfdqBYEgQ8NDEuFYx082lVGuNlfSBblUT/m+4Q6/LD5kpHxjcFehi7lqB/ZIFwaUd+rr
	4k6HbLWqWUKpTxEh1VQNkRHLOspnUXr/nrJ8hWkSGgNwJYduLkI3CyHNuY9iEKKHUYQk+x7YPXzx3
	UfgsW8KtteHojqs4LPWVGluKbg8kstxOEodpZ6QSs9fXBBU/y1LZlSs+4IN9jKzJ6lfWVf5Y1eNh0
	8JMVIeRaaw5hKAmSACuacTq5JnY64rH9ngE9jpDXzXxXONQFVo38RBuxb+Du2dRUFQjUi/MwklETe
	6q9zittPOAH8VDuoAvgLqIywFdFzQS0Jp/6pbsKg1JUqfRUWLDQMDBEJvmCkGwSI8rTCv7o9nYNNW
	IKmbFWpB5o1v4jMZYSWmKGKcSzHKqUjaR9Iz5QCtVoRoFV1Sjac1YA1zagqNIHyBWkQQi+GoO9WXW
	PbLCq5bHcnjD8xsYsY1ctPXT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeMh-000nku-0b;
	Mon, 25 Aug 2025 21:04:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 136/142] smb: server: pass struct smbdirect_socket to manage_credits_prior_sending()
Date: Mon, 25 Aug 2025 22:41:37 +0200
Message-ID: <f993a7b5d2160f96e0d08d780386e7d42a787435.1756139608.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index da48b2ec6dd3..8a57da09091c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -841,9 +841,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	smb_direct_free_sendmsg(sc, sibling);
 }
 
-static int manage_credits_prior_sending(struct smb_direct_transport *t)
+static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	int new_credits;
 
 	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
@@ -1015,7 +1014,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 	/* Fill in the packet header */
 	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(t));
+	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(t))
@@ -1604,7 +1603,7 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 		resp->reserved = 0;
 		resp->credits_requested =
 				cpu_to_le16(sp->send_credit_target);
-		resp->credits_granted = cpu_to_le16(manage_credits_prior_sending(t));
+		resp->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
 		resp->max_readwrite_size = cpu_to_le32(sp->max_read_write_size);
 		resp->preferred_send_size = cpu_to_le32(sp->max_send_size);
 		resp->max_receive_size = cpu_to_le32(sp->max_recv_size);
-- 
2.43.0

