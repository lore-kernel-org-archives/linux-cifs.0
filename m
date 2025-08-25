Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58FB1E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155693; cv=none; b=HF0MDA9nQh0IchZSjdmD9eG6D7O+N1mA86Lum83wNfCks2R0Cd0IVaWI/+WnYYU2rtONqrm4QXs2QegvmUO8wjNVP2oMBs3LIZprDy6c6amaEJWvzraZmzCzSaL6s8BKQQyDvpjwWVxTrSKaEIhczIP0ILAhWUZaur67mUcDcvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155693; c=relaxed/simple;
	bh=ND5+yBfDLMocgUpaInetkdHxqeb3HAu8qehNyc0XmzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLZKZE90YwKtiVe6NKXIaC7PXWX+UkiPC98k7aH4XvwP6yiGiAtzDfEf8W1d+0kTaUpWKIwlKfqWGz6rZlOzf/Xf5c9ylmnw/42yLnsqniN023aOyA00iIDFJKPbMB8WbCdua1+t4+vW2mJRw0Kg/osrNWUcTztS2Mbu+MJxnS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ueZRU0RX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ueZRU0RX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vj8FPEHoTwHX2uOxr7ww/agmAMJWfZnIq6G/jKoRBGI=; b=ueZRU0RXpzsr+nT37s3uRdjCEc
	cmCttACNAlTHNOOvYP4ZCrsEOSAWrXzMzTpp62/M/n4t+YOQpLRib/GIUP935GLqKM4O7z6PV0RP3
	8ViWk9It2PKVVvPBYGUMjz01vs/Ayx2PXRRuKgZuL2YxfMxuGndrBDewqvqumb3jBIt1aNQyd3HzO
	K5kn9+wWOJ6lrTxicLFOfIc+YGxSJ5SL7FxIyMWVsEjVWz0pWVUhf0nK5YOuEP1O4n1O9u1X5ICE6
	KgmpwQCBprD1klIXDQ0Gti4jF17QFHN8Jidva/3ugimWXw2XLXA5XUfgJEtzE/GUt8o9JzxfBvpxt
	RkgvLbiaBTEDmcN4QcK27YyZvoiORhn8FuW09oqrKwGEf6COEANYsJue5loWX6EI4ovXzkK/V2Lyc
	IgBTdIKToMorUVs4EbxRX3kp58PZysF53qJEdv+Wb05NFgnjnAQWareodM5UGxb6HRiuTVJyCFW3u
	qw/bsNRL1LK6IKkrsWNztvlK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeJk-000n9G-27;
	Mon, 25 Aug 2025 21:01:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 118/142] smb: server: pass struct smbdirect_socket to smb_direct_get_max_fr_pages()
Date: Mon, 25 Aug 2025 22:41:19 +0200
Message-ID: <78953f40483affa55c3a85daffb4e60b74a59d69.1756139607.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 1aabd617c6ec..08f0128c804c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1749,10 +1749,8 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 	return ret;
 }
 
-static unsigned int smb_direct_get_max_fr_pages(struct smb_direct_transport *t)
+static unsigned int smb_direct_get_max_fr_pages(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
-
 	return min_t(unsigned int,
 		     sc->ib.dev->attrs.max_fast_reg_page_list_len,
 		     256);
@@ -1783,7 +1781,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	 * are needed for MR registration, RDMA R/W, local & remote
 	 * MR invalidation.
 	 */
-	sc->rw_io.credits.num_pages = smb_direct_get_max_fr_pages(t);
+	sc->rw_io.credits.num_pages = smb_direct_get_max_fr_pages(sc);
 	sc->rw_io.credits.max = DIV_ROUND_UP(sp->max_read_write_size,
 					 (sc->rw_io.credits.num_pages - 1) *
 					 PAGE_SIZE);
-- 
2.43.0

