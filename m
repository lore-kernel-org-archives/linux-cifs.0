Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15E28F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155730; cv=none; b=Z8rrx8nlA84fbw/EdGJfxRwtKQYMHxeOnL4o5F25tdX5tE/TFWw54B4qXp6uGsXFUseSss4R+qQanO2nQ6kpduEZR9uijHNm6SV+bKxr7f7/EAAxKHzDOM+TYtjbxb15zgVSjFY4J/VAGhxrM1U4pCMaif3/jd8C/j5e6WTY1Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155730; c=relaxed/simple;
	bh=7CroRAAvakcdrmhlxmae+58UddbmqGT9oNptP5Fom18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSDsLtDw5mOKotWpjhAzicLfdHdv6scOyMtp837B5dY9ddbiVvBJegBp+c6kKQ+g/axfpZiLtJm2wL7s4rLYolkONzSo2r/KRztFff6hLuR11X59+KnAuLgsv5PsEPJDUbUkgx7nzTd5OrbZk9y86jzk4SVr2zMxdSro372D8TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=M2uwVx40; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="M2uwVx40"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4ZPldy4JhW8kGLWLdcF1X01I/GP4jfXl9/QzWYPt/sc=; b=M2uwVx40Rjn2Eo6/odouapGDrp
	KD3qRkBChJ8ABptTrAknbOSn5lWt6hs+FQu66lNKXFcplmjShuaMj/8oyC+9vUCyo+yFuhQ1taUyw
	wH9MQVZhWEIiG68b3tC3flmrepkt0e3eHNpH834byqlFg5MxQppDCm7E+lvlNXODNWRyJ8Qor364q
	xsfOcUX47mT8m1aHAG6AJMw7TNI5vFUNGb8Zn5Ktx3re1kLN4Gs7D3qDn/3tA/qqodBzaurp+wYXe
	orRiElPQh9ejAJZewLch3syfFWDUS52BNwq9+vmp9eZ3166mmwxeFZVHNP/wpzZ4/lUg8zWIlo2+7
	N+spa8zZZUGPN8MyHRKf1hu/AVBf4q8kg20l9uw0zAQ2LBZ8HLKELDKXAR69FjjeSpGQpt3zxHDm+
	Yf5+1miWEcjkyyf7gOugXfcPGhVR+MXwKFgiTE9XK7mFh5BgR4Pm9lUsmWD9KSmigKhRv2lRQELof
	XLYgRipfn5g/n0zlKXBOeags;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeKM-000nHl-2I;
	Mon, 25 Aug 2025 21:02:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 122/142] smb: server: pass struct smbdirect_socket to smb_direct_qpair_handler()
Date: Mon, 25 Aug 2025 22:41:23 +0200
Message-ID: <6eaca00bcff9dde8c04344f6046d2bbe2ce47882.1756139607.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index bcfe0e62714c..c3be52f251c4 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1576,8 +1576,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 
 static void smb_direct_qpair_handler(struct ib_event *event, void *context)
 {
-	struct smb_direct_transport *t = context;
-	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket *sc = context;
 
 	ksmbd_debug(RDMA, "Received QP event. cm_id=%p, event=%s (%d)\n",
 		    sc->rdma.cm_id, ib_event_msg(event->event), event->event);
@@ -1912,7 +1911,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 		return ret;
 	}
 
-	sc->ib.send_cq = ib_alloc_cq(sc->ib.dev, t,
+	sc->ib.send_cq = ib_alloc_cq(sc->ib.dev, sc,
 				 sp->send_credit_target + cap->max_rdma_ctxs,
 				 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.send_cq)) {
@@ -1922,7 +1921,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 		goto err;
 	}
 
-	sc->ib.recv_cq = ib_alloc_cq(sc->ib.dev, t,
+	sc->ib.recv_cq = ib_alloc_cq(sc->ib.dev, sc,
 				     sp->recv_credit_max, 0, IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
@@ -1933,7 +1932,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.event_handler = smb_direct_qpair_handler;
-	qp_attr.qp_context = t;
+	qp_attr.qp_context = sc;
 	qp_attr.cap = *cap;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
-- 
2.43.0

