Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3793032C333
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094176; cv=none; b=HSN94yxkjxEZyUUNLptT66SUA4WbDpVh18A9NAocAvdf7BoDBc4mGUZmi3NBPtMeK40SfKaZjwj1ZdSQSB1YSlGjuoCgH4m2k0nQo831a0q+8u4LDFBJbuTaH/Z+W1ha/CWGY0MTkvJ9wXcHBJSo3H7txJ0FRw0Sh6YUOSjt0SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094176; c=relaxed/simple;
	bh=rRHobCtt5wWB5EMzRaRrVGxlYyDd65a0s88kIbGebMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B45LbhKXgMtj34ACFjk6H6RyK4OGxF58bPQZXiBDajV5WpiINf6wOAXAcJy1o1DkOEZRZB/qn2cCxTMhD3NPteaeGLfSl43cRYkRWAj9yoKafiBJUtR3dKh1ZejBHyVVZgybusdJ6uSZmG/N87lTQ5g4E0vvyGpUj4rNCQ6Ti6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3rgXF7QT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3rgXF7QT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=fqHPvtMjMkvOI+6JWcJUnocC08qNvnbm5/Vkzdae8Ws=; b=3rgXF7QTHm3GT3WtY94R6MyasX
	Wfug8L/42BlDr5/0ZHKMxomZUTaJ2UrjfciMK8BVCkSaKfPBmGXe2TMfva9NyXi5yFyRhQZUT0smG
	EgbEJ1r5XGSvV6hKZcBjKRqm5lcwiuIEbCaPoqKfpXt7WgsFAmxAH4i7Uq7Mqd2kCW1JLdkrjSesX
	ZzDLVT9BTgk3N+7AxTS8npkLgGB/af2SxDjvRlbpGIb3kuAA3MjCHXvu8gV6cdOJWLtd3lEJCQ5jV
	htrn7F9SInfZVfFo/f8RQKR2ahm9NlxQQBKERJCRDnr0uksWscKVvrkrI6cUwV2uxMaJtj5uL6htd
	Pev3ks9grMswSnC/PNyxC0Dyw5nMXvMldjXebhGmNMjPP+Og2kiuecEdAQpsPbA1eXigx8Ey3ZjQk
	7kfKMdBSHK/bs/O9lcf7qlfWtC7RroDPongKO0OxlWk/9JjAqPGfhEpfvJ4Sm2Fi+YefFQxYmjS1t
	KUpGp/ab6OyxQolKM2qbu8Vx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxQc-00Fdk0-1O;
	Tue, 25 Nov 2025 18:06:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 075/145] smb: client: make use of smbdirect_connection_qp_event_handler()
Date: Tue, 25 Nov 2025 18:55:21 +0100
Message-ID: <8ec0819d52cbf8548594173a9129521a725b879b.1764091285.git.metze@samba.org>
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

This is a copy of smbd_qp_async_error_upcall()...

It will allow more code to be moved to common functions
soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 81130420434e..0d5674461058 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -343,26 +343,6 @@ static int smbd_conn_upcall(
 	return 0;
 }
 
-/* Upcall from RDMA QP */
-static void
-smbd_qp_async_error_upcall(struct ib_event *event, void *context)
-{
-	struct smbdirect_socket *sc = context;
-
-	log_rdma_event(ERR, "%s on device %s socket %p\n",
-		ib_event_msg(event->event), event->device->name, sc);
-
-	switch (event->event) {
-	case IB_EVENT_CQ_ERR:
-	case IB_EVENT_QP_FATAL:
-		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
-		break;
-
-	default:
-		break;
-	}
-}
-
 static inline void *smbdirect_send_io_payload(struct smbdirect_send_io *request)
 {
 	return (void *)request->packet;
@@ -1479,7 +1459,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
-	qp_attr.event_handler = smbd_qp_async_error_upcall;
+	qp_attr.event_handler = smbdirect_connection_qp_event_handler;
 	qp_attr.qp_context = sc;
 	qp_attr.cap = qp_cap;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
-- 
2.43.0

