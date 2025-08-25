Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6919C28751B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155759; cv=none; b=m1Yw+5//jL5BZeX9RL8PFcJ6FObn2TLJKNwjjaCK7kHqq4xNy7ARkq7/kHLleVKxideq3Xg+eGEg2rYbBVZnBeYEbBGWpur9wzVGcchuYgLgY5fuujidoTEMzx9+Dx672rXAhIS4l34So2Dtom5FkLpNSEM1+TXbhwu01j2P9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155759; c=relaxed/simple;
	bh=Zqe7l+Vm2fym8eHEjDIj67Ln4S7fCHFwBB2Qv8gf84w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCycDB91bRy2Nyi/XNQff+REkP/770AsNHJRizME9kGkBD8VYnwsOSl7aG0N5dUt1LeZ3I3Mm/iTR83cduO7O/xdGbGfJZsIsnb+CAvoPLd9wOcR1LjHa5YT3ZgS3H6yGap/1m+7q7/biEFZPxKKrf+GAneuL7jkFZfTwDdURM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qTJBNw78; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qTJBNw78"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xVjElxzo01vce2UlkRdu5Ph77c/46mdDTzRPpDbX8zU=; b=qTJBNw78jPyXwYSYJ6yijoOWwt
	1LP7QWMyCok2HgesXRbAWhfvA2whJpy23CXPFRC47m09PeLSARwJCJSRFNIoWSy/C75V1vu9vyOQ8
	5JQ7TKDaiYOsa68/RAP6xeE5g3FO/mczMBv9m0D3v82ulIQU4tRS3N9SXtIBOaVlyWLSlp+6+Wwd9
	JPGfbFWF1UUvKon7MQMbI8dXAxx69MI6cE9y2Mq4ZIDSe082AN34nHECn03TNZnJafUyzftKXsI8T
	IfC0c1VF8qDVKZRldGe/uHlfqiMYzqWdB3wBCAvDvVLahbMxMUYgl7NGUW2kztOUH1FoBCk2yad1T
	8hQAT1gb0Kl4jrf7xqTIg0k1UdVwDUODvDWuWlwK7y88Hkt0lvpeN7+TAGXGOlkTb4ecHbGVye2D+
	gVzJtjMGC+1jn54SPFWqwwvv9+6LUUsrec+EADNwxwDwr528u7hPxnFUOp5KvfeBYZOcrm+LonOeg
	cjEDuNBKmDN3rp2pNda4zWMg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeKo-000nNO-1C;
	Mon, 25 Aug 2025 21:02:34 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 125/142] smb: server: pass struct smbdirect_socket to smb_direct_accept_client()
Date: Mon, 25 Aug 2025 22:41:26 +0200
Message-ID: <65e3af9b8ddb10ca302d7b0491dad831c46f1535.1756139607.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 21271c8a9573..99a8e1b1860d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1656,9 +1656,8 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 	return 0;
 }
 
-static int smb_direct_accept_client(struct smb_direct_transport *t)
+static int smb_direct_accept_client(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct rdma_conn_param conn_param;
 	__be32 ird_ord_hdr[2];
@@ -1725,7 +1724,7 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 		goto out_err;
 	}
 
-	ret = smb_direct_accept_client(t);
+	ret = smb_direct_accept_client(sc);
 	if (ret) {
 		pr_err("Can't accept client\n");
 		goto out_err;
-- 
2.43.0

