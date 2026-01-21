Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C62F3ACA45;
	Wed, 21 Jan 2026 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025070; cv=none; b=P6IueMbCgojnThNrPHin3K3YSSOQ5wa9RKVZiOpesLf8lt1L3iF4xkzDrzFkTP8uftKJbLNVQPcbDRounPmK9bnaRTCxSNtpoZiEHx2tFq8Gjq2UCdxbkuEMWobiIaivbMSUaD2ghZCAAnd2c/9hzDxGX5h4WxHtBbDT3Np0x9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025070; c=relaxed/simple;
	bh=f5CKgwSLS8sIX9f7qQ10kRNg0IfK1oDSU7S3qSmW4v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl496uD7l7A0s2UgTYbtjUy4zzFZv5amxpKYAR1IZtD6/APUn0tbCA4Mqfi3Jia1IgAdgylGqiy7IC3NvyMQGQIp0WYA9+MphBz3L89e2T7kT6B/hpASa76PpaI/t7G2ZPoFjANZOFmcfkiU4uDqLsS/vqf7IgvX/AwhjCQ9Dwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oFScl9iE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oFScl9iE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=fJmlj80WUcNxr4U7ZdNDDwx9gkNNT1YGeJu+IvYRbts=; b=oFScl9iEIp6oBb8x8K8Hv9aRNd
	5oTQ/t78NcVIIxSUVOVs7O6SlfR5bkxYQe0QxFAvnqhKdHpfOGiqHzhJdWeIJVA3g77SNMYTSMCbT
	ULYyBsss5mA0h/G80WTMHwfSQF34sx4WquEuJgO4LtKy+tALpC39JMz0IN29y6o6J3nH/FkRgaYAz
	MxGWmklZU/Ii2k+OW3+YCIyjmZPJVwjdC37N8mxhzC7UmfJnAPhqnd5xaXJ4lec3g6GCdK9wa9y3t
	yJymd6duTmvqil8MrthQlOwpfjPbSq3zjuttoXWeyXENnLOYnet22RONdvsExKKcG9aXxbGEUjd8b
	3KjwV996u6CfoEBGMB3uk+ZwN6fEyauy+MV8UJDa3ejWpu5qvxhXaGM6sUHDiPohCQPLBH31dgE9y
	/G3FAf0N0zK8UjcB5rtM0jSUNFldarc/ooYsXq6S9OfZR8h5GSqoPadZWlmbDjqr7MNOlU2P3LdQN
	boi07ee34WtIh9nYGwrFkIPN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEL-00000001dz3-3O5f;
	Wed, 21 Jan 2026 19:51:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 03/19] smb: server: make use of smbdirect_socket.recv_io.credits.available
Date: Wed, 21 Jan 2026 20:50:13 +0100
Message-ID: <d70a09dfb7346e2c1a467610acda96699c91cf55.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The logic off managing recv credits by counting posted recv_io and
granted credits is racy.

That's because the peer might already consumed a credit,
but between receiving the incoming recv at the hardware
and processing the completion in the 'recv_done' functions
we likely have a window where we grant credits, which
don't really exist.

So we better have a decicated counter for the
available credits, which will be incremented
when we posted new recv buffers and drained when
we grant the credits to the peer.

This fixes regression Namjae reported with
the 6.18 release.

Fixes: 89b021a72663 ("smb: server: manage recv credits by counting posted recv_io and granted credits")
Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 05f008ea51cd..c7abd621bd11 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1028,6 +1028,8 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 		}
 	}
 
+	atomic_add(credits, &sc->recv_io.credits.available);
+
 	if (credits)
 		queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
@@ -1074,19 +1076,37 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
+	int missing;
+	int available;
 	int new_credits;
 
 	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
 		return 0;
 
-	new_credits = atomic_read(&sc->recv_io.posted.count);
-	if (new_credits == 0)
+	missing = (int)sc->recv_io.credits.target - atomic_read(&sc->recv_io.credits.count);
+	available = atomic_xchg(&sc->recv_io.credits.available, 0);
+	new_credits = (u16)min3(U16_MAX, missing, available);
+	if (new_credits <= 0) {
+		/*
+		 * If credits are available, but not granted
+		 * we need to re-add them again.
+		 */
+		if (available)
+			atomic_add(available, &sc->recv_io.credits.available);
 		return 0;
+	}
 
-	new_credits -= atomic_read(&sc->recv_io.credits.count);
-	if (new_credits <= 0)
-		return 0;
+	if (new_credits < available) {
+		/*
+		 * Readd the remaining available again.
+		 */
+		available -= new_credits;
+		atomic_add(available, &sc->recv_io.credits.available);
+	}
 
+	/*
+	 * Remember we granted the credits
+	 */
 	atomic_add(new_credits, &sc->recv_io.credits.count);
 	return new_credits;
 }
-- 
2.43.0

