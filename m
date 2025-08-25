Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3049A143C61
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155182; cv=none; b=sNBGVO1U75WZeNav5KgXPCzq96xR/racPD5riYXziYimnh3CXr+jSMLLP0C9vI0Dr3xkgvK/JebRdRo8ib/EWq6GJQ/Wa74Rrs20zsXSkI+TIbMYBUZz85LDp61/Y1dTs44hx9Gou3f7Sm0EvOKYnhnALi6ET8bsu3j4pMtj29Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155182; c=relaxed/simple;
	bh=JiqwH1jKUq1EAAS5wSjW90/50PFgJlQzom153gqYPTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhGpsPB/LrKVQFk6GcEeQ3NUj/se506pNEQzFmEOWWieGzCY6DvmlanxX2em7o5xJqoPsjexpoQuW5T9clcSYsuMD80uoqr+Yng3aLVrgKihVnuwLr5jG+ArrnEBELJmOVCRG7UdkCDAT+CeydCe30HTqox5sTlPZoH9B/keTro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IkIF80jg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IkIF80jg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=FI+qEL5myJk6s0GuUe2FtCh+ykqBZBfnhHlRKn1q1XA=; b=IkIF80jgAwdT9F2vAktZdMAtbP
	IAv2P2gVCseiXI8L1r16Yw647bjXu2WeClAPCP+laMN+SSnFffemmZn/HppUGWajemiz/TI52jKJw
	b/Ty9w16ErImqXhEOdE1XhEJriQJSqsHVF5OXj8zPGt9A+vW2k1QjQW7vCKnbq4v3sZrJnVL3WOBk
	/TriWvbhhVTy8UMiWcwwhk7YXweF2zqgrzMrEP0UcNQkc33u+ACK9GKiQPSncpa9O7Gs/REzl/z8j
	JevnzstHSrV2frm1uRX0L0ALxdGrciu1c7VoeGYvAD99U0fm3mBixn//gdZa/RQWnsuHE5VchpG4B
	LA/bFkYz2zrNT2kf7y7J/aEwTW35J2x2X2LUwyZgo145+G9xJz5U1cPfAuJ1Mn7pnFlRRQOFdAByT
	yNw+1k1KOwiCB31dSOGUcb/XMKkCgEUjjfmse+W0vvNL0GVtEgNiQx/dgRmUrPxWhptsH1587YGRV
	eLQSQTam5Sg2Q3Ajd5BzRuEQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeBW-000lTE-0I;
	Mon, 25 Aug 2025 20:52:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 067/142] smb: client: pass struct smbdirect_socket to smbd_post_send_full_iter()
Date: Mon, 25 Aug 2025 22:40:28 +0200
Message-ID: <a0c9463c4be4f91a9ad0fc49f7c99d2b5e534788.1756139607.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b9ea58e8db46..baeda2192a27 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1145,11 +1145,10 @@ static int smbd_post_send_empty(struct smbdirect_socket *sc)
 	return smbd_post_send_iter(sc, NULL, &remaining_data_length);
 }
 
-static int smbd_post_send_full_iter(struct smbd_connection *info,
+static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    int *_remaining_data_length)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	int rc = 0;
 
 	/*
@@ -2104,13 +2103,13 @@ int smbd_send(struct TCP_Server_Info *server,
 			klen += rqst->rq_iov[i].iov_len;
 		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);
 
-		rc = smbd_post_send_full_iter(info, &iter, &remaining_data_length);
+		rc = smbd_post_send_full_iter(sc, &iter, &remaining_data_length);
 		if (rc < 0)
 			break;
 
 		if (iov_iter_count(&rqst->rq_iter) > 0) {
 			/* And then the data pages if there are any */
-			rc = smbd_post_send_full_iter(info, &rqst->rq_iter,
+			rc = smbd_post_send_full_iter(sc, &rqst->rq_iter,
 						      &remaining_data_length);
 			if (rc < 0)
 				break;
-- 
2.43.0

