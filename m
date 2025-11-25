Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A43016F7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095356; cv=none; b=kkGzGdnHzKPKJX1i/dFniiAgpjHUVZTnXw1aDRsLkqB7s0Vvk5h1he3f0892iG+CaTavu9W56x6KNfUXCRtx9xPvAqAnOz0T60R65DsCktGbckmuIcw+NIYTSt/2HpO7j32XUU3DH2NHHBjxsFa6/zdlHzJ0F6KruKl20qycVpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095356; c=relaxed/simple;
	bh=XOx3eJuooH91eha2PkrqQHxCEXv3A0q56eZYKD8FThw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoX96hrnCQVAGOVK8YULro0QwGb74vLqmWdjpMp9gY5J793/2KbI7XtKnQuJL6w9aAhqzgGAg0gqv6xKsT45ejES2HR/E0xwcSyLYqhtvmW1BfrtphRdjwzwGd3Qsxw6wl+ppRBMcpqywh+mq6y986JUWVZpgiHYs9a7HvYJv6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0sLWn0KL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0sLWn0KL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8ln6pEKfmyIY/rY1SKqQzyGTI1gZAB4hx/DCrFw6Lp4=; b=0sLWn0KLNGfM+QjzhrqquL0Mpj
	cUsW3oLIuq3QxO+3B99jvHYkDv8k7rueNYVNqc0n8BIJGFkPKNRa+cqwY9U7s8gluhClEZcKsKDSL
	KsRU32HzyvqJZyK37IQNI73gLoifhUoBcUAIAWfDy7H1WVnXOm97HgKFO/PRlYToYY1qoMggUcZ7A
	KkviAt8OB3B//cYdQKbbCXQksylRssiRougN01kFr3xGhQaQ/+WJ1kDqgqwQOzC1fDnnf+OS0mpsH
	CpEdGhy219OXOoLif5VLvL60oXUhDHrQ+rGUiLyYU91jVtA3O7Qg3LHsMBWEdQZifkVsAYzwD9+3+
	cFkYWsL6J5zwVz82awOKALMPWvsrmhHssN2Uo7W2XLkc0K2omWZJeJrHLoWctTOiMe6+v9UJZ3mQU
	nc4EeJDpfvIq1UVsXpMcbardH0AO5UQQgZR4ewg9qITGh9ZZ8vMER3yoQpeat2BqBN2ngHLF/LyRf
	3zwORF4XnthuWwlJtuz+xqW3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxgR-00FfUX-2F;
	Tue, 25 Nov 2025 18:22:37 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 122/145] smb: server: make use of smbdirect_connection_grant_recv_credits()
Date: Tue, 25 Nov 2025 18:56:08 +0100
Message-ID: <2829c13eaae71087f9822288ccd878be9bea88fc.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is already used by the client too and will
help to share more common code.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5534de7a23ef..eb3189a0b7df 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -503,25 +503,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	return ret;
 }
 
-static int manage_credits_prior_sending(struct smbdirect_socket *sc)
-{
-	int new_credits;
-
-	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
-		return 0;
-
-	new_credits = atomic_read(&sc->recv_io.posted.count);
-	if (new_credits == 0)
-		return 0;
-
-	new_credits -= atomic_read(&sc->recv_io.credits.count);
-	if (new_credits <= 0)
-		return 0;
-
-	atomic_add(new_credits, &sc->recv_io.credits.count);
-	return new_credits;
-}
-
 static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -663,6 +644,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *sendmsg;
 	struct smbdirect_data_transfer *packet;
+	u16 new_credits = 0;
 	int header_length;
 	int ret;
 
@@ -673,7 +655,8 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	/* Fill in the packet header */
 	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
+	new_credits = smbdirect_connection_grant_recv_credits(sc);
+	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(sc))
@@ -1090,7 +1073,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 		resp->reserved = 0;
 		resp->credits_requested =
 				cpu_to_le16(sp->send_credit_target);
-		resp->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
+		resp->credits_granted = cpu_to_le16(smbdirect_connection_grant_recv_credits(sc));
 		resp->max_readwrite_size = cpu_to_le32(sp->max_read_write_size);
 		resp->preferred_send_size = cpu_to_le32(sp->max_send_size);
 		resp->max_receive_size = cpu_to_le32(sp->max_recv_size);
-- 
2.43.0

