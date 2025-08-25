Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A151E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155442; cv=none; b=MxIrSzpA60oMkjoP9Mj+B4sCriB62KGc3zH8ZvXWYB0UCJya9z0CUrGME5VVFT6zgx6AW/mBHEu6zuyd0TOTAsNJuDC5ADhpBZMCykpM8ZZuEVIYBTJyKpRQDq0x9mQqb4DLn2ldOsYI+cl0IuoUKmR/aVIaf2CCPg/UbNeRinA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155442; c=relaxed/simple;
	bh=BK1EreCOYBHqtR6NohhOfL1N/XLlJwJ96NagpWlaGMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb4dmwj2nMIHeMD3hNJnaoMKfepgaYXxpmYooNeRBfbQa+N/quJbHccYylPEp2W/fPbJRotJo8aid1xwm05Iylm3xo0x7yp9rDjHGN7X3qaGLpgozHLTEkkbsH86RaR0nTthCM4YMgO7SBz15DIcsPwwovUWnBXU8mVZmaXZFWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wG8AyMLF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wG8AyMLF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=k3B6dKLWCEsQ3qGAJoTnM+/iq/jpPsieReUGyFeQr3k=; b=wG8AyMLF4sV1IUSGwYB9y+htFc
	leBVa3ogOPT8e/6CH8wxo/p/L+p9DnrsIe18tvD2NFMWv6YV/dB5FPIqx2+T7djgRWYD0YPSfiFKl
	b0AfXYznRlTgQ9C6o1ptuPVaW7b8Vl83rgWapH+eIr+L5A6MMOfRsufUQ+A6YvxeNTpHPUDyfVmdR
	sfDS2zl328pknysl7jqgxmrtPbr0LBX5POtfnn4l+hmnF48zaaHqP5H/4ND7C0leNyNZwMksti5po
	b7RfvVBI+6mECvfUFX96lELct6+AzUmSofTCuywwiZ/rcYkDV43de5gPIPkdz5KA02KgYKMe9c2IF
	5ZvORel8nQpAiAZaMuluq2xWMxJ//jMxtQArwY4ttNXY57sNT2dZ+0ErZH4ACCqOb7eaMBMr+RZin
	R+6kbLnbDm7oUrcKDvBrAZfU0cV3Ssq57fXdnIj5OtQLtaQysUaPnr4qLA8z2vbtCg2NilwTchfog
	40gdxMlmmXqK6sICbeJ1rVMI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeFi-000mK4-0a;
	Mon, 25 Aug 2025 20:57:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 093/142] smb: server: use disable_work_sync in transport_rdma.c
Date: Mon, 25 Aug 2025 22:40:54 +0200
Message-ID: <588cf97e0590ab4aa5a23c7e3cab17a9b706b736.1756139607.git.metze@samba.org>
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

This makes it safer during the disconnect and avoids
requeueing.

It's ok to call disable_work[_sync]() more than once.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5a64139c1961..fdcf53856665 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -386,9 +386,9 @@ static void free_transport(struct smb_direct_transport *t)
 	wait_event(t->wait_send_pending,
 		   atomic_read(&t->send_pending) == 0);
 
-	cancel_work_sync(&t->disconnect_work);
-	cancel_work_sync(&t->post_recv_credits_work);
-	cancel_work_sync(&t->send_immediate_work);
+	disable_work_sync(&t->disconnect_work);
+	disable_work_sync(&t->post_recv_credits_work);
+	disable_work_sync(&t->send_immediate_work);
 
 	if (sc->ib.qp) {
 		ib_drain_qp(sc->ib.qp);
-- 
2.43.0

