Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117B32D0F2
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094221; cv=none; b=QbaGaDer9KAzsYVeItNiQoQpMiqAO3295xBRA5UYAzHRd/V5IJTMj+f0ISx5/cVCyhPku+KKtL0985xWSYnkf/EVs7SzUduXE5yoKGpPJsp6YG3a9XHHk7ndjShjDNKuxuSSsNDvkybOuyOqlGvIKXIoMK8uZW4IRm77OGArp3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094221; c=relaxed/simple;
	bh=5xcUy/oYJKGsJha4n1Np2PC9xMDaEv472FBfEnR2V74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRDHByAHT37z8QIZnqR5ARQcjfN3Di9y12UyCrAl5XwmIV0PB+YadqaUk5ajwVZaV10cO1Uw+qSZOyKlHP8EGa99CuVRUYWYgQFMDe4Bgtu8ZwAHNS17rkBd6PgY8jnCsFnEi2NFZybhHT3KMO+YKwGoTfCPcn5DCXDSP/at+WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=S69nr0yl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="S69nr0yl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vZ9wm/N/IgIr9DJycuToxqYWeqYYjlenGWmfHHlmtgQ=; b=S69nr0yl7iTMLCeRItERubYzLB
	Wbw9Hg394mtYSfowFCA8hH26atdFTrDGJ4UZd4YrMWaGghH8/ZuIur9pHDq+SSJA40loP1TNrm6RT
	4vc/lWhC6Fk2ZCWp/8dcpblnEXbBhlM7tQ2lZUawZcJc+Y2PAe9FhHNNav3p+FQ5dFXO4qo0K+0cA
	3tQ2rcFi/5lXab74G/JxZJRrftTcwMJ+pQyilrbawbnVMHyQUU6vx7TcxxHmHpaAnFfNjV285z9YM
	Yx1XlxFMiWgWj3PIiJA0Ly7+E0/aP8/nj7hT/pMxFMoUOezN2wGAtCBSHRMwgq5Jx5CFDRHiuxOvU
	umQXEPeH2CdVY9Ggd4r6tzZTRevgLZSbVX0CbbA7dO6E/HYhotwTk0CANEbG06dkIRXmz+kFna6oC
	uG2N0Lm04kN8bpvX5LXUqXhm3/2SUwk3l+BWtpS2ZhHx/fXFJSUrtUdev0rN+uiFz+6iHyWZt+lT0
	/1mxG19UQesf1LYJK73OHuc3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxRm-00Fdyn-1o;
	Tue, 25 Nov 2025 18:07:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 085/145] smb: client: make use of smbdirect_connection_grant_recv_credits()
Date: Tue, 25 Nov 2025 18:55:31 +0100
Message-ID: <b935d8af5ccbf1a2769f6a1f4f14de94a0bec46a.1764091285.git.metze@samba.org>
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

This already calls atomic_add(new_credits, &sc->recv_io.credits.count),
so there's no need to do it in the caller anymore.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 5b234f44e1b1..5695ba579ea5 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -731,32 +731,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	return rc;
 }
 
-/*
- * Extend the credits to remote peer
- * This implements [MS-SMBD] 3.1.5.9
- * The idea is that we should extend credits to remote peer as quickly as
- * it's allowed, to maintain data flow. We allocate as much receive
- * buffer as possible, and extend the receive credits to remote peer
- * return value: the new credtis being granted.
- */
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
-	return new_credits;
-}
-
 /*
  * Check if we need to send a KEEP_ALIVE message
  * The idle connection timer triggers a KEEP_ALIVE message when expires
@@ -829,7 +803,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	int data_length;
 	struct smbdirect_send_io *request;
 	struct smbdirect_data_transfer *packet;
-	int new_credits = 0;
+	u16 new_credits = 0;
 
 wait_lcredit:
 	/* Wait for local send credits */
@@ -921,8 +895,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	/* Fill in the packet header */
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
-	new_credits = manage_credits_prior_sending(sc);
-	atomic_add(new_credits, &sc->recv_io.credits.count);
+	new_credits = smbdirect_connection_grant_recv_credits(sc);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-- 
2.43.0

