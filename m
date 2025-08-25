Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824121E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155536; cv=none; b=ji2passUU+jASTeRj+gjsiBXscLSc1AN66LRFK8BEmMlCImXzUzFRRueqqw7XmyIYVmUV9mdpF+BzvcHrnqLB/6C8XOJiMm3sDBh1DWBJNQy7o6vxmKD4z2rAQYMQvc1fG4BIgkJZoPrgeFXGjQdO3QKLHdxcMV8Ea7gvDZqR7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155536; c=relaxed/simple;
	bh=i2NmkFDr2ZM1lTWNUzkTce9UavmoVPj7agXZNhsn1fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STc5h5JApWazeAzahQ1IV7LzJxvYRxhILtgq1MyKc4uBOmiXbVS/I0JMJ/B8Q80bDXtdmg3UmlSbD5oYDMjJUqQp8w2EQ2IUjuaW1udYow9BHMXv6/xDtOKFE9zYvMXkVwATl7qm+GCjRMzTJv20vh9Rd7s/C4Ts6Bdey2GwgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=lXA6hKLG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="lXA6hKLG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cR9tHGIE29IQFSOemmoLUrCck/+6lNzf8sYYuhklJoA=; b=lXA6hKLG5Y4knVME1+BBuY8Gx7
	9Se3jztSBgdQk3C2mwlJ1RINGUHpDw2hgaHtJClixTG1B1ePpzfQxfmPjdQ3PyO8nyVzjef/uosME
	WPYvCQrmEjH8DIw4nFCyp799v3NrXmPFuUcNSilU+6563o8HKG2Uw77MB8FQbD52mc/KFemZM68IA
	o7D7uBoJ93VXfsnaKXPfsas2rHcSSkirGbfVe7HA1VJdLwXsIkuz9GU6lA+H14DX5COK4hoMtBFYR
	wJU07XfQD/bOQnkrEPyPms2O1tkbkfXtMuMqJWkMOhxH3c5baAoPqPLtGy31SqMbQ/ThESrr2CKQR
	4oX2pUFGF7Gs2nt8kdvZMqgrEAgdvId5OsiHn5otJouXi/ej8yZOBIgIvfGqowCL7CXbrQfH/VMrG
	4wgGMkS7QglTHJjqSNijOQaKpl6FElIm/JsZmXKyyzYL0QJYPCIFsMGxaNHqWZ3uLXoly0afRoVGP
	4hGlpvjMb5axq2sAGRB70DHA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeHD-000mdG-1j;
	Mon, 25 Aug 2025 20:58:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 103/142] smb: server: take the recv_credit_target from the negotiate req and always limit the range
Date: Mon, 25 Aug 2025 22:41:04 +0200
Message-ID: <16aa56f3e75fe239cfbecb22a522acbf00d50be0.1756139607.git.metze@samba.org>
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

The clients sends the initial recv_credit_target in the negotiate req,
so we should use that.

We also limit the range between 1 and our local defined
sp->recv_credit_max. This will simplify further logic changes.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3a0244943dc7..6046ebdc1317 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -94,7 +94,7 @@ struct smb_direct_transport {
 
 	spinlock_t		receive_credit_lock;
 	int			recv_credits;
-	int			recv_credit_target;
+	u16			recv_credit_target;
 
 	spinlock_t		lock_new_recv_credits;
 	int			new_recv_credits;
@@ -472,9 +472,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_recv_io *recvmsg;
 	struct smb_direct_transport *t;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters *sp;
 
 	recvmsg = container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	sc = recvmsg->socket;
+	sp = &sc->parameters;
 	t = container_of(sc, struct smb_direct_transport, socket);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
@@ -512,7 +514,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		struct smbdirect_data_transfer *data_transfer =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
 		unsigned int data_length;
-		int old_recv_credit_target;
+		u16 old_recv_credit_target;
 
 		if (wc->byte_len <
 		    offsetof(struct smbdirect_data_transfer, padding)) {
@@ -546,6 +548,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		old_recv_credit_target = t->recv_credit_target;
 		t->recv_credit_target =
 				le16_to_cpu(data_transfer->credits_requested);
+		t->recv_credit_target =
+			min_t(u16, t->recv_credit_target, sp->recv_credit_max);
+		t->recv_credit_target =
+			max_t(u16, t->recv_credit_target, 1);
 		atomic_add(le16_to_cpu(data_transfer->credits_granted),
 			   &sc->send_io.credits.count);
 
@@ -1753,7 +1759,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	t->recv_credits = 0;
 
 	sp->recv_credit_max = smb_direct_receive_credit_max;
-	t->recv_credit_target = 10;
+	t->recv_credit_target = 1;
 	t->new_recv_credits = 0;
 
 	sp->send_credit_target = smb_direct_send_credit_target;
@@ -1979,6 +1985,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		le32_to_cpu(req->max_fragmented_size);
 	sp->max_fragmented_recv_size =
 		(sp->recv_credit_max * sp->max_recv_size) / 2;
+	st->recv_credit_target = le16_to_cpu(req->credits_requested);
+	st->recv_credit_target = min_t(u16, st->recv_credit_target, sp->recv_credit_max);
+	st->recv_credit_target = max_t(u16, st->recv_credit_target, 1);
 
 	ret = smb_direct_send_negotiate_response(st, ret);
 out:
-- 
2.43.0

