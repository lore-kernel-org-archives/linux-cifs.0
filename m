Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEA728F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155778; cv=none; b=jyCnfJej281w+bTl0rF5roPxhTYPBkTj8xPuIBRRjV9TbxiesnX1b61PeYZroRzzWl9RhP0oTIMOZj0cFOkluxHGNcjpss5dbFnUgui7uD3D/w+ZwsFFZSRtTF4VrbwAcSTZt3OLEI4odZdIlYzNF6ehDMk6xKw/cHkn3TUBGCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155778; c=relaxed/simple;
	bh=rBc1MxgaNDEqxZjyuxBq4/eZWjN0tl0FP9bnvUuI5ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUXFSRxbJ0hYwQ+3WSi8ijizpZWr31BxLu7WXZap3+HloOgBbe+I+pSGaf8jURw3R7ij4QGPFLTQQLBKpUBvxplvp16angvoIgITtyfqd9pafp8hO8rpyBy/dqo3TmzotBOyT+F3Pb3hdKnwShxN2wPmWnzJ4Wlmxl4/0m3Vu8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ozTjWVOX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ozTjWVOX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=sEx3QFdjEkA0y5gDw1Fi6L8D2zym5QFaV4mLVFpID2g=; b=ozTjWVOXWkX0TOlKkzZAgAgIBy
	7UBqOSZsSveJIqRmVt8dPneYI0GjC83TIfIEPGtGj4T1zWOmWB12t7V5tBDvdhZdOMhDNKuSTs6Pq
	D3FzdnFadPovSPDD3AdmziimXgBpCKP17HSDOBKiaxlCNBeHr7jvWnc4ZFjsaW3Z9VISNda2Frxak
	nn91uNVbFa2ZpTUAhRDi3HEf7ol/h7J+IwFh0V1b/4haoeoUm+2hRIQk7Zp4eOKEAqlaiqy7c923G
	mHHPgVGK59YDa12ngob328+hADybVVlONFP9N6810ljnw8lbeMkFeU73tE0tGDjhj3Ke4YwWWpaOR
	vWRul+7wcuk12DuIvgLCIUQFfQMZBfSPMQVjpEVMhzy2FrH3A8EJnwIf2eKPMQ7ZRm4D1xVIDHL56
	NryGYC7xqaeW0I614nZ0AXnapcclNPaisqv/adzWFkjAJuTQpxbzQG+y/1QsB+Oxe66/zifEdsLZN
	M6JFSAKYU/ENgbEhV6XMRhUz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeL8-000nRT-0J;
	Mon, 25 Aug 2025 21:02:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 127/142] smb: server: pass struct smbdirect_socket to smb_direct_connect()
Date: Mon, 25 Aug 2025 22:41:28 +0200
Message-ID: <6744a08262b4b7df63ee1a8576d8887407a6f270.1756139607.git.metze@samba.org>
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
index 48f739af65e9..4551abb7bf92 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2038,11 +2038,10 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	return ret;
 }
 
-static int smb_direct_connect(struct smb_direct_transport *st)
+static int smb_direct_connect(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &st->socket;
-	int ret;
 	struct ib_qp_cap qp_cap;
+	int ret;
 
 	ret = smb_direct_init_params(sc, &qp_cap);
 	if (ret) {
@@ -2166,7 +2165,7 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 		sp->responder_resources = min_t(u8, sp->responder_resources,
 					       peer_responder_resources);
 
-	ret = smb_direct_connect(t);
+	ret = smb_direct_connect(sc);
 	if (ret)
 		goto out_err;
 
-- 
2.43.0

