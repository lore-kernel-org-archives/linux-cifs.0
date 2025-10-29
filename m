Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B2F1C5D46
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744632; cv=none; b=tNsHvZo0bc5IqJKg8q6LAE1/xhcDt4NqAm5VQC6zUS+rTSL/ASckjcR1HqcjpHxJyfOawrq14KZLElHYmT6mKBFROHXBMZRc/Dqm/I18MLBrAxCKaO2XJjUQLxPnAdYSLPsFyPw0EUC/TpYi0bOT0OSLD6zOkM963Wc5liRCAQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744632; c=relaxed/simple;
	bh=loDzfNBjpbEjkieUYv8dWQwH7JGBRnMwOFs/dDbUfvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc5zHccxAhZi3azC1+LjU0zmPmZzM9Ysdy7JBu38qrfHoj4nxQ7dLfbEGfmbksuHlpaP7OJX8yB99OV6YkWi7mPDiU0mcBY7xqbbQA+b7JN8SS90gY0vp3h6AlSf9Nvm1pgtlQj0uvaHCyt5Pif18Inuk8ssGKXmrO95HFt8bzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=m48SAipM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="m48SAipM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=T7xlnEa4PhrAtzipy5xpLO6Xbg8QdMaauTa9svLYSeI=; b=m48SAipM9O2PpAOfh6w1j8MqGN
	GQ7J0iZoGqbDA/PpEvNM2ZPXklKPnW8tJvX5hXyN5WstL9dLx2P7ev6q8G5k3nPlMInir/FY6FH1C
	DreWnaDUHIeLKIlDhegR+NOQrQxue3pIlZk0FKNwzFkJxXp2pHo9oWc7tMkmTdNKY1J/gDsRSCpl+
	m0vY+6ErglZMs5FVhCCVEIErp/6I8w1XkXQ8Oq7HUHcxl/9CFLmg/qWcPUHY0TLsV5JAVOEOY25Vr
	ZTqqJhrV0IIKpvaC29MJ67T9Voj/tqUuHRBBPwt4Q9r4t34Pm79SoN7P3YirJ1BYtLtuSijWE388i
	LqDzh123e9kzBuSMPFfojVxr7ZsM/eNG1gTg0faCqQMDxxzujv8dIYeuNojoE4k9inFrD8CPMshKM
	rbGDe1/N7LJaThoim7m8RylLRzQ2GqFqXL83fuciiuzyKRCrTCsz3GaiopkgqvW70zgMP8/E+s2XS
	dGbvk6ksK61zLMhfs0ICG/ru;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Fr-00BcOU-1A;
	Wed, 29 Oct 2025 13:30:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 080/127] smb: client: make use of smbdirect_connection_grant_recv_credits()
Date: Wed, 29 Oct 2025 14:20:58 +0100
Message-ID: <4c474fcfaa14b461edd8fccf31936a76005b5354.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
---
 fs/smb/client/smbdirect.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e2f93d4af0a7..cb1e7dee9be7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -730,32 +730,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
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
@@ -828,7 +802,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	int data_length;
 	struct smbdirect_send_io *request;
 	struct smbdirect_data_transfer *packet;
-	int new_credits = 0;
+	u16 new_credits = 0;
 
 wait_lcredit:
 	/* Wait for local send credits */
@@ -920,8 +894,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	/* Fill in the packet header */
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
-	new_credits = manage_credits_prior_sending(sc);
-	atomic_add(new_credits, &sc->recv_io.credits.count);
+	new_credits = smbdirect_connection_grant_recv_credits(sc);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-- 
2.43.0

