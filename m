Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FBF3358C5
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744859; cv=none; b=EmNY6apLSTdXFpSxfgcRZRoK+8/dvvbteISh7Qhi1ASdzjKpHeVmwQH2iPgcHf7wK8YdLP7NYcHJYelWfvvsEDsJz7QwqnlhyUEgkRpv2a+awoxxibu+dygRnakDxiEHWCd+N0tGpn6Kspasf/1bRR1fUPU6B8zYKu58vi+7yek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744859; c=relaxed/simple;
	bh=qu91WxAEBNPxgpFnoi8Bc8dp52RTMYHYtSr2JZ+yRNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwq/7eIELLVGkSRXGp+KOZK1NdsInYqxGjpRRRjH4cFyL2k+V8AAJVJi/OzdnCQzbQyp2+Q5uKy7CsDC54BQZpUPimM5+v+PUwxtLbmpGGhEtDxBt13QFne+zowsAnYiFlh3lNDi5IwRJPnBV6Daq5G4/gWRzicRqBthfKtV3lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JS/3IZv8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JS/3IZv8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nhAdaTJMAdKZUNClUnrDVUlzVRxvoM7BSULl5H21iQ0=; b=JS/3IZv88ZdLQl9hRH2RZUNg8z
	yrjC+TSMoE7NVykocj8VNpPgTaJP/81fiUWCLfIynKzqDWFx6xPHivBVpEWn2tdUKwqNu9IdljuS9
	m9ndRXAznIaD2oe5popVmlJotdBQKwHmryxRs8dJxpKZrcpKwiLwd5/L9zpOY/WQ7PHkM3gR48LBJ
	YRLfunaitH/HPVT0qvP75f3/TNrZYmPXzUJeW8gkhPOH5vhqXFzmyZaU9r16OpKsXRDX7sUdQTXCF
	ieVrujKT2b+eRmYsjtF+bqigxx0qEpcamk9s26WJBjRQwXfrthUdct+JCbaTkclDuqExKUbERlj9i
	GCNXWTcBbTYsQc+BhDOBGrMovPGYPJlMyH8+uFZmJ4edH5S34d39ohrvv9r/XRxWpi8Z9nYyNJ0T6
	kRL+trUKNxvwHvMmpHVf62KnwJf1xKDqAMd8JDXFNgpffm01xaqTkw6DO8ea7FH4UDzJIWtHCuSqr
	Jaaicd+nKUtT5Fq4Cr4fbkFV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ja-00Bd1v-2U;
	Wed, 29 Oct 2025 13:34:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 117/127] smb: server: make use of smbdirect_connection_request_keep_alive()
Date: Wed, 29 Oct 2025 14:21:35 +0100
Message-ID: <cbc34a7d8372a2d59120a012081f4c0b442e7be9.1761742839.git.metze@samba.org>
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

This will help to share more common code soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 55757c66cd44..72cd64149785 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -492,23 +492,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	return ret;
 }
 
-static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
-		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
-		/*
-		 * Now use the keepalive timeout (instead of keepalive interval)
-		 * in order to wait for a response
-		 */
-		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-				 msecs_to_jiffies(sp->keepalive_timeout_msec));
-		return 1;
-	}
-	return 0;
-}
-
 static int smb_direct_post_send(struct smbdirect_socket *sc,
 				struct ib_send_wr *wr)
 {
@@ -644,7 +627,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-	if (manage_keep_alive_before_sending(sc))
+	if (smbdirect_connection_request_keep_alive(sc))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-- 
2.43.0

