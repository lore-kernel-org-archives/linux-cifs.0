Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040631E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155633; cv=none; b=RreyI3XEbhvVhRUV9oVQ7tNpKzszLi8XDLmU2N0t+cbQF4Wry0GEgZGD7dUNb4qHj1cib4S3eWJ3JggzXNHd8Yabfn18QKRgAjmIhCSx1Ak6KanmCv7lBqCP49czDn/YVNPozo1m8oKL9qMGCSbsOdXrsDbCzQOs4prwjL57xiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155633; c=relaxed/simple;
	bh=SL4HgPP1pgZpcrqsAbaza5GYw2Axus/6g/js4w3C96E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVyUFLsv3f3KmJNgn3EcY0EZ3dsWtW14F/bx8rriA9mXBZ0WebwcUHktK20MoZW/2Xq7ZIFsU5B2u9xgwbBE+BKPdcwViCtzu+wViCHTrOk2oiA9dhl74FbqEOaOAwhgvK2s1ztoC6FDM6fze2lV7rsKDOqS0U5Q/CNbI/juOOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=H48PvL1s; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="H48PvL1s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3fVhp8qoU+SSi2ZphYatk89NVIUBsDkVLa5DmK/brto=; b=H48PvL1s+EjSYZczgKgQCJo13W
	9HdiwwRBVBXkwdFka+quDUBK/1Tj7u/Zm4/2VlP/syDGsL8x7odVFX+fciATqXL8/ma9pk2hBk5Gt
	eJVb2at3g/D/Nartaup0PHIVmqom14XCd5iM8ZfpQOxV5g2tAsYZ9x91wq0kDTEjiA59aHfdP2eyQ
	pOLImore+TVy9wFcq9K34Di8dkD5HGCEJz4bDW3rLteI/Stb34hYdprdeyGMfNy0fELsEamHBUmp3
	4ZGidxplGPS9kaVX4Wv2KxHkKv8m4nJuBgGfN+pjcaDtUqdmwfsNdidqNEt6V3WP3oaSumDnyXyzY
	YAKuqxZ8FJ9UE9HADq+9xrnormSu4dWZixqwHCbIoNonH4Eyr6XcwQwu5lI79h2/inl0iEPYux9IK
	GSPuBQbK1GRgBJffKLu3DKftrGcvdqVuJAs7fXozjBUaDWohEY2VfGnG9T2e8Ys/fxcUvhPqf+3td
	Zuu3vXWLiL7tCozrlrbpmxZm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeIi-000mvT-03;
	Mon, 25 Aug 2025 21:00:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 112/142] smb: server: make use of smbdirect_socket.rdma.legacy_iwarp
Date: Mon, 25 Aug 2025 22:41:13 +0200
Message-ID: <810beadc67c3251432203f88e7b64912c98fc820.1756139607.git.metze@samba.org>
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
index 100ac189b47e..8e1df4eb39d6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -93,8 +93,6 @@ struct smb_direct_transport {
 	struct smbdirect_socket socket;
 
 	struct work_struct	send_immediate_work;
-
-	bool			legacy_iwarp;
 };
 
 #define KSMBD_TRANS(t) (&(t)->transport)
@@ -1624,7 +1622,7 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 	conn_param.initiator_depth = sp->initiator_depth;
 	conn_param.responder_resources = sp->responder_resources;
 
-	if (t->legacy_iwarp) {
+	if (sc->rdma.legacy_iwarp) {
 		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
 		ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);
 		conn_param.private_data = ird_ord_hdr;
@@ -2092,7 +2090,7 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 			ird32 = min_t(u32, ird32, U8_MAX);
 			ord32 = min_t(u32, ord32, U8_MAX);
 
-			t->legacy_iwarp = true;
+			sc->rdma.legacy_iwarp = true;
 			peer_initiator_depth = (u8)ird32;
 			peer_responder_resources = (u8)ord32;
 		}
-- 
2.43.0

