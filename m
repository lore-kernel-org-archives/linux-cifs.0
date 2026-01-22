Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153C3816F7;
	Thu, 22 Jan 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102268; cv=none; b=Tb7KBZZ3lJddgs8ajlvz93cDZ1jGfY+/+B8IfHKMZM6aBGNGEFNNHH39/slFhuE4K39nsGKu9wOw9MGNp/v3qu3OZWyUtO56aXxczbjbJuQX0zLytyoNA48/sfmkA0tJUokYPLPqjNIe/gQGAYd+BaDhbTCs8Uqt36d/zpfBq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102268; c=relaxed/simple;
	bh=Qm73vQkIrt9v22k0OCMPjwDYevFV0h0uJD0bh65eMHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC6OLPk4WYcB+02gk5q0lz3P6pz0OsWFAvejBAzgYxly+V6FrOYZMEjbejwmKbMqY6pfFTCRh/rS2ypWIxksvLfraZ/cooS5MnZRfWImdlew0LXDnRGgu66i3ujSP0cSLscby2D+4GauSm1pA6GKrdgVVuiaLFQ+PqY2A9aTQuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MAkyHA+Q; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MAkyHA+Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A2YFxA9Q4Wp/YAWyRGmHQgfWmCT8pv5dL8K0KpaaSIQ=; b=MAkyHA+QbC1+H0C5ABzeOIwV0W
	c3w5S27uyFHwBosYVkdMGF6oYbwYI6ryteTWQyapl3R+lmyc2DuNRXHevAQ3Qk170pCsRtSglqtIZ
	hnrtQrHOrAGAd63M4nS/FOWXcgDL4ihlo/7MkhZDGCD1rcOwqcyTMcx6DMSA+KT3GuQ5aKprUXQ7n
	JkyjmoOhxS916VfgylWC2ZUyj3LsHiSfqg2Ts+3eBq8Pjj2hNTn7LLU4ArE8tqp26e0GhFil8wFCh
	ALMLFlHctdTl/hif9QhN8s11FyENPSeBcDbq71mYUr3eaow3wPSP66z693mWRisO3K7EvNBQk6uDf
	F5cILYjexJ2nkD1zFKSjK48/IWUi05C8DdJ+7ArANxOnUK+bzFH9oJW5xd9Y/ODunA+q3pJzJ6LkC
	Jbxlr3JVWfLjpqOWJ3MZ/ekfKi0hjgbEk52Xbkg404U0tYe9Mf8Xrjf2+gfTwnvxiqJRf8SpmO2cv
	h3ZAobqM9FnPGKdeMf/14bkJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyJI-00000001pky-4Bdp;
	Thu, 22 Jan 2026 17:17:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 04/20] smb: server: let recv_done() queue a refill when the peer is low on credits
Date: Thu, 22 Jan 2026 18:16:44 +0100
Message-ID: <cf74c2c819ca6a1bb682e73bc3de07f68da94cff.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In captures I saw that Windows was granting 191 credits in a batch
when its peer posted a lot of messages. We are asking for a
credit target of 255 and 191 is 252*3/4.

So we also use that logic in order to fill the
recv buffers available to the peer.

Fixes: a7eef6144c97 ("smb: server: queue post_recv_credits_work in put_recvmsg() and avoid count_avail_recvmsg")
Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c7abd621bd11..fc29b4c3b645 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -644,6 +644,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		struct smbdirect_data_transfer *data_transfer =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
 		u32 remaining_data_length, data_offset, data_length;
+		int current_recv_credits;
 		u16 old_recv_credit_target;
 
 		if (wc->byte_len <
@@ -682,7 +683,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 
 		atomic_dec(&sc->recv_io.posted.count);
-		atomic_dec(&sc->recv_io.credits.count);
+		current_recv_credits = atomic_dec_return(&sc->recv_io.credits.count);
 
 		old_recv_credit_target = sc->recv_io.credits.target;
 		sc->recv_io.credits.target =
@@ -702,7 +703,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			wake_up(&sc->send_io.credits.wait_queue);
 
 		if (data_length) {
-			if (sc->recv_io.credits.target > old_recv_credit_target)
+			if (current_recv_credits <= (sc->recv_io.credits.target / 4) ||
+			    sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
 			enqueue_reassembly(sc, recvmsg, (int)data_length);
-- 
2.43.0

