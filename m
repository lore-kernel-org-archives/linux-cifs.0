Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330853363
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491264; cv=none; b=Vmc0EIQQHRive3repBIF+g8Bk+Wu8JkazHX9QlqcrwLBcLJY4WZhTYUIt2JbAu8xGgHfD4zj62Dv8nUFvq2WacIZrQZrzcr9Wr8LdRTGzV02EQlhr9TzzKjN3lxNbl3hanwuxfp+0kU6xMoQ+49bxPOyiuOpEBL7ShppXJnWFuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491264; c=relaxed/simple;
	bh=vGFpNqSlCYQN8lF1vLD9X2SWbE+lhhYoEKrQDJGNM4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uim2I0qbD4jkI1eH2mXMAZ+AxjdEoz1LMiteY+eNZrgz7qXYR/H6ceQH3E37oyDIAOKq9s7sAfTIyzuJ90VtzX8VeEcSe/jucxhPCsLAqAHH85hULyPT8rAP1u6+eD7psv1egap6x5UV6Nr4h7BvK6H63snvc4CAJaCu9hLgUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jyQP7Guq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jyQP7Guq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9fPlSZjTSeA7ZT+d75K99j3yp/kAs4TCfVlGx13PX8o=; b=jyQP7GuqMEbx4w5BwTCnNui58y
	0d/ZidjyY6iCrJgwh27qdbuLPtq+WsYvc56+c7OJaduHV7yWVSthMGe669eR0meoD6P2fr4Ofcjjd
	Vx6C6m05WLHidOV+kq6tu8ATU5Ey9UKo3vS53wODGmxWjLo3iCo6niJyFzciPTXt8lg/0vUs+dFeO
	3AHrQZfeeZF3Pz24Wk4u/NuWePoU/5apfacAqShxlZGmXiCQ9izggUiJq+kjOt0TDAUEUPX9pmFal
	WDEPrr4LTto0rfhJ0IEqv4mEPI1/D9HBFYy0Ys6L2Pbqbz7HYZYFbBtzXgNQmZCxh+Ju8UUtpTjnV
	LYJqcyUz2l33eStEPwpqXKrarU/o53lTowP6L+UJSYI6745yv+erPB6nAC2ecISgRgSnq0QmYdTdY
	tZ9ORkLLqxZUWz0k/vVLVJ8FisGM/4x1gfFvpR5fpWac0hbAdg07V9JURDKHzdNJAYCITL6ZQ7V++
	eVuGl9xfRhQua2jrLx80EVfW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RuF-005GjT-01;
	Sun, 21 Sep 2025 21:47:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 17/18] smb: server: make use of ib_alloc_cq_any() instead of ib_alloc_cq()
Date: Sun, 21 Sep 2025 23:45:04 +0200
Message-ID: <dea11c65e08de35b013a6d25a0104a8e2203c5d6.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 20cf4e026730 ("rdma: Enable ib_alloc_cq to spread work over a
device's comp_vectors") happened before ksmbd was upstreamed,
but after the out of tree ksmbd (a.k.a. cifsd) was developed.
So we still used ib_alloc_cq().

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index f9734d7025b4..e78347831d2f 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2037,9 +2037,10 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 		return ret;
 	}
 
-	sc->ib.send_cq = ib_alloc_cq(sc->ib.dev, sc,
-				 sp->send_credit_target + cap->max_rdma_ctxs,
-				 0, IB_POLL_WORKQUEUE);
+	sc->ib.send_cq = ib_alloc_cq_any(sc->ib.dev, sc,
+					 sp->send_credit_target +
+					 cap->max_rdma_ctxs,
+					 IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.send_cq)) {
 		pr_err("Can't create RDMA send CQ\n");
 		ret = PTR_ERR(sc->ib.send_cq);
@@ -2047,8 +2048,9 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
 		goto err;
 	}
 
-	sc->ib.recv_cq = ib_alloc_cq(sc->ib.dev, sc,
-				     sp->recv_credit_max, 0, IB_POLL_WORKQUEUE);
+	sc->ib.recv_cq = ib_alloc_cq_any(sc->ib.dev, sc,
+					 sp->recv_credit_max,
+					 IB_POLL_WORKQUEUE);
 	if (IS_ERR(sc->ib.recv_cq)) {
 		pr_err("Can't create RDMA recv CQ\n");
 		ret = PTR_ERR(sc->ib.recv_cq);
-- 
2.43.0

